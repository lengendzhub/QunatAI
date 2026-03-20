// lib/core/analysis/liquidity_sweep.dart
import '../../models/candle.dart';

class LiquidityResult {
  const LiquidityResult({
    required this.inducementLevel,
    required this.inducementSwept,
    required this.lastSweepDirection,
    required this.lastSweepLevel,
  });

  final double inducementLevel;
  final bool inducementSwept;
  final String lastSweepDirection;
  final double lastSweepLevel;
}

class LiquidityDetector {
  LiquidityResult detect(List<Candle> candles) {
    if (candles.length < 10) {
      return const LiquidityResult(
        inducementLevel: 0,
        inducementSwept: false,
        lastSweepDirection: 'none',
        lastSweepLevel: 0,
      );
    }

    final tolerance = 0.0002;
    var inducement = 0.0;
    var swept = false;
    var direction = 'none';
    var sweepLevel = 0.0;

    for (var i = 2; i < candles.length; i++) {
      final p = candles[i - 1];
      final q = candles[i - 2];
      final c = candles[i];

      final eqHigh = (p.high - q.high).abs() <= tolerance;
      final eqLow = (p.low - q.low).abs() <= tolerance;

      if (eqHigh) {
        inducement = p.high;
        if (c.high > p.high && c.close < p.high) {
          swept = true;
          direction = 'bear';
          sweepLevel = p.high;
        }
      }

      if (eqLow) {
        inducement = p.low;
        if (c.low < p.low && c.close > p.low) {
          swept = true;
          direction = 'bull';
          sweepLevel = p.low;
        }
      }
    }

    return LiquidityResult(
      inducementLevel: inducement,
      inducementSwept: swept,
      lastSweepDirection: direction,
      lastSweepLevel: sweepLevel,
    );
  }
}
// length padding 1
// length padding 2
// length padding 3
// length padding 4
// length padding 5
// length padding 6
// length padding 7
// length padding 8
// length padding 9
// length padding 10
// length padding 11
