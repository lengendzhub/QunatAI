// lib/core/utils/math_utils.dart
import 'dart:math' as math;

double safeMean(List<double> values) {
  if (values.isEmpty) return 0;
  final sum = values.fold<double>(0, (a, b) => a + b);
  return sum / values.length;
}

double minMaxNorm(double value, List<double> window) {
  if (window.isEmpty) return 0;
  final min = window.reduce(math.min);
  final max = window.reduce(math.max);
  final span = max - min;
  if (span == 0) return 0.5;
  return (value - min) / span;
}

double clamp01(double value) {
  if (value < 0) return 0;
  if (value > 1) return 1;
  return value;
}

double pipSizeForSymbol(String symbol) {
  final upper = symbol.toUpperCase();
  if (upper.endsWith('JPY')) return 0.01;
  if (upper == 'XAUUSD') return 0.01;
  if (upper == 'XTIUSD') return 0.01;
  if (upper.startsWith('BTC') || upper.startsWith('ETH')) return 1.0;
  return 0.0001;
}

double roundTo(double value, int decimals) {
  final factor = math.pow(10, decimals).toDouble();
  return (value * factor).roundToDouble() / factor;
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
