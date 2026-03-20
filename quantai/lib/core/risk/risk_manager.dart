// lib/core/risk/risk_manager.dart
import '../../models/market_regime.dart';
import '../../models/trade.dart';
import '../storage/daos/settings_dao.dart';
import '../storage/daos/trades_dao.dart';
import 'kill_switch.dart';
import 'position_sizer.dart';

class RiskCheckResult {
  const RiskCheckResult._({
    required this.allowed,
    required this.reason,
    required this.lotSize,
  });

  factory RiskCheckResult.blocked(String reason) {
    return RiskCheckResult._(allowed: false, reason: reason, lotSize: 0);
  }

  factory RiskCheckResult.allowed({required double lotSize}) {
    return RiskCheckResult._(allowed: true, reason: '', lotSize: lotSize);
  }

  final bool allowed;
  final String reason;
  final double lotSize;
}

class RiskManager {
  RiskManager(this._settings, this._trades);

  final SettingsDao _settings;
  final TradesDao _trades;

  Future<RiskCheckResult> checkAll({
    required String symbol,
    required String direction,
    required double accountBalance,
    required double entryPrice,
    required double stopLossPrice,
    required List<Trade> openPositions,
    required MarketRegime regime,
    required TradingSession session,
  }) async {
    if (await KillSwitch.isActive()) {
      return RiskCheckResult.blocked('Kill switch active');
    }

    if (session == TradingSession.deadZone) {
      return RiskCheckResult.blocked('Outside trading hours');
    }

    if (regime == MarketRegime.lowVolatility) {
      return RiskCheckResult.blocked('Low volatility - no trades');
    }

    final dailyDD = await _calcDailyDrawdown(accountBalance);
    if (dailyDD >= await _settings.getMaxDailyDD()) {
      await KillSwitch.activate('Daily drawdown limit hit');
      return RiskCheckResult.blocked('Daily drawdown limit hit');
    }

    if (openPositions.length >= await _settings.getMaxOpenTrades()) {
      return RiskCheckResult.blocked('Max open positions reached');
    }

    if (openPositions.any((t) => t.symbol == symbol)) {
      return RiskCheckResult.blocked('Already have open position on $symbol');
    }

    final correlationBlock = _checkCorrelation(symbol, direction, openPositions);
    if (correlationBlock != null) {
      return RiskCheckResult.blocked(correlationBlock);
    }

    final lotSize = await PositionSizer.calculate(
      balance: accountBalance,
      entry: entryPrice,
      stopLoss: stopLossPrice,
      symbol: symbol,
      riskPct: await _settings.getRiskPercent(),
      session: session,
    );

    return RiskCheckResult.allowed(lotSize: lotSize);
  }

  Future<double> _calcDailyDrawdown(double balance) async {
    final todayPnl = await _trades.getTodayPnl();
    if (balance <= 0) {
      return 0;
    }
    final dd = (-todayPnl / balance) * 100;
    return dd < 0 ? 0 : dd;
  }

  String? _checkCorrelation(String symbol, String direction, List<Trade> open) {
    final fxPositive = <String>{'EURUSD', 'GBPUSD', 'AUDUSD'};
    final fxNegative = <String>{'USDJPY', 'USDCAD'};

    final sameDirectionFx = open.where((t) {
      final s = t.symbol.toUpperCase();
      if (fxPositive.contains(symbol) && fxPositive.contains(s)) {
        return t.direction == direction;
      }
      if (fxNegative.contains(symbol) && fxNegative.contains(s)) {
        return t.direction == direction;
      }
      return false;
    }).length;

    if (sameDirectionFx >= 2) {
      return 'Correlation block: too many same-direction USD pairs';
    }

    if (symbol.toUpperCase() == 'XAUUSD') {
      final eur = open.where((t) => t.symbol.toUpperCase() == 'EURUSD' && t.direction == direction).isNotEmpty;
      if (eur) {
        return 'Correlation block: XAUUSD + EURUSD same direction';
      }
    }

    return null;
  }
}
