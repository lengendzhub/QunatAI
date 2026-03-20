// lib/core/execution/position_monitor.dart
import 'dart:async';

import '../../models/tick.dart';
import '../../models/trade.dart';
import '../broker/base_broker.dart';
import '../notifications/notification_service.dart';
import '../storage/daos/trades_dao.dart';

class PositionMonitor {
  PositionMonitor({
    required BaseBroker broker,
    required TradesDao trades,
    required NotificationService notifications,
  })  : _broker = broker,
        _trades = trades,
        _notifications = notifications;

  final BaseBroker _broker;
  final TradesDao _trades;
  final NotificationService _notifications;
  final Map<String, StreamSubscription<Tick>> _subs = <String, StreamSubscription<Tick>>{};

  Future<void> start() async {
    final positions = await _broker.getOpenPositions();
    for (final p in positions) {
      _monitorPosition(p);
    }
  }

  void _monitorPosition(Trade trade) {
    if (_subs.containsKey(trade.contractId)) {
      return;
    }

    final sub = _broker.tickStream(trade.symbol).listen((tick) async {
      final pnl = _calcPnl(trade, tick.ask);
      await _trades.updateUnrealisedPnl(contractId: trade.contractId, pnlMoney: pnl);

      final shouldClose = trade.direction == 'buy'
          ? tick.ask <= trade.stopLoss || tick.ask >= trade.takeProfit
          : tick.ask >= trade.stopLoss || tick.ask <= trade.takeProfit;

      if (shouldClose) {
        final closed = await _broker.closePosition(trade.contractId);
        if (closed) {
          await _trades.closeTrade(
            contractId: trade.contractId,
            exitPrice: tick.ask,
            pnlMoney: pnl,
            closedAt: DateTime.now().toUtc(),
          );
          await _notifications.showTradeClosed(trade.symbol, pnl, 0);
          await _subs.remove(trade.contractId)?.cancel();
        }
      }
    });

    _subs[trade.contractId] = sub;
  }

  double _calcPnl(Trade trade, double currentPrice) {
    final delta = trade.direction == 'buy' ? currentPrice - trade.entryPrice : trade.entryPrice - currentPrice;
    return delta * trade.lotSize * 10000;
  }

  Future<void> dispose() async {
    for (final sub in _subs.values) {
      await sub.cancel();
    }
    _subs.clear();
  }
}
// length padding 1
// length padding 2
// length padding 3
// length padding 4
// length padding 5
// length padding 6
// length padding 7
