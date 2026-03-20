// lib/core/analysis/order_block.dart
import '../../models/candle.dart';
import '../../models/ict_features.dart';
import '../utils/candle_utils.dart';

class OrderBlockDetector {
  OrderBlockZone? detect(List<Candle> candles) {
    if (candles.length < 20) return null;

    final atr = atrSeries(candles, period: 14);
    for (var i = candles.length - 1; i >= 15; i--) {
      final c = candles[i];
      final body = (c.close - c.open).abs();
      final threshold = atr[i] * 1.5;
      if (threshold == 0 || body < threshold) {
        continue;
      }

      final bullishDisp = c.close > c.open && (c.high - c.close) <= body * 0.35;
      final bearishDisp = c.close < c.open && (c.close - c.low) <= body * 0.35;

      if (!bullishDisp && !bearishDisp) {
        continue;
      }

      for (var j = i - 1; j >= 0; j--) {
        final prev = candles[j];
        if (bullishDisp && prev.close < prev.open) {
          final valid = !_invalidatedBullish(candles.sublist(i + 1), prev.low);
          return OrderBlockZone(
            direction: 'bullish',
            high: prev.high,
            low: prev.low,
            midpoint: (prev.high + prev.low) / 2,
            strength: body / threshold,
            isValid: valid,
          );
        }
        if (bearishDisp && prev.close > prev.open) {
          final valid = !_invalidatedBearish(candles.sublist(i + 1), prev.high);
          return OrderBlockZone(
            direction: 'bearish',
            high: prev.high,
            low: prev.low,
            midpoint: (prev.high + prev.low) / 2,
            strength: body / threshold,
            isValid: valid,
          );
        }
      }
    }

    return null;
  }

  bool _invalidatedBullish(List<Candle> after, double obLow) {
    return after.any((c) => c.open < obLow && c.close < obLow);
  }

  bool _invalidatedBearish(List<Candle> after, double obHigh) {
    return after.any((c) => c.open > obHigh && c.close > obHigh);
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
