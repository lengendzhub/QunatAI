"""
scheduler.py — QunatAI weekly training scheduler.

Wraps train.py so that model retraining is triggered either immediately
(--run-now) or on a weekly cadence.  Multiple symbols can be trained in a
single run or via a persistent schedule.

Usage
-----
    # Run once immediately for EURUSD (7 days of history, 1 epoch)
    python scheduler.py --run-now --symbols EURUSD --days 7 --epochs 1 --batch-size 64

    # Run weekly for EURUSD + GBPUSD (defaults: 30 days, 30 epochs)
    python scheduler.py --symbols EURUSD GBPUSD

    # Run weekly, override schedule day/time
    python scheduler.py --symbols EURUSD --weekday saturday --hour 2

Options
-------
    --run-now               Trigger a training run immediately, then exit.
    --symbols SYMBOL ...    Symbols to train on           (default: EURUSD)
    --days    N             Calendar days of history      (default: 30)
    --epochs  N             Training epochs               (default: 30)
    --batch-size N          Mini-batch size               (default: 64)
    --lr      FLOAT         Learning rate                 (default: 1e-3)
    --hidden  N             LSTM hidden units             (default: 128)
    --layers  N             LSTM layers                   (default: 2)
    --dropout FLOAT         Dropout                       (default: 0.3)
    --granularity GRAN      Candle size 1M/5M/15M/1H/4H/1D (default: 5M)
    --lookback N            Sequence length               (default: 30)
    --horizon  N            Forward-candle label horizon  (default: 5)
    --threshold PCT         Min move % to label long/short (default: 0.03)
    --output  PATH          ONNX output path
                            (default: quantai/assets/models/quantai.onnx)
    --app-id  ID            Deriv app_id                  (default: 1089)
    --no-fetch              Skip live fetch; use cached CSVs
    --cache-dir PATH        Cache directory               (default: .cache)
    --seed    N             Random seed                   (default: 42)
    --weekday DAY           Day of week for scheduled run (default: sunday)
    --hour    H             UTC hour for scheduled run    (default: 1)
"""

from __future__ import annotations

import argparse
import logging
import signal
import sys
import time
from datetime import datetime, timezone
from typing import List, Optional

try:
    from rich.logging import RichHandler
    _rich_available = True
except ImportError:
    _rich_available = False

import train as _train

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------
logging.basicConfig(
    level=logging.INFO,
    format="%(message)s",
    handlers=[RichHandler(rich_tracebacks=True)] if _rich_available else [logging.StreamHandler()],
)
log = logging.getLogger("quantai.scheduler")

# ---------------------------------------------------------------------------
# Weekday mapping
# ---------------------------------------------------------------------------
WEEKDAY_MAP = {
    "monday": 0,
    "tuesday": 1,
    "wednesday": 2,
    "thursday": 3,
    "friday": 4,
    "saturday": 5,
    "sunday": 6,
}

# ---------------------------------------------------------------------------
# Graceful shutdown
# ---------------------------------------------------------------------------
_running = True


def _handle_signal(signum: int, frame: object) -> None:  # noqa: ANN001
    global _running
    log.info("Received signal %d — shutting down after current job completes.", signum)
    _running = False


signal.signal(signal.SIGINT, _handle_signal)
signal.signal(signal.SIGTERM, _handle_signal)


# ===========================================================================
# Core helpers
# ===========================================================================

def _build_train_args(args: argparse.Namespace) -> List[str]:
    """Convert scheduler args to a train.py argv list."""
    argv: List[str] = []
    argv += ["--symbols"] + args.symbols
    argv += ["--days", str(args.days)]
    argv += ["--epochs", str(args.epochs)]
    argv += ["--batch-size", str(args.batch_size)]
    argv += ["--lr", str(args.lr)]
    argv += ["--hidden", str(args.hidden)]
    argv += ["--layers", str(args.layers)]
    argv += ["--dropout", str(args.dropout)]
    argv += ["--granularity", args.granularity]
    argv += ["--lookback", str(args.lookback)]
    argv += ["--horizon", str(args.horizon)]
    argv += ["--threshold", str(args.threshold)]
    argv += ["--output", args.output]
    argv += ["--app-id", args.app_id]
    argv += ["--cache-dir", args.cache_dir]
    argv += ["--seed", str(args.seed)]
    if args.no_fetch:
        argv.append("--no-fetch")
    return argv


def run_training(args: argparse.Namespace) -> None:
    """Invoke train.main() with the current scheduler arguments."""
    log.info(
        "Starting training run — symbols=%s  days=%d  epochs=%d  batch=%d",
        args.symbols, args.days, args.epochs, args.batch_size,
    )
    start = time.monotonic()
    try:
        _train.main(_build_train_args(args))
        elapsed = time.monotonic() - start
        log.info("Training completed in %.1f s", elapsed)
    except Exception as exc:
        elapsed = time.monotonic() - start
        log.error("Training failed after %.1f s: %s", elapsed, exc, exc_info=True)


def _seconds_until_next_run(weekday: int, hour: int) -> float:
    """Return seconds until the next UTC occurrence of (weekday, hour:00)."""
    now = datetime.now(tz=timezone.utc)
    days_ahead = (weekday - now.weekday()) % 7
    # If today matches but the hour has passed, schedule for next week
    if days_ahead == 0 and now.hour >= hour:
        days_ahead = 7
    # Target: next matching weekday at the given UTC hour
    from datetime import timedelta
    target = now.replace(hour=hour, minute=0, second=0, microsecond=0) + timedelta(days=days_ahead)
    return max(0.0, (target - now).total_seconds())


# ===========================================================================
# CLI
# ===========================================================================

def parse_args(argv: Optional[List[str]] = None) -> argparse.Namespace:
    p = argparse.ArgumentParser(
        description="QunatAI weekly training scheduler.",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    # Scheduler-specific
    p.add_argument("--run-now", action="store_true",
                   help="Run training immediately then exit")
    p.add_argument("--weekday", default="sunday",
                   choices=list(WEEKDAY_MAP.keys()),
                   help="Day of week for scheduled weekly run (UTC)")
    p.add_argument("--hour", type=int, default=1, metavar="H",
                   help="UTC hour for scheduled weekly run")

    # Passed through to train.py
    p.add_argument("--symbols", nargs="+", default=["EURUSD"],
                   help="Symbols to train on")
    p.add_argument("--days", type=int, default=30,
                   help="Calendar days of history per symbol")
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
    p.add_argument("--granularity", default="5M",
                   choices=list(_train.GRANULARITY_MAP.keys()),
                   help="Candle granularity")
    p.add_argument("--lookback", type=int, default=_train.LOOKBACK,
                   help="Sequence lookback (must match ModelConfig.lookback=30)")
    p.add_argument("--horizon", type=int, default=5,
                   help="Forward candles for label generation")
    p.add_argument("--threshold", type=float, default=0.03,
                   help="Min move %% to label as long/short")
    p.add_argument("--output", default="quantai/assets/models/quantai.onnx",
                   help="Output ONNX path")
    p.add_argument("--app-id", default="1089",
                   help="Deriv app_id")
    p.add_argument("--no-fetch", action="store_true",
                   help="Use cached CSVs instead of live fetch")
    p.add_argument("--cache-dir", default=".cache",
                   help="Cache directory")
    p.add_argument("--seed", type=int, default=42,
                   help="Random seed")
    return p.parse_args(argv)


def main(argv: Optional[List[str]] = None) -> None:
    global _running
    args = parse_args(argv)

    if args.run_now:
        log.info("--run-now flag set — running immediately.")
        run_training(args)
        return

    # ------------------------------------------------------------------
    # Weekly scheduler loop
    # ------------------------------------------------------------------
    target_weekday = WEEKDAY_MAP[args.weekday]
    log.info(
        "Scheduler started — will train every %s at %02d:00 UTC  symbols=%s",
        args.weekday.capitalize(), args.hour, args.symbols,
    )

    while _running:
        wait = _seconds_until_next_run(target_weekday, args.hour)
        next_dt = datetime.fromtimestamp(
            time.time() + wait, tz=timezone.utc
        ).strftime("%Y-%m-%d %H:%M UTC")
        log.info("Next training run scheduled for %s (in %.1f h)", next_dt, wait / 3600)

        # Sleep in short intervals so we can react to SIGINT/SIGTERM quickly
        slept = 0.0
        while slept < wait and _running:
            chunk = min(60.0, wait - slept)
            time.sleep(chunk)
            slept += chunk

        if _running:
            run_training(args)

    log.info("Scheduler stopped.")


if __name__ == "__main__":
    main()
