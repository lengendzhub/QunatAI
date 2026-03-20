// lib/core/utils/candle_utils.dart
import '../../models/candle.dart';
import 'math_utils.dart';

List<double> atrSeries(List<Candle> candles, {int period = 14}) {
  if (candles.isEmpty) return <double>[];
  final out = List<double>.filled(candles.length, 0);
  final trs = List<double>.filled(candles.length, 0);

  for (var i = 0; i < candles.length; i++) {
    final c = candles[i];
    if (i == 0) {
      trs[i] = c.high - c.low;
      continue;
    }
    final prevClose = candles[i - 1].close;
    final tr1 = c.high - c.low;
    final tr2 = (c.high - prevClose).abs();
    final tr3 = (c.low - prevClose).abs();
    trs[i] = [tr1, tr2, tr3].reduce((a, b) => a > b ? a : b);
  }

  for (var i = 0; i < candles.length; i++) {
    final start = i - period + 1;
    if (start < 0) {
      out[i] = safeMean(trs.sublist(0, i + 1));
    } else {
      out[i] = safeMean(trs.sublist(start, i + 1));
    }
  }

  return out;
}

double rsi(List<Candle> candles, {required int period, required int index}) {
  if (candles.length < 2 || index <= 0) return 50;
  final start = (index - period + 1).clamp(1, index) as int;

  var gain = 0.0;
  var loss = 0.0;
  for (var i = start; i <= index; i++) {
    final delta = candles[i].close - candles[i - 1].close;
    if (delta >= 0) {
      gain += delta;
    } else {
      loss += -delta;
    }
  }

  final avgGain = gain / period;
  final avgLoss = loss / period;
  if (avgLoss == 0) return 100;
  final rs = avgGain / avgLoss;
  return 100 - (100 / (1 + rs));
}

double vwapDeviation(List<Candle> candles, {required int index}) {
  if (candles.isEmpty) return 0;
  var cumulativePV = 0.0;
  var cumulativeV = 0.0;

  for (var i = 0; i <= index; i++) {
    final c = candles[i];
    final typical = (c.high + c.low + c.close) / 3;
    cumulativePV += typical * c.volume;
    cumulativeV += c.volume;
  }

  if (cumulativeV == 0) return 0;
  final vwap = cumulativePV / cumulativeV;
  return (candles[index].close - vwap).abs() / candles[index].close;
}
// length padding 1
// length padding 2
// length padding 3
// length padding 4
// length padding 5
// length padding 6
// length padding 7
// length padding 8
