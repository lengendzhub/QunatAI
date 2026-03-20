// lib/core/execution/execution_engine.dart
import '../../models/execution_result.dart';
import '../../models/proposal.dart';
import '../../models/trade.dart';
import '../analysis/session_detector.dart';
import '../broker/base_broker.dart';
import '../notifications/notification_service.dart';
import '../risk/kill_switch.dart';
import '../risk/risk_manager.dart';
import '../storage/daos/trades_dao.dart';

class KillSwitchActiveException implements Exception {}

class RiskBlockedException implements Exception {
  RiskBlockedException(this.reason);
  final String reason;
}

class ExecutionEngine {
  ExecutionEngine({
    required BaseBroker broker,
    required RiskManager risk,
    required TradesDao trades,
    required NotificationService notifications,
  })  : _broker = broker,
        _risk = risk,
        _trades = trades,
        _notifications = notifications;

  final BaseBroker _broker;
  final RiskManager _risk;
  final TradesDao _trades;
  final NotificationService _notifications;

  Future<ExecutionResult> execute(TradeProposal proposal) async {
    if (await KillSwitch.isActive()) {
      throw KillSwitchActiveException();
    }

    final account = await _broker.getAccountInfo();
    final positions = await _broker.getOpenPositions();

    final risk = await _risk.checkAll(
      symbol: proposal.symbol,
      direction: proposal.direction,
      accountBalance: account.balance,
      entryPrice: proposal.entry,
      stopLossPrice: proposal.stopLoss,
      openPositions: positions,
      regime: proposal.regime,
      session: SessionDetector().current(),
    );

    if (!risk.allowed) {
      throw RiskBlockedException(risk.reason);
    }

    final result = await _broker.placeMarketOrder(
      symbol: proposal.symbol,
      direction: proposal.direction,
      lotSize: risk.lotSize,
      stopLoss: proposal.stopLoss,
      takeProfit: proposal.takeProfit,
    );

    final trade = Trade.fromExecutionResult(
      proposal: proposal,
      result: result,
      lotSize: risk.lotSize,
    );

    await _trades.insertTrade(trade);
    await _notifications.showTradeOpened(proposal.symbol, proposal.direction, result.filledPrice);

    return result;
  }
}
// length padding 1
// length padding 2
// length padding 3
