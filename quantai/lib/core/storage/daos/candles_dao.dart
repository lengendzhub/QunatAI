// lib/core/storage/daos/candles_dao.dart
import 'package:drift/drift.dart' as drift;

import '../../../models/candle.dart';
import '../database.dart';

class CandlesDao {
  CandlesDao(this._db);

  final AppDatabase _db;

  Future<List<Candle>> getCandles(
    String symbol,
    String granularity, {
    int limit = 200,
  }) async {
    final rows = await (_db.select(_db.candlesTable)
          ..where((t) => t.symbol.equals(symbol) & t.granularity.equals(granularity))
          ..orderBy([(t) => drift.OrderingTerm.asc(t.openTime)])
          ..limit(limit))
        .get();

    return rows
        .map(
          (r) => Candle(
            symbol: r.symbol,
            granularity: r.granularity,
            openTime: r.openTime,
            open: r.open,
            high: r.high,
            low: r.low,
            close: r.close,
            volume: r.volume,
          ),
        )
        .toList();
  }

  Future<void> upsertCandles(List<Candle> candles) async {
    await _db.batch((batch) {
      for (final c in candles) {
        batch.insert(
          _db.candlesTable,
          CandlesTableCompanion.insert(
            symbol: c.symbol,
            granularity: c.granularity,
            openTime: c.openTime,
            open: c.open,
            high: c.high,
            low: c.low,
            close: c.close,
            volume: drift.Value(c.volume),
          ),
          mode: drift.InsertMode.insertOrReplace,
        );
      }
    });

    if (candles.isNotEmpty) {
      final symbol = candles.first.symbol;
      final granularity = candles.first.granularity;
      final all = await (_db.select(_db.candlesTable)
            ..where((t) => t.symbol.equals(symbol) & t.granularity.equals(granularity))
            ..orderBy([(t) => drift.OrderingTerm.desc(t.openTime)]))
          .get();
      if (all.length > 500) {
        final stale = all.sublist(500);
        for (final row in stale) {
          await (_db.delete(_db.candlesTable)..where((t) => t.id.equals(row.id))).go();
        }
      }
    }
  }
}
// length padding 1
// length padding 2
// length padding 3
// length padding 4
// length padding 5
// length padding 6
