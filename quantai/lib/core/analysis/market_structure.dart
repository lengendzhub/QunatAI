// lib/core/analysis/market_structure.dart
import '../../models/candle.dart';
import '../utils/candle_utils.dart';

class MarketStructureResult {
  const MarketStructureResult({
    required this.mssDetected,
    required this.bosDetected,
    required this.bias,
    required this.displacementBullish,
    required this.displacementBearish,
    required this.swingHighs,
    required this.swingLows,
  });

  final bool mssDetected;
  final bool bosDetected;
  final String bias;
  final bool displacementBullish;
  final bool displacementBearish;
  final List<double> swingHighs;
  final List<double> swingLows;
}

class MarketStructure {
  MarketStructureResult detect(List<Candle> candles) {
    if (candles.length < 25) {
      return const MarketStructureResult(
        mssDetected: false,
        bosDetected: false,
        bias: 'neutral',
        displacementBullish: false,
        displacementBearish: false,
        swingHighs: <double>[],
        swingLows: <double>[],
      );
    }

    final highs = <double>[];
    final lows = <double>[];
    for (var i = 2; i < candles.length - 2; i++) {
      final c = candles[i];
      if (c.high > candles[i - 1].high && c.high > candles[i - 2].high && c.high > candles[i + 1].high && c.high > candles[i + 2].high) {
        highs.add(c.high);
      }
      if (c.low < candles[i - 1].low && c.low < candles[i - 2].low && c.low < candles[i + 1].low && c.low < candles[i + 2].low) {
        lows.add(c.low);
      }
    }

    final atr = atrSeries(candles);
    final last = candles.last;
    final displacementBull = (last.close > last.open) && last.body > atr.last * 1.5;
    final displacementBear = (last.close < last.open) && last.body > atr.last * 1.5;

    var bias = 'neutral';
    if (highs.length >= 2 && lows.length >= 2) {
      if (highs.last > highs[highs.length - 2] && lows.last > lows[lows.length - 2]) {
        bias = 'bullish';
      } else if (highs.last < highs[highs.length - 2] && lows.last < lows[lows.length - 2]) {
        bias = 'bearish';
      }
    }

    final mss = bias == 'bearish' && highs.isNotEmpty && candles.last.close > highs.last ||
        bias == 'bullish' && lows.isNotEmpty && candles.last.close < lows.last;

    final bos = bias == 'bullish' && highs.isNotEmpty && candles.last.close > highs.last ||
        bias == 'bearish' && lows.isNotEmpty && candles.last.close < lows.last;

    return MarketStructureResult(
      mssDetected: mss,
      bosDetected: bos,
      bias: bias,
      displacementBullish: displacementBull,
      displacementBearish: displacementBear,
      swingHighs: highs,
      swingLows: lows,
    );
  }
}
