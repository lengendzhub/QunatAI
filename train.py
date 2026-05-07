"""
train.py — QunatAI full model training script.

Fetches historical OHLCV candles from the Deriv WebSocket API, engineers
the same 24 ICT features used by the Flutter app's FeatureBuilder, trains a
PyTorch LSTM binary classifier (long / short), and exports the result as an
ONNX model to quantai/assets/models/quantai.onnx.

Usage
-----
    python train.py [OPTIONS]

Options
-------
    --symbols   SYMBOL [SYMBOL ...]   Symbols to train on  (default: EURUSD)
    --days      N                     Calendar days of 1-minute history to
                                      fetch per symbol      (default: 30)
    --granularity GRAN                Candle size: 1M 5M 15M 1H 4H 1D
                                                              (default: 5M)
    --lookback  N                     Sequence length       (default: 30)
    --horizon   N                     Forward candles for label
                                                              (default: 5)
    --threshold PCT                   Min move % to label as long/short
                                                              (default: 0.03)
    --epochs    N                     Training epochs       (default: 30)
    --batch-size N                    Mini-batch size       (default: 64)
    --lr        FLOAT                 Learning rate         (default: 1e-3)
    --hidden    N                     LSTM hidden units     (default: 128)
    --layers    N                     LSTM layers           (default: 2)
    --dropout   FLOAT                 Dropout rate          (default: 0.3)
    --output    PATH                  Output ONNX path
                            (default: quantai/assets/models/quantai.onnx)
    --app-id    ID                    Deriv app_id          (default: 1089)
    --no-fetch                        Skip data fetch; use cached CSV files
    --cache-dir PATH                  Directory for cached CSVs
                                                              (default: .cache)
    --seed      N                     Random seed           (default: 42)
"""

from __future__ import annotations

import argparse
import asyncio
import json
import logging
import math
import os
import sys
import time
from pathlib import Path
from typing import Dict, List, Optional, Tuple

import numpy as np
import pandas as pd
import torch
import torch.nn as nn
from torch.utils.data import DataLoader, TensorDataset
from sklearn.preprocessing import RobustScaler

try:
    import websockets
    HAS_WEBSOCKETS = True
except ImportError:
    HAS_WEBSOCKETS = False

try:
    import onnx  # noqa: F401 – checked at export time
    import onnxruntime as ort  # noqa: F401 – used for post-export validation
    HAS_ONNX = True
except ImportError:
    HAS_ONNX = False

try:
    from rich.logging import RichHandler
    from rich.progress import Progress, SpinnerColumn, TimeElapsedColumn
    _rich_available = True
except ImportError:
    _rich_available = False

try:
    from tqdm import tqdm as _tqdm
    HAS_TQDM = True
except ImportError:
    HAS_TQDM = False

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------
logging.basicConfig(
    level=logging.INFO,
    format="%(message)s",
    handlers=[RichHandler(rich_tracebacks=True)] if _rich_available else [logging.StreamHandler()],
)
log = logging.getLogger("quantai.train")

# ---------------------------------------------------------------------------
# Constants mirroring the Flutter app
# ---------------------------------------------------------------------------
DERIV_WS_URL = "wss://ws.binaryws.com/websockets/v3?app_id={app_id}"
SYMBOL_MAP: Dict[str, str] = {
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
GRANULARITY_MAP: Dict[str, int] = {
    "1M": 60,
    "5M": 300,
    "15M": 900,
    "1H": 3600,
    "4H": 14400,
    "1D": 86400,
}
NUM_FEATURES = 24   # must match ModelConfig.numFeatures
LOOKBACK = 30       # must match ModelConfig.lookback


# ===========================================================================
# Data fetching
# ===========================================================================

async def _fetch_candles_ws(
    symbol: str,
    granularity: str,
    count: int,
    app_id: str,
) -> pd.DataFrame:
    """Fetch *count* candles for *symbol* from the Deriv WebSocket API."""
    deriv_sym = SYMBOL_MAP.get(symbol.upper())
    if deriv_sym is None:
        raise ValueError(f"Unsupported symbol: {symbol}")
    gran_secs = GRANULARITY_MAP.get(granularity.upper())
    if gran_secs is None:
        raise ValueError(f"Unsupported granularity: {granularity}")

    url = DERIV_WS_URL.format(app_id=app_id)
    log.info("Connecting to Deriv WS for %s %s (count=%d)…", symbol, granularity, count)

    # Deriv caps a single ticks_history response at 5000 candles; use 4000 as a
    # conservative batch size to stay well within the limit and avoid timeouts.
    MAX_BATCH = 4000
    batches: List[List[dict]] = []
    # We request from the latest backwards in time
    end_epoch: Optional[int] = None

    async with websockets.connect(url, ping_interval=20) as ws:
        req_id = 1
        remaining = count
        while remaining > 0:
            batch_count = min(remaining, MAX_BATCH)
            payload: dict = {
                "ticks_history": deriv_sym,
                "granularity": gran_secs,
                "count": batch_count,
                "style": "candles",
                "req_id": req_id,
            }
            if end_epoch is not None:
                payload["end"] = end_epoch
            else:
                payload["end"] = "latest"

            await ws.send(json.dumps(payload))
            resp = json.loads(await ws.recv())
            if resp.get("error"):
                raise RuntimeError(f"Deriv API error: {resp['error'].get('message', resp['error'])}")

            candles = resp.get("candles", [])
            if not candles:
                break
            batches.append(candles)
            remaining -= len(candles)
            # Shift end_epoch to just before the oldest candle received
            end_epoch = candles[0]["epoch"] - 1
            req_id += 1
            if len(candles) < batch_count:
                break  # no more history available

    if not batches:
        raise RuntimeError(f"No candle data returned for {symbol}")

    # Reverse batches so oldest first, deduplicate
    all_candles: List[dict] = []
    seen_epochs: set = set()
    for batch in reversed(batches):
        for c in batch:
            if c["epoch"] not in seen_epochs:
                seen_epochs.add(c["epoch"])
                all_candles.append(c)

    all_candles.sort(key=lambda c: c["epoch"])

    df = pd.DataFrame(all_candles)
    df.rename(columns={"epoch": "time"}, inplace=True)
    for col in ("open", "high", "low", "close"):
        df[col] = df[col].astype(float)
    df["volume"] = df.get("volume", pd.Series(0.0, index=df.index)).astype(float)
    df["time"] = pd.to_datetime(df["time"], unit="s", utc=True)
    df.sort_values("time", inplace=True)
    df.reset_index(drop=True, inplace=True)
    return df[["time", "open", "high", "low", "close", "volume"]]


def fetch_candles(
    symbol: str,
    granularity: str,
    days: int,
    app_id: str,
    cache_dir: Path,
    no_fetch: bool,
) -> pd.DataFrame:
    """Return candle DataFrame from cache or live Deriv API."""
    cache_path = cache_dir / f"{symbol}_{granularity}_{days}d.csv"
    if no_fetch and cache_path.exists():
        log.info("Loading cached data from %s", cache_path)
        df = pd.read_csv(cache_path, parse_dates=["time"])
        return df

    if not HAS_WEBSOCKETS:
        raise ImportError(
            "websockets package is required for live data fetching. "
            "Install it with: pip install websockets"
        )

    gran_secs = GRANULARITY_MAP.get(granularity.upper(), 300)
    candles_per_day = int(86400 / gran_secs)
    count = days * candles_per_day

    df = asyncio.run(_fetch_candles_ws(symbol, granularity, count, app_id))
    log.info("Fetched %d candles for %s", len(df), symbol)

    cache_dir.mkdir(parents=True, exist_ok=True)
    df.to_csv(cache_path, index=False)
    log.info("Cached to %s", cache_path)
    return df


# ===========================================================================
# Technical indicators
# ===========================================================================

def _atr_series(high: np.ndarray, low: np.ndarray, close: np.ndarray, period: int = 14) -> np.ndarray:
    n = len(high)
    tr = np.empty(n)
    tr[0] = high[0] - low[0]
    for i in range(1, n):
        tr[i] = max(high[i] - low[i], abs(high[i] - close[i - 1]), abs(low[i] - close[i - 1]))
    atr = np.empty(n)
    for i in range(n):
        start = max(0, i - period + 1)
        atr[i] = tr[start : i + 1].mean()
    return atr


def _rsi(close: np.ndarray, period: int = 14) -> np.ndarray:
    n = len(close)
    rsi = np.full(n, 50.0)
    for i in range(1, n):
        start = max(1, i - period + 1)
        delta = np.diff(close[start - 1 : i + 1])
        gain = delta[delta > 0].sum() / period
        loss = -delta[delta < 0].sum() / period
        if loss == 0:
            rsi[i] = 100.0
        else:
            rs = gain / loss
            rsi[i] = 100.0 - 100.0 / (1.0 + rs)
    return rsi


def _vwap_deviation(high: np.ndarray, low: np.ndarray, close: np.ndarray, volume: np.ndarray) -> np.ndarray:
    typical = (high + low + close) / 3.0
    cum_pv = np.cumsum(typical * volume)
    cum_v = np.cumsum(volume)
    with np.errstate(invalid="ignore", divide="ignore"):
        vwap = np.where(cum_v > 0, cum_pv / cum_v, close)
        dev = np.where(close > 0, np.abs(close - vwap) / close, 0.0)
    return dev


def _minmax_norm_window(value: float, window: np.ndarray) -> float:
    mn, mx = window.min(), window.max()
    span = mx - mn
    if span == 0:
        return 0.5
    return float((value - mn) / span)


# ---------------------------------------------------------------------------
# ICT-style indicators
# ---------------------------------------------------------------------------

def _detect_order_block(
    open_: np.ndarray,
    high: np.ndarray,
    low: np.ndarray,
    close: np.ndarray,
    idx: int,
    lookback: int = 10,
) -> Tuple[Optional[float], Optional[float]]:
    """
    Return (bullish_ob_mid, bearish_ob_mid) as of candle *idx*.

    A bullish OB is the last bearish candle before a strong bullish push.
    A bearish OB is the last bullish candle before a strong bearish push.
    Simplified: search the prior *lookback* candles.
    """
    start = max(0, idx - lookback)
    bull_mid: Optional[float] = None
    bear_mid: Optional[float] = None

    for j in range(start, idx):
        body = abs(close[j] - open_[j])
        rng = high[j] - low[j]
        if rng == 0:
            continue
        # Bearish candle with strong follow-through bullish
        if close[j] < open_[j]:
            if j + 1 <= idx and close[j + 1] > high[j]:
                bull_mid = (high[j] + low[j]) / 2.0
        # Bullish candle with strong follow-through bearish
        elif close[j] > open_[j]:
            if j + 1 <= idx and close[j + 1] < low[j]:
                bear_mid = (high[j] + low[j]) / 2.0

    return bull_mid, bear_mid


def _detect_fvg(
    high: np.ndarray,
    low: np.ndarray,
    idx: int,
) -> Tuple[Optional[float], Optional[float]]:
    """
    Return (fvg_upper, fvg_lower) of the most recent FVG as of candle *idx*.

    A bullish FVG: low[i+2] > high[i] — gap above candle i.
    A bearish FVG: high[i+2] < low[i] — gap below candle i.
    We only detect the most recent one up to idx-2.
    """
    fvg_upper: Optional[float] = None
    fvg_lower: Optional[float] = None
    for j in range(max(0, idx - 20), idx - 1):
        if low[j + 2] > high[j]:
            fvg_upper = low[j + 2]
            fvg_lower = high[j]
        elif high[j + 2] < low[j]:
            fvg_upper = low[j]
            fvg_lower = high[j + 2]
    return fvg_upper, fvg_lower


def _detect_liquidity_sweep(
    high: np.ndarray,
    low: np.ndarray,
    close: np.ndarray,
    idx: int,
    lookback: int = 20,
) -> Tuple[bool, bool]:
    """
    Return (bull_sweep, bear_sweep):
    - bull_sweep: price dipped below a prior swing low then closed back above it.
    - bear_sweep: price spiked above a prior swing high then closed back below it.
    """
    if idx < lookback + 1:
        return False, False
    window_high = high[idx - lookback : idx]
    window_low = low[idx - lookback : idx]
    prior_high = window_high.max()
    prior_low = window_low.min()
    bull_sweep = low[idx] < prior_low and close[idx] > prior_low
    bear_sweep = high[idx] > prior_high and close[idx] < prior_high
    return bool(bull_sweep), bool(bear_sweep)


def _detect_mss_bos(
    high: np.ndarray,
    low: np.ndarray,
    close: np.ndarray,
    idx: int,
    lookback: int = 10,
) -> Tuple[bool, bool]:
    """
    Detect Market Structure Shift (MSS) and Break of Structure (BOS).

    BOS: close breaks a significant prior swing high/low.
    MSS: close reverses through the last higher-low or lower-high.
    Simplified approach that captures the key signals.
    """
    if idx < lookback + 1:
        return False, False

    window_high = high[idx - lookback : idx]
    window_low = low[idx - lookback : idx]
    swing_high = window_high.max()
    swing_low = window_low.min()
    bos = bool(close[idx] > swing_high or close[idx] < swing_low)

    # MSS — close crosses the midpoint of the last lookback range
    mid = (swing_high + swing_low) / 2.0
    prev_mid = (high[idx - lookback : idx - 1].max() + low[idx - lookback : idx - 1].min()) / 2.0 if idx > 1 else mid
    mss = bool((close[idx - 1] < prev_mid) != (close[idx] < mid))
    return mss, bos


def _detect_displacement(
    open_: np.ndarray,
    close: np.ndarray,
    atr: np.ndarray,
    idx: int,
) -> Tuple[bool, bool]:
    """Detect impulsive displacement candles (body > 1.5× ATR)."""
    if idx == 0 or atr[idx] == 0:
        return False, False
    body = close[idx] - open_[idx]
    threshold = 1.5 * atr[idx]
    disp_bull = body > threshold
    disp_bear = body < -threshold
    return bool(disp_bull), bool(disp_bear)


def _fib_level_618(high: np.ndarray, low: np.ndarray, idx: int, lookback: int = 20) -> Optional[float]:
    """Return 0.618 Fibonacci retracement level from recent swing."""
    start = max(0, idx - lookback)
    swing_h = high[start:idx + 1].max()
    swing_l = low[start:idx + 1].min()
    return swing_l + 0.618 * (swing_h - swing_l)


def _po3_phase(
    open_: np.ndarray,
    high: np.ndarray,
    low: np.ndarray,
    close: np.ndarray,
    idx: int,
    session_len: int = 20,
) -> int:
    """
    Power of Three phase: 0=accumulation, 1=manipulation, 2=distribution, 3=unknown.
    Approximated from price position within the session range.
    """
    start = max(0, idx - session_len)
    sess_high = high[start:idx + 1].max()
    sess_low = low[start:idx + 1].min()
    rng = sess_high - sess_low
    if rng == 0:
        return 3
    pos = (close[idx] - sess_low) / rng
    if pos < 0.25:
        return 0  # accumulation (near lows)
    if pos < 0.5:
        return 1  # manipulation (below mid)
    if pos < 0.85:
        return 2  # distribution (near highs)
    return 1  # spike (possible manipulation)


def _pd_zone(close: np.ndarray, high: np.ndarray, low: np.ndarray, idx: int, lookback: int = 20) -> float:
    """
    Premium / Discount zone: 1.0 = extreme premium, -1.0 = extreme discount.
    Derived from position within the lookback range.
    """
    start = max(0, idx - lookback)
    swing_h = high[start:idx + 1].max()
    swing_l = low[start:idx + 1].min()
    rng = swing_h - swing_l
    if rng == 0:
        return 0.0
    equilibrium = swing_l + 0.5 * rng
    return float((close[idx] - equilibrium) / (0.5 * rng))


def _ote_confluence(
    close: np.ndarray,
    high: np.ndarray,
    low: np.ndarray,
    atr: np.ndarray,
    idx: int,
    lookback: int = 20,
) -> bool:
    """True if price is within the Optimal Trade Entry zone (0.618–0.786 fib)."""
    start = max(0, idx - lookback)
    swing_h = high[start:idx + 1].max()
    swing_l = low[start:idx + 1].min()
    ote_low = swing_l + 0.618 * (swing_h - swing_l)
    ote_high = swing_l + 0.786 * (swing_h - swing_l)
    return bool(ote_low <= close[idx] <= ote_high)


def _trading_session(dt: pd.Timestamp) -> int:
    """
    0=deadZone, 1=asian, 2=london, 3=newYork (UTC hours).
    Mirrors TradingSession enum in market_regime.dart.
    """
    h = dt.hour
    if 0 <= h < 3:
        return 0  # dead zone
    if 3 <= h < 9:
        return 1  # asian
    if 9 <= h < 17:
        return 2  # london / Frankfurt overlap
    if 17 <= h < 22:
        return 3  # new york
    return 0  # dead zone (22-24)


def _mtf_aligned(close: np.ndarray, idx: int, period: int = 20) -> bool:
    """
    Simple multi-timeframe alignment proxy: the short-term EMA is on the
    same side of the long-term SMA as the current candle direction.
    """
    if idx < period:
        return False
    sma = close[idx - period : idx + 1].mean()
    ema_short = close[idx - period // 4 : idx + 1].mean()  # crude EMA proxy
    candle_bull = close[idx] > close[idx - 1]
    return bool((ema_short > sma) == candle_bull)


# ---------------------------------------------------------------------------
# Full feature matrix builder
# ---------------------------------------------------------------------------

def build_feature_matrix(df: pd.DataFrame) -> np.ndarray:
    """
    Build (N, NUM_FEATURES) feature matrix from an OHLCV DataFrame.
    Mirrors FeatureBuilder.build() in feature_builder.dart.
    """
    open_ = df["open"].to_numpy(dtype=np.float64)
    high = df["high"].to_numpy(dtype=np.float64)
    low = df["low"].to_numpy(dtype=np.float64)
    close = df["close"].to_numpy(dtype=np.float64)
    volume = df["volume"].to_numpy(dtype=np.float64)
    times = df["time"] if "time" in df.columns else pd.Series([pd.Timestamp("2000-01-01 00:00", tz="UTC")] * len(df))

    n = len(df)
    rsi_arr = _rsi(close, period=14)
    atr_arr = _atr_series(high, low, close, period=14)
    atr_mean = float(atr_arr[atr_arr > 0].mean()) if (atr_arr > 0).any() else 1.0
    vwap_dev = _vwap_deviation(high, low, close, volume)

    matrix = np.zeros((n, NUM_FEATURES), dtype=np.float32)

    for i in range(n):
        win = slice(max(0, i - LOOKBACK + 1), i + 1)

        # 0–4: OHLCV min-max normalised
        matrix[i, 0] = _minmax_norm_window(open_[i], open_[win])
        matrix[i, 1] = _minmax_norm_window(high[i], high[win])
        matrix[i, 2] = _minmax_norm_window(low[i], low[win])
        matrix[i, 3] = _minmax_norm_window(close[i], close[win])
        matrix[i, 4] = _minmax_norm_window(volume[i], volume[win]) if volume[win].max() > 0 else 0.5

        # 5: RSI / 100
        matrix[i, 5] = float(rsi_arr[i]) / 100.0

        # 6: ATR / ATR mean
        atr_i = float(atr_arr[i]) if atr_arr[i] > 0 else atr_mean
        matrix[i, 6] = atr_i / atr_mean if atr_mean > 0 else 0.0

        # 7: VWAP deviation
        matrix[i, 7] = float(vwap_dev[i])

        # 8–9: Order block distances
        bull_ob, bear_ob = _detect_order_block(open_, high, low, close, i)
        atr_denom = atr_i if atr_i > 0 else 1.0
        matrix[i, 8] = abs(close[i] - bull_ob) / atr_denom if bull_ob is not None else 0.0
        matrix[i, 9] = abs(close[i] - bear_ob) / atr_denom if bear_ob is not None else 0.0

        # 10–11: FVG distances
        fvg_upper, fvg_lower = _detect_fvg(high, low, i)
        matrix[i, 10] = abs(close[i] - fvg_upper) / atr_denom if fvg_upper is not None else 0.0
        matrix[i, 11] = abs(close[i] - fvg_lower) / atr_denom if fvg_lower is not None else 0.0

        # 12–13: Liquidity sweep
        bull_ls, bear_ls = _detect_liquidity_sweep(high, low, close, i)
        matrix[i, 12] = 1.0 if bull_ls else 0.0
        matrix[i, 13] = 1.0 if bear_ls else 0.0

        # 14–15: MSS / BOS
        mss, bos = _detect_mss_bos(high, low, close, i)
        matrix[i, 14] = 1.0 if mss else 0.0
        matrix[i, 15] = 1.0 if bos else 0.0

        # 16–17: Displacement
        disp_bull, disp_bear = _detect_displacement(open_, close, atr_arr, i)
        matrix[i, 16] = 1.0 if disp_bull else 0.0
        matrix[i, 17] = 1.0 if disp_bear else 0.0

        # 18: Fib 0.618 distance
        fib618 = _fib_level_618(high, low, i)
        matrix[i, 18] = abs(close[i] - fib618) / atr_denom if fib618 is not None else 0.0

        # 19: PO3 phase (0-3)
        matrix[i, 19] = float(_po3_phase(open_, high, low, close, i))

        # 20: PD zone (-1 to 1)
        matrix[i, 20] = float(_pd_zone(close, high, low, i))

        # 21: OTE confluence
        matrix[i, 21] = 1.0 if _ote_confluence(close, high, low, atr_arr, i) else 0.0

        # 22: Trading session (0-3)
        ts = times.iloc[i] if hasattr(times, "iloc") else times[i]
        matrix[i, 22] = float(_trading_session(ts))

        # 23: MTF alignment
        matrix[i, 23] = 1.0 if _mtf_aligned(close, i) else 0.0

    return matrix


# ===========================================================================
# Label generation
# ===========================================================================

def make_labels(close: np.ndarray, horizon: int, threshold: float) -> np.ndarray:
    """
    0 = long, 1 = short, -1 = neutral / skip.
    A sample at index i is labelled long  if close[i+horizon] > close[i]*(1+threshold/100),
                           labelled short if close[i+horizon] < close[i]*(1-threshold/100),
                           otherwise neutral.
    """
    n = len(close)
    labels = np.full(n, -1, dtype=np.int64)
    for i in range(n - horizon):
        fwd = close[i + horizon]
        cur = close[i]
        if cur == 0:
            continue
        ret = (fwd - cur) / cur * 100.0
        if ret > threshold:
            labels[i] = 0   # long
        elif ret < -threshold:
            labels[i] = 1   # short
    return labels


# ===========================================================================
# Dataset construction
# ===========================================================================

def build_sequences(
    features: np.ndarray,
    labels: np.ndarray,
    lookback: int,
) -> Tuple[np.ndarray, np.ndarray]:
    """
    Slide a window of length *lookback* over *features* and pair each window
    with the corresponding label.  Only labelled (non-neutral) samples are kept.
    """
    X, y = [], []
    n = len(features)
    for i in range(lookback - 1, n):
        lbl = labels[i]
        if lbl == -1:
            continue
        X.append(features[i - lookback + 1 : i + 1])
        y.append(lbl)
    if not X:
        raise ValueError("No labelled sequences found – try reducing --threshold.")
    return np.array(X, dtype=np.float32), np.array(y, dtype=np.int64)


# ===========================================================================
# Model
# ===========================================================================

class QuantAIModel(nn.Module):
    """
    LSTM-based binary classifier.
    Input:  (batch, lookback, num_features)
    Output: (batch, 2)  — softmax probabilities [longProb, shortProb]
    """

    def __init__(
        self,
        num_features: int = NUM_FEATURES,
        hidden: int = 128,
        num_layers: int = 2,
        dropout: float = 0.3,
    ) -> None:
        super().__init__()
        self.lstm = nn.LSTM(
            input_size=num_features,
            hidden_size=hidden,
            num_layers=num_layers,
            batch_first=True,
            dropout=dropout if num_layers > 1 else 0.0,
        )
        self.norm = nn.LayerNorm(hidden)
        self.head = nn.Sequential(
            nn.Linear(hidden, hidden // 2),
            nn.ReLU(),
            nn.Dropout(dropout),
            nn.Linear(hidden // 2, 2),
        )

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        out, _ = self.lstm(x)
        last = out[:, -1, :]          # take last time step
        last = self.norm(last)
        logits = self.head(last)
        return torch.softmax(logits, dim=-1)


# ===========================================================================
# Training
# ===========================================================================

def train_model(
    X: np.ndarray,
    y: np.ndarray,
    args: argparse.Namespace,
    device: torch.device,
) -> QuantAIModel:
    """Train and return the model."""
    rng = np.random.default_rng(args.seed)
    idx = rng.permutation(len(X))
    split = int(len(X) * 0.85)
    train_idx, val_idx = idx[:split], idx[split:]

    X_tr, y_tr = X[train_idx], y[train_idx]
    X_val, y_val = X[val_idx], y[val_idx]

    # Scale each feature independently using the training set
    B, T, F = X_tr.shape
    scaler = RobustScaler()
    X_tr_2d = X_tr.reshape(-1, F)
    scaler.fit(X_tr_2d)
    X_tr = scaler.transform(X_tr_2d).reshape(B, T, F).astype(np.float32)
    X_val = scaler.transform(X_val.reshape(-1, F)).reshape(len(X_val), T, F).astype(np.float32)

    X_tr_t = torch.from_numpy(X_tr).to(device)
    y_tr_t = torch.from_numpy(y_tr).to(device)
    X_val_t = torch.from_numpy(X_val).to(device)
    y_val_t = torch.from_numpy(y_val).to(device)

    train_ds = TensorDataset(X_tr_t, y_tr_t)
    train_dl = DataLoader(train_ds, batch_size=args.batch_size, shuffle=True)

    model = QuantAIModel(
        num_features=NUM_FEATURES,
        hidden=args.hidden,
        num_layers=args.layers,
        dropout=args.dropout,
    ).to(device)

    # Class weights to handle imbalance
    counts = np.bincount(y_tr, minlength=2).astype(np.float32)
    weights = torch.tensor(1.0 / (counts + 1e-8)).to(device)
    criterion = nn.CrossEntropyLoss(weight=weights)
    optimizer = torch.optim.Adam(model.parameters(), lr=args.lr)
    scheduler = torch.optim.lr_scheduler.OneCycleLR(
        optimizer,
        max_lr=args.lr * 10,
        epochs=args.epochs,
        steps_per_epoch=max(1, len(train_dl)),
    )

    best_val_acc = 0.0
    best_state: Optional[dict] = None

    log.info("Training on %d samples, validating on %d", len(X_tr), len(X_val))
    for epoch in range(1, args.epochs + 1):
        model.train()
        total_loss = 0.0
        for xb, yb in train_dl:
            optimizer.zero_grad()
            preds = model(xb)
            loss = criterion(preds, yb)
            loss.backward()
            nn.utils.clip_grad_norm_(model.parameters(), 1.0)
            optimizer.step()
            scheduler.step()
            total_loss += float(loss.detach()) * len(xb)

        avg_loss = total_loss / len(X_tr)

        model.eval()
        with torch.no_grad():
            val_preds = model(X_val_t)
            val_pred_labels = val_preds.argmax(dim=1)
            val_acc = float((val_pred_labels == y_val_t).float().mean())
            val_loss = float(criterion(val_preds, y_val_t))

        if val_acc > best_val_acc:
            best_val_acc = val_acc
            best_state = {k: v.cpu().clone() for k, v in model.state_dict().items()}

        log.info(
            "Epoch %3d/%d  loss=%.4f  val_loss=%.4f  val_acc=%.3f  (best=%.3f)",
            epoch, args.epochs, avg_loss, val_loss, val_acc, best_val_acc,
        )

    if best_state is not None:
        model.load_state_dict(best_state)
        log.info("Restored best checkpoint (val_acc=%.3f)", best_val_acc)

    return model


# ===========================================================================
# ONNX export
# ===========================================================================

def export_onnx(model: QuantAIModel, output_path: Path, lookback: int = LOOKBACK) -> None:
    """Export *model* to ONNX at *output_path*."""
    if not HAS_ONNX:
        raise ImportError(
            "onnx and onnxruntime are required for export. "
            "Install with: pip install onnx onnxruntime"
        )

    model.eval()
    dummy = torch.zeros(1, lookback, NUM_FEATURES)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    torch.onnx.export(
        model,
        dummy,
        str(output_path),
        input_names=["input"],
        output_names=["output"],
        dynamic_axes={"input": {0: "batch_size"}, "output": {0: "batch_size"}},
        opset_version=17,
        dynamo=False,
    )
    log.info("ONNX model saved to %s", output_path)

    # Validate with onnxruntime
    sess = ort.InferenceSession(str(output_path))
    out = sess.run(None, {"input": dummy.numpy()})
    probs = out[0][0]
    log.info("ONNX validation OK — long=%.3f  short=%.3f", probs[0], probs[1])


# ===========================================================================
# Main
# ===========================================================================

def parse_args(argv: Optional[List[str]] = None) -> argparse.Namespace:
    p = argparse.ArgumentParser(
        description="Train and export the QunatAI ONNX model.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    p.add_argument("--symbols", nargs="+", default=["EURUSD"],
                   help="Symbols to train on")
    p.add_argument("--days", type=int, default=30,
                   help="Calendar days of history per symbol")
    p.add_argument("--granularity", default="5M",
                   choices=list(GRANULARITY_MAP.keys()),
                   help="Candle granularity")
    p.add_argument("--lookback", type=int, default=LOOKBACK,
                   help="Sequence length (must match ModelConfig.lookback=30)")
    p.add_argument("--horizon", type=int, default=5,
                   help="Forward candles for label generation")
    p.add_argument("--threshold", type=float, default=0.03,
                   help="Min move %% to label as long/short")
    p.add_argument("--epochs", type=int, default=30,
                   help="Training epochs")
    p.add_argument("--batch-size", type=int, default=64,
                   help="Mini-batch size")
    p.add_argument("--lr", type=float, default=1e-3,
                   help="Learning rate")
    p.add_argument("--hidden", type=int, default=128,
                   help="LSTM hidden units")
    p.add_argument("--layers", type=int, default=2,
                   help="LSTM layers")
    p.add_argument("--dropout", type=float, default=0.3,
                   help="Dropout rate")
    p.add_argument("--output", default="quantai/assets/models/quantai.onnx",
                   help="Output ONNX path")
    p.add_argument("--app-id", default="1089",
                   help="Deriv app_id for WebSocket API")
    p.add_argument("--no-fetch", action="store_true",
                   help="Use cached CSV files instead of live API")
    p.add_argument("--cache-dir", default=".cache",
                   help="Directory for cached CSVs")
    p.add_argument("--seed", type=int, default=42,
                   help="Random seed")
    return p.parse_args(argv)


def main(argv: Optional[List[str]] = None) -> None:
    args = parse_args(argv)

    torch.manual_seed(args.seed)
    np.random.seed(args.seed)

    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    log.info("Using device: %s", device)

    cache_dir = Path(args.cache_dir)

    # ------------------------------------------------------------------
    # Gather data for all symbols
    # ------------------------------------------------------------------
    all_X: List[np.ndarray] = []
    all_y: List[np.ndarray] = []

    for symbol in args.symbols:
        log.info("=== Processing %s ===", symbol)
        df = fetch_candles(
            symbol=symbol,
            granularity=args.granularity,
            days=args.days,
            app_id=args.app_id,
            cache_dir=cache_dir,
            no_fetch=args.no_fetch,
        )
        if len(df) < args.lookback + args.horizon + 10:
            log.warning(
                "%s: only %d candles — not enough data, skipping.", symbol, len(df)
            )
            continue

        log.info("%s: building features for %d candles…", symbol, len(df))
        features = build_feature_matrix(df)

        labels = make_labels(
            df["close"].to_numpy(dtype=np.float64),
            horizon=args.horizon,
            threshold=args.threshold,
        )

        X, y = build_sequences(features, labels, lookback=args.lookback)
        log.info(
            "%s: %d sequences (long=%d, short=%d)",
            symbol, len(X), int((y == 0).sum()), int((y == 1).sum()),
        )
        all_X.append(X)
        all_y.append(y)

    if not all_X:
        log.error("No data collected — aborting.")
        sys.exit(1)

    X_all = np.concatenate(all_X, axis=0)
    y_all = np.concatenate(all_y, axis=0)
    log.info("Combined dataset: %d sequences", len(X_all))

    # ------------------------------------------------------------------
    # Train
    # ------------------------------------------------------------------
    model = train_model(X_all, y_all, args, device)

    # ------------------------------------------------------------------
    # Export
    # ------------------------------------------------------------------
    output_path = Path(args.output)
    export_onnx(model, output_path, lookback=args.lookback)
    log.info("Done ✓")


if __name__ == "__main__":
    main()
