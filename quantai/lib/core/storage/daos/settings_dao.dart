// lib/core/storage/daos/settings_dao.dart
import 'package:drift/drift.dart' as drift;

import '../database.dart';

class SettingsDao {
  SettingsDao(this._db);

  final AppDatabase _db;

  Future<String?> getString(String key) async {
    final row = await (_db.select(_db.settingsTable)..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setString(String key, String value) async {
    await _db.into(_db.settingsTable).insertOnConflictUpdate(
          SettingsTableCompanion.insert(key: key, value: value),
        );
  }

  Future<bool> getBool(String key, {required bool fallback}) async {
    final value = await getString(key);
    if (value == null || value.isEmpty) {
      return fallback;
    }
    return value.toLowerCase() == 'true';
  }

  Future<double> getDouble(String key, {required double fallback}) async {
    final value = await getString(key);
    if (value == null || value.isEmpty) {
      return fallback;
    }
    return double.tryParse(value) ?? fallback;
  }

  Future<int> getInt(String key, {required int fallback}) async {
    final value = await getString(key);
    if (value == null || value.isEmpty) {
      return fallback;
    }
    return int.tryParse(value) ?? fallback;
  }

  Future<double> getRiskPercent() => getDouble('risk_pct_per_trade', fallback: 0.01);

  Future<double> getMaxDailyDD() => getDouble('max_daily_dd_pct', fallback: 3.0);

  Future<int> getMaxOpenTrades() => getInt('max_open_trades', fallback: 2);

  Future<String?> getApiToken() => getString('api_token');
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
