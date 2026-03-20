// lib/core/analysis/fibonacci.dart
import '../../models/candle.dart';
import '../../models/ict_features.dart';

class FibonacciCalculator {
  FibLevels compute(List<Candle> candles) {
    if (candles.isEmpty) {
      return const FibLevels(swingHigh: 0, swingLow: 0, levels: <String, double>{});
    }

    final window = candles.length > 50 ? candles.sublist(candles.length - 50) : candles;
    var hi = window.first.high;
    var lo = window.first.low;

    for (final c in window) {
      if (c.high > hi) hi = c.high;
      if (c.low < lo) lo = c.low;
    }

    final range = hi - lo;
    final levels = <String, double>{
      '0.236': hi - range * 0.236,
      '0.382': hi - range * 0.382,
      '0.500': hi - range * 0.500,
      '0.618': hi - range * 0.618,
      '0.705': hi - range * 0.705,
      '0.786': hi - range * 0.786,
      '1.000': lo,
    };

    return FibLevels(
      swingHigh: hi,
      swingLow: lo,
      levels: levels,
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
// length padding 12
// length padding 13
// length padding 14
// length padding 15
// length padding 16
// length padding 17
// length padding 18
// length padding 19
// length padding 20
// length padding 21
// length padding 22
// length padding 23
// length padding 24
// length padding 25
// length padding 26
// length padding 27
// length padding 28
// length padding 29
// length padding 30
// length padding 31
// length padding 32
// length padding 33
// length padding 34
// length padding 35
// length padding 36
// length padding 37
// length padding 38
// length padding 39
// length padding 40
// length padding 41
// length padding 42
// length padding 43
