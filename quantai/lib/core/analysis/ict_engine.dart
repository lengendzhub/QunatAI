// lib/core/analysis/ict_engine.dart
import '../../models/candle.dart';
import '../../models/ict_features.dart';
import '../utils/math_utils.dart';
import 'fair_value_gap.dart';
import 'fibonacci.dart';
import 'liquidity_sweep.dart';
import 'market_structure.dart';
import 'order_block.dart';
import 'ote_calculator.dart';
import 'po3_detector.dart';
import 'regime_detector.dart';
import 'session_detector.dart';

class IctEngine {
  IctEngine({
    OrderBlockDetector? ob,
    FairValueGapDetector? fvg,
    LiquidityDetector? liq,
    MarketStructure? ms,
    Po3Detector? po3,
    OteCalculator? ote,
    FibonacciCalculator? fib,
    RegimeDetector? regime,
    SessionDetector? session,
  })  : _ob = ob ?? OrderBlockDetector(),
        _fvg = fvg ?? FairValueGapDetector(),
        _liq = liq ?? LiquidityDetector(),
        _ms = ms ?? MarketStructure(),
        _po3 = po3 ?? Po3Detector(),
        _ote = ote ?? OteCalculator(),
        _fib = fib ?? FibonacciCalculator(),
        _regime = regime ?? RegimeDetector(),
        _session = session ?? SessionDetector();

  final OrderBlockDetector _ob;
  final FairValueGapDetector _fvg;
  final LiquidityDetector _liq;
  final MarketStructure _ms;
  final Po3Detector _po3;
  final OteCalculator _ote;
  final FibonacciCalculator _fib;
  final RegimeDetector _regime;
  final SessionDetector _session;

  IctFeatures analyse({
    required List<Candle> candles4h,
    required List<Candle> candles1h,
    required List<Candle> candles5m,
  }) {
    final regime = _regime.detect(candles1h);
    final session = _session.current();

    final ob4h = _ob.detect(candles4h);
    final ob1h = _ob.detect(candles1h);
    final ob5m = _ob.detect(candles5m);

    final fvg5m = _fvg.detect(candles5m);
    final liq = _liq.detect(candles5m);
    final ms1h = _ms.detect(candles1h);
    final ms5m = _ms.detect(candles5m);
    final po3 = _po3.detect(candles4h, candles1h, candles5m);
    final fib = _fib.compute(candles1h);
    final ote = _ote.compute(fib, ob1h);

    final close = candles1h.isEmpty ? 0.0 : candles1h.last.close;
    final pd = _computePdZone(fib, close);

    return IctFeatures(
      regime: regime,
      session: session,
      ob: ob5m,
      fvg: fvg5m,
      liquiditySweep: liq.lastSweepDirection,
      mss: ms5m.mssDetected,
      bos: ms5m.bosDetected,
      displacementBull: ms5m.displacementBullish,
      displacementBear: ms5m.displacementBearish,
      fibLevels: fib,
      po3Phase: po3.phase,
      pdZone: pd,
      pdDistance: _pdDistance(fib, close),
      inducement: liq.inducementLevel,
      inducementSwept: liq.inducementSwept,
      oteZoneUpper: ote.upper,
      oteZoneLower: ote.lower,
      oteConfluence: ote.hasConfluence,
      mtfAligned: _checkMtfConfluence(ob4h, ms1h, fvg5m, ote),
      mtfBias4h: ob4h?.direction,
      mtfBias1h: ms1h.bias,
    );
  }

  double _computePdZone(FibLevels fib, double price) {
    final hi = fib.swingHigh;
    final lo = fib.swingLow;
    if (hi == lo) return 0.5;
    return clamp01((price - lo) / (hi - lo));
  }

  double _pdDistance(FibLevels fib, double price) {
    final equilibrium = (fib.swingHigh + fib.swingLow) / 2;
    return (price - equilibrium).abs();
  }

  bool _checkMtfConfluence(
    OrderBlockZone? ob4h,
    MarketStructureResult ms1h,
    FairValueGapZone? fvg5m,
    OteResult ote,
  ) {
    final directional = ob4h?.direction == 'bullish' && ms1h.bias == 'bullish' ||
        ob4h?.direction == 'bearish' && ms1h.bias == 'bearish';

    final imbalance = fvg5m != null && !fvg5m.isFilled;

    return directional && imbalance && ote.hasConfluence;
  }
}
