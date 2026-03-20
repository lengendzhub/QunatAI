"""QuantAI weekly training scheduler.

Runs the model training job on a weekly cadence (Sunday 02:00 UTC by default)
and optionally immediately when --run-now is supplied.

Usage
-----
# Run once immediately then keep the weekly schedule alive:
    python scheduler.py --run-now --symbols EURUSD GBPUSD USDJPY XAUUSD BTCUSD

# Only start the weekly schedule (no immediate run):
    python scheduler.py

# Override the scheduled day/time:
    python scheduler.py --day sun --hour 3 --minute 0
"""

from __future__ import annotations

import argparse
import logging
import os
import signal
import sys
import time
from pathlib import Path
from typing import Optional

from apscheduler.schedulers.blocking import BlockingScheduler
from apscheduler.triggers.cron import CronTrigger
from rich.console import Console

# Ensure the train/ directory is importable from this script
sys.path.insert(0, str(Path(__file__).parent))
from train import DEFAULT_SYMBOLS, train_model  # noqa: E402

console = Console()
log = logging.getLogger(__name__)

_WEEK_DAYS = ("mon", "tue", "wed", "thu", "fri", "sat", "sun")


# ── Job ───────────────────────────────────────────────────────────────────────

def _run_training(
    symbols: list[str],
    api_token: Optional[str],
    candle_count: int,
    epochs: int,
    lr: float,
    output_path: Path,
) -> None:
    """Wrapper called by the scheduler (and --run-now)."""
    console.rule("[bold cyan]QuantAI scheduled training job[/]")
    train_model(
        symbols=symbols,
        api_token=api_token,
        candle_count=candle_count,
        epochs=epochs,
        lr=lr,
        output_path=output_path,
    )
    console.rule("[bold green]Training job complete[/]")


# ── CLI ───────────────────────────────────────────────────────────────────────

def _build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        description="QuantAI weekly model-retraining scheduler.",
    )
    p.add_argument(
        "--run-now",
        action="store_true",
        help="Execute a training run immediately before starting the schedule",
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
        default=5000,
        metavar="N",
        help="5M candles to fetch per symbol (default: 5000)",
    )
    p.add_argument(
        "--epochs",
        type=int,
        default=50,
        metavar="N",
        help="Training epochs per run (default: 50)",
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
    p.add_argument(
        "--day",
        default="sun",
        choices=_WEEK_DAYS,
        help="Day-of-week for the weekly run (default: sun)",
    )
    p.add_argument(
        "--hour",
        type=int,
        default=2,
        metavar="H",
        help="UTC hour for the weekly run (default: 2)",
    )
    p.add_argument(
        "--minute",
        type=int,
        default=0,
        metavar="M",
        help="UTC minute for the weekly run (default: 0)",
    )
    return p


def main() -> None:
    logging.basicConfig(level=logging.WARNING)
    args = _build_parser().parse_args()

    job_kwargs = dict(
        symbols=args.symbols,
        api_token=args.api_token,
        candle_count=args.candle_count,
        epochs=args.epochs,
        lr=args.lr,
        output_path=args.output,
    )

    console.rule("[bold cyan]QuantAI Scheduler[/]")
    console.print(f"Symbols  : {args.symbols}")
    console.print(f"Schedule : Every {args.day.capitalize()} at {args.hour:02d}:{args.minute:02d} UTC")
    console.print(f"Output   : {args.output}")
    console.rule()

    if args.run_now:
        console.print("[yellow]--run-now: starting immediate training run…[/]")
        _run_training(**job_kwargs)

    scheduler = BlockingScheduler(timezone="UTC")
    trigger = CronTrigger(
        day_of_week=args.day,
        hour=args.hour,
        minute=args.minute,
        timezone="UTC",
    )
    scheduler.add_job(
        _run_training,
        trigger=trigger,
        kwargs=job_kwargs,
        id="weekly_retrain",
        name="QuantAI weekly retrain",
        misfire_grace_time=3600,
        coalesce=True,
    )

    # Graceful shutdown on SIGINT / SIGTERM
    def _shutdown(signum: int, frame: object) -> None:  # noqa: ANN001
        console.print("\n[yellow]Shutting down scheduler…[/]")
        scheduler.shutdown(wait=False)
        sys.exit(0)

    signal.signal(signal.SIGINT, _shutdown)
    signal.signal(signal.SIGTERM, _shutdown)

    next_run = scheduler.get_jobs()[0].next_run_time if scheduler.get_jobs() else None
    console.print(f"[green]Scheduler started. Next run: {next_run}[/]")
    console.print("[dim]Press Ctrl+C to stop.[/]")
    scheduler.start()


if __name__ == "__main__":
    main()
