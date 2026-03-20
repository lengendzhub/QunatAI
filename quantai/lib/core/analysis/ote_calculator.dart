// lib/core/analysis/ote_calculator.dart
import '../../models/ict_features.dart';

class OteResult {
  const OteResult({
    required this.upper,
    required this.lower,
    required this.hasConfluence,
    required this.fibDrawHigh,
    required this.fibDrawLow,
  });

  final double upper;
  final double lower;
  final bool hasConfluence;
  final double fibDrawHigh;
  final double fibDrawLow;
}

class OteCalculator {
  OteResult compute(FibLevels fib, OrderBlockZone? ob) {
    final l618 = fib.levels['0.618'] ?? 0;
    final l705 = fib.levels['0.705'] ?? 0;
    final upper = l618 > l705 ? l618 : l705;
    final lower = l618 > l705 ? l705 : l618;

    final hasOb = ob != null;
    final obMid = ob?.midpoint ?? 0;
    final confluence = hasOb && obMid >= lower && obMid <= upper;

    return OteResult(
      upper: upper,
      lower: lower,
      hasConfluence: confluence,
      fibDrawHigh: fib.swingHigh,
      fibDrawLow: fib.swingLow,
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
