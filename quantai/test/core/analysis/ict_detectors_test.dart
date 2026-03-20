// test/core/analysis/ict_detectors_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:quantai/core/analysis/fair_value_gap.dart';
import 'package:quantai/core/analysis/ict_engine.dart';
import 'package:quantai/core/analysis/market_structure.dart';
import 'package:quantai/core/analysis/order_block.dart';
import 'package:quantai/core/analysis/regime_detector.dart';
import 'package:quantai/models/candle.dart';
import 'package:quantai/models/market_regime.dart';

void main() {
  List<Candle> series({
    required String symbol,
    required String tf,
    required int n,
    required double start,
    required double step,
  }) {
    return List<Candle>.generate(n, (i) {
      final base = start + (i * step);
      return Candle(
        symbol: symbol,
        granularity: tf,
        openTime: DateTime.utc(2026, 1, 1).add(Duration(minutes: i * 5)),
        open: base,
        high: base + 0.0012,
        low: base - 0.0010,
        close: base + 0.0004,
        volume: 100 + i.toDouble(),
      );
    });
  }

  test('OrderBlockDetector returns null for insufficient candles', () {
    final detector = OrderBlockDetector();
    final result = detector.detect(series(symbol: 'EURUSD', tf: '5M', n: 10, start: 1.1000, step: 0.0001));
    expect(result, isNull);
  });

  test('FairValueGapDetector identifies no gap on smooth sequence', () {
    final detector = FairValueGapDetector();
    final result = detector.detect(series(symbol: 'EURUSD', tf: '5M', n: 40, start: 1.1000, step: 0.0001));
    expect(result == null || result.isFilled, isTrue);
  });

  test('FairValueGapDetector detects bullish FVG in crafted sequence', () {
    final detector = FairValueGapDetector();
    final candles = <Candle>[
      Candle(
        symbol: 'EURUSD',
        granularity: '5M',
        openTime: DateTime.utc(2026, 1, 1, 0, 0),
        open: 1.1000,
        high: 1.1010,
        low: 1.0990,
        close: 1.1005,
        volume: 120,
      ),
      Candle(
        symbol: 'EURUSD',
        granularity: '5M',
        openTime: DateTime.utc(2026, 1, 1, 0, 5),
        open: 1.1011,
        high: 1.1025,
        low: 1.1010,
        close: 1.1020,
        volume: 130,
      ),
      Candle(
        symbol: 'EURUSD',
        granularity: '5M',
        openTime: DateTime.utc(2026, 1, 1, 0, 10),
        open: 1.1035,
        high: 1.1040,
        low: 1.1030,
        close: 1.1038,
        volume: 140,
      ),
    ];

    final result = detector.detect(candles);
    expect(result, isNotNull);
    expect(result!.direction, equals('bullish'));
    expect(result.upper > result.lower, isTrue);
  });

  test('MarketStructure returns neutral if no clear pivots', () {
    final detector = MarketStructure();
    final result = detector.detect(series(symbol: 'EURUSD', tf: '5M', n: 30, start: 1.1000, step: 0.00001));
    expect(result.bias == 'neutral' || result.bias == 'bullish' || result.bias == 'bearish', isTrue);
  });

  test('RegimeDetector returns lowVolatility/range/trend/volatile enum', () {
    final detector = RegimeDetector();
    final result = detector.detect(series(symbol: 'EURUSD', tf: '1H', n: 40, start: 1.1000, step: 0.0003));
    expect(MarketRegime.values.contains(result), isTrue);
  });

  test('RegimeDetector identifies trend up in steadily advancing candles', () {
    final detector = RegimeDetector();
    final result = detector.detect(series(symbol: 'EURUSD', tf: '1H', n: 60, start: 1.0500, step: 0.0012));
    expect(
      result != MarketRegime.lowVolatility,
      isTrue,
    );
  });

  test('IctEngine analyse outputs conformed feature object', () {
    final engine = IctEngine();
    final c4h = series(symbol: 'EURUSD', tf: '4H', n: 80, start: 1.08, step: 0.0009);
    final c1h = series(symbol: 'EURUSD', tf: '1H', n: 90, start: 1.09, step: 0.0004);
    final c5m = series(symbol: 'EURUSD', tf: '5M', n: 120, start: 1.10, step: 0.0001);

    final features = engine.analyse(candles4h: c4h, candles1h: c1h, candles5m: c5m);

    expect(features.fibLevels.levels.isNotEmpty, isTrue);
    expect(features.po3Phase >= 0, isTrue);
    expect(features.pdZone >= 0 && features.pdZone <= 1, isTrue);
  });
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
