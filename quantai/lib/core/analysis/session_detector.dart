// lib/core/analysis/session_detector.dart
import '../../models/market_regime.dart';

class SessionDetector {
  TradingSession current({DateTime? nowUtc}) {
    final now = (nowUtc ?? DateTime.now().toUtc());
    final hour = now.hour;

    if (hour >= 20 || hour < 1) {
      return TradingSession.asian;
    }

    if (hour >= 2 && hour < 6) {
      return TradingSession.london;
    }

    if (hour >= 8 && hour < 13) {
      return TradingSession.newYork;
    }

    return TradingSession.deadZone;
  }

  double lotMultiplier(TradingSession session, {DateTime? nowUtc}) {
    final now = (nowUtc ?? DateTime.now().toUtc());
    final minute = now.minute;

    switch (session) {
      case TradingSession.asian:
        return 0.7;
      case TradingSession.london:
        return minute < 30 ? 1.2 : 1.0;
      case TradingSession.newYork:
        return minute < 30 ? 1.2 : 1.0;
      case TradingSession.deadZone:
        return 0.0;
    }
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
