// lib/core/analysis/po3_detector.dart
import '../../models/candle.dart';
import '../utils/candle_utils.dart';

class Po3Result {
  const Po3Result({
    required this.phase,
    required this.confidence,
    required this.asianRangeHigh,
    required this.asianRangeLow,
    required this.manipulationLevel,
  });

  final int phase;
  final double confidence;
  final double asianRangeHigh;
  final double asianRangeLow;
  final double manipulationLevel;
}

class Po3Detector {
  Po3Result detect(List<Candle> c4h, List<Candle> c1h, List<Candle> c5m) {
    if (c5m.isEmpty) {
      return const Po3Result(
        phase: 0,
        confidence: 0,
        asianRangeHigh: 0,
        asianRangeLow: 0,
        manipulationLevel: 0,
      );
    }

    final asian = c5m.where((c) {
      final h = c.openTime.toUtc().hour;
      return h >= 20 || h < 1;
    }).toList();

    if (asian.isEmpty) {
      return const Po3Result(
        phase: 0,
        confidence: 0,
        asianRangeHigh: 0,
        asianRangeLow: 0,
        manipulationLevel: 0,
      );
    }

    final asianHigh = asian.map((e) => e.high).reduce((a, b) => a > b ? a : b);
    final asianLow = asian.map((e) => e.low).reduce((a, b) => a < b ? a : b);
    final asianRange = asianHigh - asianLow;

    final atr = atrSeries(c1h.isNotEmpty ? c1h : c5m, period: 14);
    final avgAtr = atr.isEmpty ? 0 : atr.last;

    final accumulation = avgAtr > 0 && asianRange < avgAtr * 0.4;
    final latest = c5m.last;

    final manipulationBull = latest.high > asianHigh && latest.close < asianHigh;
    final manipulationBear = latest.low < asianLow && latest.close > asianLow;

    final distribution = latest.body > (atrSeries(c5m).lastOrNull ?? 0) * 1.5;

    final phase = distribution
        ? 3
        : (manipulationBull || manipulationBear)
            ? 2
            : accumulation
                ? 1
                : 0;

    return Po3Result(
      phase: phase,
      confidence: phase == 0 ? 0.0 : 0.7,
      asianRangeHigh: asianHigh,
      asianRangeLow: asianLow,
      manipulationLevel: manipulationBull ? asianHigh : (manipulationBear ? asianLow : 0),
    );
  }
}

extension _LastOrNull<T> on List<T> {
  T? get lastOrNull => isEmpty ? null : last;
}
