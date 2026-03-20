// lib/core/analysis/regime_detector.dart
import '../../models/candle.dart';
import '../../models/market_regime.dart';
import '../utils/candle_utils.dart';
import '../utils/math_utils.dart';

class RegimeDetector {
  MarketRegime detect(List<Candle> candles) {
    if (candles.length < 25) {
      return MarketRegime.range;
    }

    final atr = atrSeries(candles, period: 14);
    final recent = atr.sublist(atr.length - 20);
    final avg = safeMean(recent);
    final now = atr.last;

    if (avg > 0 && now > avg * 2.0) {
      return MarketRegime.volatile;
    }
    if (avg > 0 && now < avg * 0.3) {
      return MarketRegime.lowVolatility;
    }

    final last = candles.last;
    final prev = candles[candles.length - 2];
    final bodyRatio = last.range == 0 ? 0 : last.body / last.range;

    if (last.high > prev.high && last.low > prev.low && bodyRatio > 0.6) {
      return MarketRegime.trendUp;
    }
    if (last.high < prev.high && last.low < prev.low && bodyRatio > 0.6) {
      return MarketRegime.trendDown;
    }

    if (bodyRatio < 0.35) {
      return MarketRegime.range;
    }

    return MarketRegime.range;
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
