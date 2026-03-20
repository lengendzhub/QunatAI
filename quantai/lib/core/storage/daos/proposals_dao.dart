// lib/core/storage/daos/proposals_dao.dart
import 'package:drift/drift.dart' as drift;

import '../../../models/market_regime.dart';
import '../../../models/proposal.dart';
import '../database.dart';

class ProposalsDao {
  ProposalsDao(this._db);

  final AppDatabase _db;

  Future<void> insertProposal(TradeProposal proposal) async {
    await _db.into(_db.proposalsTable).insertOnConflictUpdate(
          ProposalsTableCompanion.insert(
            id: proposal.id,
            symbol: proposal.symbol,
            timeframe: proposal.timeframe,
            direction: proposal.direction,
            entry: proposal.entry,
            stopLoss: proposal.stopLoss,
            takeProfit: proposal.takeProfit,
            confidence: proposal.confidence,
            explanation: proposal.explanation,
            regime: proposal.regime.name,
            po3Phase: proposal.po3Phase,
            oteConfluence: proposal.oteConfluence,
            mtfAligned: proposal.mtfAligned,
            generatedAt: proposal.generatedAt,
            status: proposal.status,
          ),
        );
  }

  Future<List<TradeProposal>> getPending() async {
    final rows = await (_db.select(_db.proposalsTable)..where((t) => t.status.equals('pending'))).get();
    return rows
        .map(
          (r) => TradeProposal(
            id: r.id,
            symbol: r.symbol,
            timeframe: r.timeframe,
            direction: r.direction,
            entry: r.entry,
            stopLoss: r.stopLoss,
            takeProfit: r.takeProfit,
            confidence: r.confidence,
            explanation: r.explanation,
            regime: MarketRegime.values.firstWhere(
              (e) => e.name == r.regime,
              orElse: () => MarketRegime.range,
            ),
            po3Phase: r.po3Phase,
            oteConfluence: r.oteConfluence,
            mtfAligned: r.mtfAligned,
            generatedAt: r.generatedAt,
            status: r.status,
          ),
        )
        .toList();
  }

  Future<void> updateStatus(String id, String status) async {
    await (_db.update(_db.proposalsTable)..where((t) => t.id.equals(id))).write(
      ProposalsTableCompanion(status: drift.Value(status)),
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
