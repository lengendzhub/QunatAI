// lib/core/analysis/fair_value_gap.dart
import '../../models/candle.dart';
import '../../models/ict_features.dart';

class FairValueGapDetector {
  FairValueGapZone? detect(List<Candle> candles) {
    if (candles.length < 3) return null;

    for (var i = candles.length - 1; i >= 2; i--) {
      final a = candles[i - 2];
      final c = candles[i];

      if (a.low > c.high) {
        final upper = a.low;
        final lower = c.high;
        final filled = _isFilled(candles.sublist(i + 1), lower, upper);
        return FairValueGapZone(
          direction: 'bearish',
          upper: upper,
          lower: lower,
          isFilled: filled,
        );
      }

      if (a.high < c.low) {
        final upper = c.low;
        final lower = a.high;
        final filled = _isFilled(candles.sublist(i + 1), lower, upper);
        return FairValueGapZone(
          direction: 'bullish',
          upper: upper,
          lower: lower,
          isFilled: filled,
        );
      }
    }

    return null;
  }

  bool _isFilled(List<Candle> future, double lower, double upper) {
    return future.any((c) => c.low <= upper && c.high >= lower);
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
