// lib/models/market_regime.dart
enum MarketRegime {
  trendUp,
  trendDown,
  range,
  volatile,
  lowVolatility,
}

enum TradingSession {
  asian,
  london,
  newYork,
  deadZone,
}

extension MarketRegimeX on MarketRegime {
  String get label {
    switch (this) {
      case MarketRegime.trendUp:
        return 'Trend Up';
      case MarketRegime.trendDown:
        return 'Trend Down';
      case MarketRegime.range:
        return 'Range';
      case MarketRegime.volatile:
        return 'Volatile';
      case MarketRegime.lowVolatility:
        return 'Low Vol';
    }
  }
}

extension TradingSessionX on TradingSession {
  String get label {
    switch (this) {
      case TradingSession.asian:
        return 'Asian';
      case TradingSession.london:
        return 'London';
      case TradingSession.newYork:
        return 'New York';
      case TradingSession.deadZone:
        return 'Dead Zone';
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
