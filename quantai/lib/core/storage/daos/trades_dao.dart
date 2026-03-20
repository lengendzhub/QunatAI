// lib/core/storage/daos/trades_dao.dart
import 'package:drift/drift.dart' as drift;

import '../../../models/trade.dart';
import '../database.dart';

class TradesDao {
  TradesDao(this._db);

  final AppDatabase _db;

  Future<void> insertTrade(Trade trade) async {
    await _db.into(_db.tradesTable).insertOnConflictUpdate(
          TradesTableCompanion.insert(
            id: trade.id,
            symbol: trade.symbol,
            direction: trade.direction,
            entryPrice: trade.entryPrice,
            stopLoss: trade.stopLoss,
            takeProfit: trade.takeProfit,
            lotSize: trade.lotSize,
            openedAt: trade.openedAt,
            contractId: trade.contractId,
            status: trade.status,
            regime: trade.regime,
            session: trade.session,
            confidence: trade.confidence,
            exitPrice: drift.Value(trade.exitPrice),
            closedAt: drift.Value(trade.closedAt),
            pnlMoney: drift.Value(trade.pnlMoney),
            pnlPips: drift.Value(trade.pnlPips),
            riskRewardActual: drift.Value(trade.riskRewardActual),
          ),
        );
  }

  Future<List<Trade>> getOpenTrades() async {
    final rows = await (_db.select(_db.tradesTable)..where((t) => t.status.equals('open'))).get();
    return rows
        .map(
          (r) => Trade(
            id: r.id,
            symbol: r.symbol,
            direction: r.direction,
            entryPrice: r.entryPrice,
            exitPrice: r.exitPrice,
            stopLoss: r.stopLoss,
            takeProfit: r.takeProfit,
            lotSize: r.lotSize,
            openedAt: r.openedAt,
            closedAt: r.closedAt,
            pnlMoney: r.pnlMoney,
            pnlPips: r.pnlPips,
            riskRewardActual: r.riskRewardActual,
            contractId: r.contractId,
            status: r.status,
            regime: r.regime,
            session: r.session,
            confidence: r.confidence,
          ),
        )
        .toList();
  }

  Future<double> getTodayPnl() async {
    final now = DateTime.now().toUtc();
    final start = DateTime.utc(now.year, now.month, now.day);
    final rows = await (_db.select(_db.tradesTable)
          ..where((t) => t.closedAt.isBiggerOrEqualValue(start)))
        .get();
    return rows.fold<double>(0, (sum, row) => sum + row.pnlMoney);
  }

  Future<void> updateUnrealisedPnl({
    required String contractId,
    required double pnlMoney,
  }) async {
    await (_db.update(_db.tradesTable)..where((t) => t.contractId.equals(contractId))).write(
      TradesTableCompanion(
        pnlMoney: drift.Value(pnlMoney),
      ),
    );
  }

  Future<void> closeTrade({
    required String contractId,
    required double exitPrice,
    required double pnlMoney,
    required DateTime closedAt,
  }) async {
    await (_db.update(_db.tradesTable)..where((t) => t.contractId.equals(contractId))).write(
      TradesTableCompanion(
        status: const drift.Value('closed'),
        exitPrice: drift.Value(exitPrice),
        pnlMoney: drift.Value(pnlMoney),
        closedAt: drift.Value(closedAt),
      ),
    );
  }
}
