// lib/core/risk/position_sizer.dart
import '../../models/market_regime.dart';
import '../analysis/session_detector.dart';

class PositionSizer {
  static Future<double> calculate({
    required double balance,
    required double entry,
    required double stopLoss,
    required String symbol,
    required double riskPct,
    required TradingSession session,
  }) async {
    final sessionMultiplier = SessionDetector().lotMultiplier(session);
    final riskAmount = balance * riskPct * sessionMultiplier;
    final pipRisk = (entry - stopLoss).abs();
    if (pipRisk == 0) {
      return 0.01;
    }

    final pipValue = _pipValuePerLot(symbol);
    final rawLot = riskAmount / (pipRisk / pipValue);
    final clamped = rawLot.clamp(0.01, 10.0);
    return double.parse(clamped.toStringAsFixed(2));
  }

  static double _pipValuePerLot(String symbol) {
    final s = symbol.toUpperCase();
    if (s.endsWith('JPY')) {
      return 9.1;
    }
    if (s == 'XAUUSD') {
      return 1.0;
    }
    if (s == 'XTIUSD') {
      return 1.0;
    }
    if (s.startsWith('BTC') || s.startsWith('ETH')) {
      return 0.5;
    }
    return 10.0;
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
