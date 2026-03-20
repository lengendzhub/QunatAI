"""QuantAI model training script.

Fetches historical OHLCV candles from the Deriv WebSocket API, engineers ICT
features (Python port of the Dart feature_builder.dart logic), trains a
PyTorch LSTM classifier, and exports the result as an ONNX model compatible
with the Flutter app.

Input tensor  : shape [1, 30, 24]  (batch=1, lookback=30, features=24)
Output tensor : shape [1, 2]       (long_prob, short_prob)
"""

from __future__ import annotations

import argparse
import asyncio
import json
import logging
import math
import os
from datetime import datetime, timezone
from pathlib import Path
from typing import Optional

import numpy as np
import onnx
import torch
import torch.nn as nn
import torch.optim as optim
import websockets
from rich.console import Console
from rich.progress import (
    BarColumn,
    Progress,
    SpinnerColumn,
    TaskProgressColumn,
    TimeElapsedColumn,
    TextColumn,
)
from sklearn.model_selection import train_test_split
from tqdm import tqdm

# ── Constants (must match lib/core/ai/model_config.dart) ────────────────────
LOOKBACK: int = 30
NUM_FEATURES: int = 24
OUTPUT_LONG_IDX: int = 0
OUTPUT_SHORT_IDX: int = 1

# ── Deriv API constants (must match lib/core/broker/deriv_api_constants.dart)
DERIV_WS_URL: str = "wss://ws.binaryws.com/websockets/v3?app_id=1089"

SYMBOL_MAP: dict[str, str] = {
    "EURUSD": "frxEURUSD",
    "GBPUSD": "frxGBPUSD",
    "USDJPY": "frxUSDJPY",
    "AUDUSD": "frxAUDUSD",
    "USDCAD": "frxUSDCAD",
    "XAUUSD": "frxXAUUSD",
    "XTIUSD": "frxXTIUSD",
    "BTCUSD": "cryBTCUSD",
    "ETHUSD": "cryETHUSD",
}

GRANULARITY_MAP: dict[str, int] = {
    "1M": 60,
    "5M": 300,
    "15M": 900,
    "1H": 3600,
    "4H": 14400,
    "1D": 86400,
}

DEFAULT_SYMBOLS: list[str] = ["EURUSD", "GBPUSD", "USDJPY", "XAUUSD", "BTCUSD"]
DEFAULT_CANDLE_COUNT: int = 5000
LABEL_HORIZON: int = 5   # forward candles used to generate training labels
LABEL_ATR_MULT: float = 1.0  # minimum ATR move to qualify as directional

log = logging.getLogger(__name__)
console = Console()


# ── Data Fetching ─────────────────────────────────────────────────────────────

async def _fetch_candles_async(
    symbol: str,
    granularity: str,
    count: int,
    api_token: Optional[str] = None,
) -> list[dict]:
    """Fetch *count* historical candles from the Deriv API."""
    deriv_sym = SYMBOL_MAP.get(symbol.upper())
    if deriv_sym is None:
        raise ValueError(f"Unsupported symbol: {symbol}")
    gran_sec = GRANULARITY_MAP.get(granularity.upper())
    if gran_sec is None:
        raise ValueError(f"Unsupported granularity: {granularity}")

    req_id = 1
    candles: list[dict] = []

    async with websockets.connect(DERIV_WS_URL) as ws:
        if api_token:
            await ws.send(json.dumps({"authorize": api_token, "req_id": req_id}))
            resp = json.loads(await ws.recv())
            if resp.get("error"):
                raise RuntimeError(f"Deriv auth error: {resp['error']}")
            req_id += 1

        payload = {
            "ticks_history": deriv_sym,
            "granularity": gran_sec,
            "count": count,
            "end": "latest",
            "style": "candles",
            "req_id": req_id,
        }
        await ws.send(json.dumps(payload))

        while True:
            msg = json.loads(await ws.recv())
            if msg.get("req_id") == req_id:
                if msg.get("error"):
                    raise RuntimeError(f"Deriv candle error: {msg['error']}")
                candles = [
                    {
                        "epoch": int(c["epoch"]),
                        "open": float(c["open"]),
                        "high": float(c["high"]),
                        "low": float(c["low"]),
                        "close": float(c["close"]),
                        "volume": float(c.get("volume", 0.0)),
                    }
                    for c in msg.get("candles", [])
                ]
                break

    return candles


def fetch_candles(
    symbol: str,
    granularity: str,
    count: int,
    api_token: Optional[str] = None,
) -> list[dict]:
    """Synchronous wrapper around :func:`_fetch_candles_async`."""
    return asyncio.run(_fetch_candles_async(symbol, granularity, count, api_token))


# ── Feature Engineering (Python port of feature_builder.dart) ────────────────

def _safe_mean(values: list[float]) -> float:
    return sum(values) / len(values) if values else 0.0


def _clamp01(v: float) -> float:
    return max(0.0, min(1.0, v))


def _min_max_norm(value: float, window: list[float]) -> float:
    if not window:
        return 0.0
    lo, hi = min(window), max(window)
    span = hi - lo
    if span == 0.0:
        return 0.5
    return (value - lo) / span


def _atr_series(candles: list[dict], period: int = 14) -> list[float]:
    n = len(candles)
    trs = [0.0] * n
    for i, c in enumerate(candles):
        if i == 0:
            trs[i] = c["high"] - c["low"]
        else:
            prev_close = candles[i - 1]["close"]
            trs[i] = max(
                c["high"] - c["low"],
                abs(c["high"] - prev_close),
                abs(c["low"] - prev_close),
            )
    out = [0.0] * n
    for i in range(n):
        start = max(0, i - period + 1)
        out[i] = _safe_mean(trs[start : i + 1])
    return out


def _rsi(candles: list[dict], period: int = 14, index: int = -1) -> float:
    if index < 0:
        index = len(candles) - 1
    if len(candles) < 2 or index <= 0:
        return 50.0
    start = max(1, index - period + 1)
    gain = loss = 0.0
    for i in range(start, index + 1):
        delta = candles[i]["close"] - candles[i - 1]["close"]
        if delta >= 0:
            gain += delta
        else:
            loss += -delta
    avg_gain = gain / period
    avg_loss = loss / period
    if avg_loss == 0:
        return 100.0
    rs = avg_gain / avg_loss
    return 100.0 - 100.0 / (1.0 + rs)


def _vwap_deviation(candles: list[dict], index: int) -> float:
    cum_pv = cum_v = 0.0
    for c in candles[: index + 1]:
        typical = (c["high"] + c["low"] + c["close"]) / 3.0
        cum_pv += typical * c["volume"]
        cum_v += c["volume"]
    if cum_v == 0:
        return 0.0
    vwap = cum_pv / cum_v
    close = candles[index]["close"]
    return abs(close - vwap) / close if close != 0 else 0.0


def _detect_order_block(candles: list[dict]) -> Optional[dict]:
    """Simplified order block: last strong impulse candle before reversal."""
    if len(candles) < 3:
        return None
    for i in range(len(candles) - 1, 1, -1):
        c = candles[i]
        prev = candles[i - 1]
        body = abs(c["close"] - c["open"])
        rng = c["high"] - c["low"]
        if rng == 0:
            continue
        if body / rng < 0.5:
            continue
        is_bull = c["close"] > c["open"]
        midpoint = (c["high"] + c["low"]) / 2.0
        strength = body / rng
        if is_bull and prev["close"] < prev["open"]:
            return {
                "direction": "bullish",
                "high": c["high"],
                "low": c["low"],
                "midpoint": midpoint,
                "strength": strength,
                "is_valid": True,
            }
        if not is_bull and prev["close"] > prev["open"]:
            return {
                "direction": "bearish",
                "high": c["high"],
                "low": c["low"],
                "midpoint": midpoint,
                "strength": strength,
                "is_valid": True,
            }
    return None


def _detect_fvg(candles: list[dict]) -> Optional[dict]:
    """Detect the most recent Fair Value Gap."""
    for i in range(len(candles) - 1, 1, -1):
        c0 = candles[i - 2]
        c2 = candles[i]
        if c2["low"] > c0["high"]:
            return {
                "direction": "bullish",
                "upper": c2["low"],
                "lower": c0["high"],
                "is_filled": False,
            }
        if c2["high"] < c0["low"]:
            return {
                "direction": "bearish",
                "upper": c0["low"],
                "lower": c2["high"],
                "is_filled": False,
            }
    return None


def _detect_liquidity_sweep(candles: list[dict]) -> str:
    """Return 'bull', 'bear', or 'none'."""
    if len(candles) < 5:
        return "none"
    window = candles[-5:]
    swing_high = max(c["high"] for c in window[:-1])
    swing_low = min(c["low"] for c in window[:-1])
    last = window[-1]
    if last["high"] > swing_high and last["close"] < swing_high:
        return "bear"
    if last["low"] < swing_low and last["close"] > swing_low:
        return "bull"
    return "none"


def _detect_market_structure(candles: list[dict]) -> dict:
    """Detect BOS, MSS, displacement, and bias."""
    if len(candles) < 10:
        return {
            "mss": False,
            "bos": False,
            "displacement_bull": False,
            "displacement_bear": False,
            "bias": None,
        }
    atrs = _atr_series(candles, period=14)
    atr_mean = _safe_mean([v for v in atrs if v > 0]) or 1e-9

    window = candles[-10:]
    highs = [c["high"] for c in window[:-1]]
    lows = [c["low"] for c in window[:-1]]
    prev_hi = max(highs)
    prev_lo = min(lows)
    last = window[-1]
    last_atr = atrs[-1] if atrs[-1] > 0 else atr_mean

    bos = last["close"] > prev_hi or last["close"] < prev_lo
    body = abs(last["close"] - last["open"])
    displacement_bull = last["close"] > last["open"] and body > 1.5 * last_atr
    displacement_bear = last["close"] < last["open"] and body > 1.5 * last_atr

    mid_close = _safe_mean([c["close"] for c in window[:-1]])
    mss = bos and abs(last["close"] - mid_close) > 2.0 * atr_mean

    bias = "bullish" if last["close"] > prev_hi else ("bearish" if last["close"] < prev_lo else None)

    return {
        "mss": mss,
        "bos": bos,
        "displacement_bull": displacement_bull,
        "displacement_bear": displacement_bear,
        "bias": bias,
    }


def _detect_po3_phase(candles: list[dict]) -> int:
    """Power of Three phase: 0=accumulation, 1=manipulation, 2=distribution."""
    if len(candles) < 20:
        return 0
    window = candles[-20:]
    bodies = [abs(c["close"] - c["open"]) for c in window]
    ranges = [c["high"] - c["low"] for c in window]
    mean_body = _safe_mean(bodies) or 1e-9
    mean_range = _safe_mean(ranges) or 1e-9
    last = window[-1]
    last_body = abs(last["close"] - last["open"])
    last_range = last["high"] - last["low"]
    if last_body < 0.3 * mean_body:
        return 0  # accumulation (tight range)
    if last_range > 1.5 * mean_range and last_body < 0.5 * last_range:
        return 1  # manipulation (wick-heavy)
    return 2  # distribution (large directional)


def _compute_fibonacci(candles: list[dict]) -> dict:
    """Compute Fibonacci retracement levels from the last major swing."""
    if len(candles) < 20:
        swing_hi = max(c["high"] for c in candles)
        swing_lo = min(c["low"] for c in candles)
    else:
        window = candles[-20:]
        swing_hi = max(c["high"] for c in window)
        swing_lo = min(c["low"] for c in window)
    span = swing_hi - swing_lo
    levels = {
        "0.0": swing_hi,
        "0.236": swing_hi - 0.236 * span,
        "0.382": swing_hi - 0.382 * span,
        "0.5": swing_hi - 0.5 * span,
        "0.618": swing_hi - 0.618 * span,
        "0.786": swing_hi - 0.786 * span,
        "1.0": swing_lo,
    }
    return {"swing_high": swing_hi, "swing_low": swing_lo, "levels": levels}


def _get_session(epoch: int) -> int:
    """Map Unix epoch to session number matching session_detector.dart.

    Returns: 0=deadZone, 1=asian, 2=london, 3=newYork
    """
    hour = datetime.fromtimestamp(epoch, tz=timezone.utc).hour
    if hour >= 20 or hour < 1:
        return 1  # asian
    if 2 <= hour < 6:
        return 2  # london
    if 8 <= hour < 13:
        return 3  # newYork
    return 0  # deadZone


def _ote_confluence(fib: dict, ob: Optional[dict]) -> bool:
    """True when the last price sits in the 0.618–0.786 OTE zone."""
    if ob is None:
        return False
    lo618 = fib["levels"].get("0.618", 0.0)
    lo786 = fib["levels"].get("0.786", 0.0)
    zone_lo = min(lo618, lo786)
    zone_hi = max(lo618, lo786)
    mid = ob.get("midpoint", 0.0)
    return zone_lo <= mid <= zone_hi


def _mtf_aligned(ob_4h: Optional[dict], ms_1h: dict, fvg_5m: Optional[dict], ote: bool) -> bool:
    if ob_4h is None:
        return False
    directional = (
        ob_4h["direction"] == "bullish" and ms_1h.get("bias") == "bullish"
    ) or (
        ob_4h["direction"] == "bearish" and ms_1h.get("bias") == "bearish"
    )
    imbalance = fvg_5m is not None and not fvg_5m.get("is_filled", True)
    return directional and imbalance and ote


def _distance(x: Optional[float], y: Optional[float], atr: float) -> float:
    if x is None or y is None or atr == 0:
        return 0.0
    return abs(x - y) / atr


def build_feature_row(
    slice_5m: list[dict],
    idx: int,
    atrs: list[float],
    atr_mean: float,
    ob_5m: Optional[dict],
    fvg_5m: Optional[dict],
    liq_sweep: str,
    ms_5m: dict,
    fib: dict,
    po3_phase: int,
    ote_conf: bool,
    mtf_aligned: bool,
) -> list[float]:
    """Build one feature row (24 values) for candle at *idx*."""
    c = slice_5m[idx]
    opens = [x["open"] for x in slice_5m]
    highs = [x["high"] for x in slice_5m]
    lows = [x["low"] for x in slice_5m]
    closes = [x["close"] for x in slice_5m]
    volumes = [x["volume"] for x in slice_5m]

    atr = atrs[idx] if atrs[idx] > 0 else atr_mean
    close = c["close"]

    # PD zone: price position between swing high and low
    swing_hi = fib["swing_high"]
    swing_lo = fib["swing_low"]
    pd_zone = _clamp01((close - swing_lo) / (swing_hi - swing_lo)) if swing_hi != swing_lo else 0.5

    session = _get_session(c["epoch"])

    ob_bull_mid = ob_5m["midpoint"] if ob_5m and ob_5m["direction"] == "bullish" else None
    ob_bear_mid = ob_5m["midpoint"] if ob_5m and ob_5m["direction"] == "bearish" else None
    fvg_upper = fvg_5m["upper"] if fvg_5m else None
    fvg_lower = fvg_5m["lower"] if fvg_5m else None
    fib_618 = fib["levels"].get("0.618")

    return [
        _min_max_norm(c["open"], opens),          # 0  open (normalised)
        _min_max_norm(c["high"], highs),           # 1  high (normalised)
        _min_max_norm(c["low"], lows),             # 2  low  (normalised)
        _min_max_norm(c["close"], closes),         # 3  close (normalised)
        _min_max_norm(c["volume"], volumes),       # 4  volume (normalised)
        _rsi(slice_5m, period=14, index=idx) / 100.0,  # 5  RSI/100
        (atr / atr_mean) if atr_mean > 0 else 0.0,    # 6  ATR ratio
        _vwap_deviation(slice_5m, idx),           # 7  VWAP deviation
        _distance(close, ob_bull_mid, atr),       # 8  dist to bullish OB
        _distance(close, ob_bear_mid, atr),       # 9  dist to bearish OB
        _distance(close, fvg_upper, atr),         # 10 dist to FVG upper
        _distance(close, fvg_lower, atr),         # 11 dist to FVG lower
        1.0 if liq_sweep == "bull" else 0.0,      # 12 liquidity sweep bull
        1.0 if liq_sweep == "bear" else 0.0,      # 13 liquidity sweep bear
        1.0 if ms_5m["mss"] else 0.0,             # 14 MSS
        1.0 if ms_5m["bos"] else 0.0,             # 15 BOS
        1.0 if ms_5m["displacement_bull"] else 0.0,  # 16 displacement bull
        1.0 if ms_5m["displacement_bear"] else 0.0,  # 17 displacement bear
        _distance(close, fib_618, atr),           # 18 dist to 0.618 fib
        float(po3_phase),                         # 19 PO3 phase
        pd_zone,                                  # 20 PD zone
        1.0 if ote_conf else 0.0,                 # 21 OTE confluence
        float(session),                           # 22 session number
        1.0 if mtf_aligned else 0.0,              # 23 MTF aligned
    ]


def build_dataset(
    candles_5m: list[dict],
    candles_1h: list[dict],
    candles_4h: list[dict],
) -> tuple[np.ndarray, np.ndarray]:
    """Build (X, y) arrays from multi-timeframe candle data.

    X shape : (samples, LOOKBACK, NUM_FEATURES)
    y shape : (samples,)  labels: 0=long, 1=short
    """
    if len(candles_5m) < LOOKBACK + LABEL_HORIZON + 1:
        raise ValueError(
            f"Need at least {LOOKBACK + LABEL_HORIZON + 1} 5M candles, "
            f"got {len(candles_5m)}"
        )

    atrs_5m = _atr_series(candles_5m, period=14)
    atr_mean_5m = _safe_mean([v for v in atrs_5m if v > 0]) or 1e-9

    ob_4h = _detect_order_block(candles_4h)
    ms_1h = _detect_market_structure(candles_1h)
    fib_1h = _compute_fibonacci(candles_1h)

    xs: list[list[list[float]]] = []
    ys: list[int] = []

    total = len(candles_5m) - LOOKBACK - LABEL_HORIZON
    for start in tqdm(range(total), desc="Building features", unit="window"):
        end = start + LOOKBACK
        slice_5m = candles_5m[start:end]
        future = candles_5m[end : end + LABEL_HORIZON]

        # ICT features computed on the slice
        ob_5m = _detect_order_block(slice_5m)
        fvg_5m = _detect_fvg(slice_5m)
        liq = _detect_liquidity_sweep(slice_5m)
        ms_5m = _detect_market_structure(slice_5m)
        fib_5m = _compute_fibonacci(slice_5m)
        po3 = _detect_po3_phase(candles_4h)
        ote = _ote_confluence(fib_1h, ob_4h)
        mtf = _mtf_aligned(ob_4h, ms_1h, fvg_5m, ote)

        # Build all LOOKBACK rows
        slice_atrs = _atr_series(slice_5m, period=14)
        slice_atr_mean = _safe_mean([v for v in slice_atrs if v > 0]) or 1e-9

        matrix: list[list[float]] = []
        for i in range(LOOKBACK):
            row = build_feature_row(
                slice_5m, i, slice_atrs, slice_atr_mean,
                ob_5m, fvg_5m, liq, ms_5m, fib_5m, po3, ote, mtf,
            )
            matrix.append(row)

        # Generate label from forward candles
        current_close = slice_5m[-1]["close"]
        current_atr = slice_atrs[-1] if slice_atrs[-1] > 0 else slice_atr_mean
        threshold = LABEL_ATR_MULT * current_atr

        future_hi = max(c["high"] for c in future)
        future_lo = min(c["low"] for c in future)

        if future_hi - current_close >= threshold:
            label = 0  # long
        elif current_close - future_lo >= threshold:
            label = 1  # short
        else:
            continue  # neutral — skip

        xs.append(matrix)
        ys.append(label)

    return np.array(xs, dtype=np.float32), np.array(ys, dtype=np.int64)


# ── Model ─────────────────────────────────────────────────────────────────────

class QuantAIModel(nn.Module):
    """Bidirectional LSTM classifier for long/short signal detection."""

    def __init__(
        self,
        num_features: int = NUM_FEATURES,
        hidden_size: int = 64,
        num_layers: int = 2,
        dropout: float = 0.2,
    ) -> None:
        super().__init__()
        self.lstm = nn.LSTM(
            input_size=num_features,
            hidden_size=hidden_size,
            num_layers=num_layers,
            batch_first=True,
            dropout=dropout if num_layers > 1 else 0.0,
            bidirectional=False,
        )
        self.classifier = nn.Sequential(
            nn.Dropout(dropout),
            nn.Linear(hidden_size, 32),
            nn.ReLU(),
            nn.Linear(32, 2),
            nn.Softmax(dim=-1),
        )

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        # x: [batch, LOOKBACK, NUM_FEATURES]
        out, _ = self.lstm(x)
        last = out[:, -1, :]  # take last time-step output
        return self.classifier(last)  # [batch, 2]


# ── ONNX Export ───────────────────────────────────────────────────────────────

def export_onnx(model: nn.Module, output_path: Path) -> None:
    """Export *model* to ONNX with the input/output names expected by the app."""
    model.eval()
    dummy = torch.zeros(1, LOOKBACK, NUM_FEATURES)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    torch.onnx.export(
        model,
        dummy,
        str(output_path),
        input_names=["input"],
        output_names=["output"],
        dynamic_axes={"input": {0: "batch"}, "output": {0: "batch"}},
        opset_version=17,
    )
    # Validate the exported model
    onnx_model = onnx.load(str(output_path))
    onnx.checker.check_model(onnx_model)
    console.print(f"[green]✓ ONNX model saved → {output_path}[/]")


# ── Training Loop ─────────────────────────────────────────────────────────────

def train_model(
    symbols: list[str],
    api_token: Optional[str],
    candle_count: int,
    epochs: int,
    lr: float,
    output_path: Path,
) -> None:
    """Fetch data for every symbol, build dataset, train, and export ONNX."""
    all_x: list[np.ndarray] = []
    all_y: list[np.ndarray] = []

    for sym in symbols:
        console.print(f"[cyan]Fetching candles for {sym}…[/]")
        try:
            candles_5m = fetch_candles(sym, "5M", candle_count, api_token)
            candles_1h = fetch_candles(sym, "1H", max(200, candle_count // 12), api_token)
            candles_4h = fetch_candles(sym, "4H", max(100, candle_count // 48), api_token)
            console.print(
                f"  [dim]{len(candles_5m)} × 5M  |  "
                f"{len(candles_1h)} × 1H  |  "
                f"{len(candles_4h)} × 4H[/]"
            )
        except Exception as exc:  # noqa: BLE001
            console.print(f"[yellow]⚠ Skipping {sym}: {exc}[/]")
            continue

        try:
            x, y = build_dataset(candles_5m, candles_1h, candles_4h)
        except Exception as exc:  # noqa: BLE001
            console.print(f"[yellow]⚠ Dataset build failed for {sym}: {exc}[/]")
            continue

        console.print(f"  [dim]{len(y)} labelled samples (long={int((y==0).sum())}, short={int((y==1).sum())})[/]")
        all_x.append(x)
        all_y.append(y)

    if not all_x:
        console.print("[red]No training data collected — aborting.[/]")
        return

    X = np.concatenate(all_x, axis=0)
    y = np.concatenate(all_y, axis=0)
    console.print(f"\n[bold]Total samples: {len(y)} (long={int((y==0).sum())}, short={int((y==1).sum())})[/]")

    X_train, X_val, y_train, y_val = train_test_split(
        X, y, test_size=0.15, random_state=42, stratify=y
    )

    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    console.print(f"[dim]Training on {device}[/]")

    model = QuantAIModel().to(device)
    optimizer = optim.AdamW(model.parameters(), lr=lr, weight_decay=1e-4)
    scheduler = optim.lr_scheduler.CosineAnnealingLR(optimizer, T_max=epochs)

    # Weighted loss to handle class imbalance
    counts = np.bincount(y_train, minlength=2).astype(float)
    weights = torch.tensor(
        1.0 / (counts + 1e-9), dtype=torch.float32, device=device
    )
    criterion = nn.CrossEntropyLoss(weight=weights / weights.sum() * 2)

    X_tr = torch.tensor(X_train, dtype=torch.float32, device=device)
    y_tr = torch.tensor(y_train, dtype=torch.long, device=device)
    X_vl = torch.tensor(X_val, dtype=torch.float32, device=device)
    y_vl = torch.tensor(y_val, dtype=torch.long, device=device)

    batch_size = 256
    n_batches = math.ceil(len(X_tr) / batch_size)

    with Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        BarColumn(),
        TaskProgressColumn(),
        TimeElapsedColumn(),
        console=console,
    ) as progress:
        epoch_task = progress.add_task("Epochs", total=epochs)

        for epoch in range(1, epochs + 1):
            model.train()
            epoch_loss = 0.0
            perm = torch.randperm(len(X_tr))
            X_tr, y_tr = X_tr[perm], y_tr[perm]

            for b in range(n_batches):
                xb = X_tr[b * batch_size : (b + 1) * batch_size]
                yb = y_tr[b * batch_size : (b + 1) * batch_size]
                optimizer.zero_grad()
                logits = model(xb)
                loss = criterion(logits, yb)
                loss.backward()
                nn.utils.clip_grad_norm_(model.parameters(), 1.0)
                optimizer.step()
                epoch_loss += loss.item()

            scheduler.step()

            model.eval()
            with torch.no_grad():
                val_logits = model(X_vl)
                val_preds = val_logits.argmax(dim=-1)
                val_acc = (val_preds == y_vl).float().mean().item()

            avg_loss = epoch_loss / n_batches
            progress.update(
                epoch_task,
                advance=1,
                description=f"Epoch {epoch}/{epochs}  loss={avg_loss:.4f}  val_acc={val_acc:.3f}",
            )

    export_onnx(model.cpu(), output_path)


# ── CLI ───────────────────────────────────────────────────────────────────────

def _build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        description="Train the QuantAI ONNX model on Deriv historical data.",
    )
    p.add_argument(
        "--symbols",
        nargs="+",
        default=DEFAULT_SYMBOLS,
        metavar="SYM",
        help=f"Symbols to train on (default: {DEFAULT_SYMBOLS})",
    )
    p.add_argument(
        "--candle-count",
        type=int,
        default=DEFAULT_CANDLE_COUNT,
        metavar="N",
        help="5M candles to fetch per symbol (default: 5000)",
    )
    p.add_argument(
        "--epochs",
        type=int,
        default=50,
        metavar="N",
        help="Training epochs (default: 50)",
    )
    p.add_argument(
        "--lr",
        type=float,
        default=1e-3,
        metavar="LR",
        help="Initial learning rate (default: 0.001)",
    )
    p.add_argument(
        "--output",
        type=Path,
        default=Path(__file__).parent.parent / "quantai" / "assets" / "models" / "quantai.onnx",
        metavar="PATH",
        help="Destination path for the exported ONNX model",
    )
    p.add_argument(
        "--api-token",
        default=os.environ.get("DERIV_API_TOKEN"),
        metavar="TOKEN",
        help="Deriv API token (or set DERIV_API_TOKEN env var)",
    )
    return p


def main() -> None:
    logging.basicConfig(level=logging.WARNING)
    args = _build_parser().parse_args()
    console.rule("[bold cyan]QuantAI Model Training[/]")
    console.print(f"Symbols : {args.symbols}")
    console.print(f"Candles : {args.candle_count} per symbol")
    console.print(f"Epochs  : {args.epochs}")
    console.print(f"Output  : {args.output}")
    console.rule()
    train_model(
        symbols=args.symbols,
        api_token=args.api_token,
        candle_count=args.candle_count,
        epochs=args.epochs,
        lr=args.lr,
        output_path=args.output,
    )


if __name__ == "__main__":
    main()
