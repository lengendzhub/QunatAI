// lib/core/ai/feature_builder.dart
import '../../models/candle.dart';
import '../../models/ict_features.dart';
import '../../models/market_regime.dart';
import '../utils/candle_utils.dart';
import '../utils/math_utils.dart';
import 'model_config.dart';

class FeatureBuilder {
  List<List<double>> build(List<Candle> candles, IctFeatures features) {
    if (candles.length < ModelConfig.lookback) {
      throw ArgumentError('Need at least ${ModelConfig.lookback} candles');
    }

    final slice = candles.sublist(candles.length - ModelConfig.lookback);
    final highs = slice.map((c) => c.high).toList(growable: false);
    final lows = slice.map((c) => c.low).toList(growable: false);
    final opens = slice.map((c) => c.open).toList(growable: false);
    final closes = slice.map((c) => c.close).toList(growable: false);
    final volumes = slice.map((c) => c.volume).toList(growable: false);

    final atrs = atrSeries(slice, period: 14);
    final atrMean = safeMean(atrs.where((v) => v > 0).toList());

    final matrix = <List<double>>[];
    for (var i = 0; i < slice.length; i++) {
      final candle = slice[i];
      final atr = atrs[i] == 0 ? atrMean : atrs[i];
      final close = candle.close;

      final row = <double>[
        minMaxNorm(candle.open, opens),
        minMaxNorm(candle.high, highs),
        minMaxNorm(candle.low, lows),
        minMaxNorm(candle.close, closes),
        minMaxNorm(candle.volume, volumes),
        rsi(slice, period: 14, index: i) / 100,
        atrMean == 0 ? 0 : atr / atrMean,
        vwapDeviation(slice, index: i),
        _distance(features.ob?.direction == 'bullish' ? close : null, features.ob?.midpoint, atr),
        _distance(features.ob?.direction == 'bearish' ? close : null, features.ob?.midpoint, atr),
        _distance(close, features.fvg?.upper, atr),
        _distance(close, features.fvg?.lower, atr),
        features.liquiditySweep == 'bull' ? 1 : 0,
        features.liquiditySweep == 'bear' ? 1 : 0,
        features.mss ? 1 : 0,
        features.bos ? 1 : 0,
        features.displacementBull ? 1 : 0,
        features.displacementBear ? 1 : 0,
        _distance(close, features.fibLevels.levels['0.618'], atr),
        features.po3Phase.toDouble(),
        features.pdZone,
        features.oteConfluence ? 1 : 0,
        _sessionAsNumber(features.session),
        features.mtfAligned ? 1 : 0,
      ];
      matrix.add(row);
    }

    return matrix;
  }

  double _distance(double? x, double? y, double atr) {
    if (x == null || y == null || atr == 0) {
      return 0;
    }
    return (x - y).abs() / atr;
  }

  double _sessionAsNumber(TradingSession session) {
    switch (session) {
      case TradingSession.deadZone:
        return 0;
      case TradingSession.asian:
        return 1;
      case TradingSession.london:
        return 2;
      case TradingSession.newYork:
        return 3;
    }
  }
}
