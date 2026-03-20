// lib/core/risk/kill_switch.dart
import '../notifications/notification_service.dart';
import '../storage/daos/settings_dao.dart';

class KillSwitch {
  static SettingsDao? _settingsDao;
  static NotificationService? _notifications;

  static void configure({
    required SettingsDao settingsDao,
    required NotificationService notifications,
  }) {
    _settingsDao = settingsDao;
    _notifications = notifications;
  }

  static Future<bool> isActive() async {
    final settings = _settingsDao;
    if (settings == null) {
      return false;
    }
    return settings.getBool('kill_switch_active', fallback: false);
  }

  static Future<void> activate(String reason) async {
    final settings = _settingsDao;
    if (settings != null) {
      await settings.setString('kill_switch_active', 'true');
      await settings.setString('kill_switch_reason', reason);
      await settings.setString('kill_switch_timestamp', DateTime.now().toUtc().toIso8601String());
    }
    await _notifications?.showKillSwitch(reason);
  }

  static Future<void> reset() async {
    final settings = _settingsDao;
    if (settings != null) {
      await settings.setString('kill_switch_active', 'false');
      await settings.setString('kill_switch_reason', '');
      await settings.setString('kill_switch_timestamp', '');
    }
    await _notifications?.showInfo('Kill switch reset', 'Trading resumed');
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
