// lib/core/notifications/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';

class NotificationService {
  NotificationService({FlutterLocalNotificationsPlugin? plugin}) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  final Logger _logger = Logger('NotificationService');

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _onTap,
    );
  }

  Future<void> showProposalReady(String title, String body, {String? payload}) async {
    await _show(id: 1, title: title, body: body, payload: payload);
  }

  Future<void> showTradeOpened(String symbol, String dir, double entry) async {
    await _show(
      id: 2,
      title: '$symbol ${dir.toUpperCase()} opened',
      body: 'Entry ${entry.toStringAsFixed(5)}',
      payload: 'positions',
    );
  }

  Future<void> showTradeClosed(String symbol, double pnlMoney, double rr) async {
    final sign = pnlMoney >= 0 ? '+' : '-';
    await _show(
      id: 3,
      title: '$symbol closed $sign\$${pnlMoney.abs().toStringAsFixed(2)}',
      body: 'R:R ${rr.toStringAsFixed(2)}',
      payload: 'history',
    );
  }

  Future<void> showKillSwitch(String reason) async {
    await _show(
      id: 4,
      title: 'Kill Switch Activated',
      body: reason,
      payload: 'settings',
      highPriority: true,
    );
  }

  Future<void> showDrawdownWarning(double pct) async {
    await _show(
      id: 5,
      title: 'Drawdown Warning',
      body: 'Daily drawdown at ${pct.toStringAsFixed(1)}%',
      payload: 'dashboard',
    );
  }

  Future<void> showInfo(String title, String body) async {
    await _show(id: 6, title: title, body: body, payload: 'dashboard');
  }

  Future<void> _show({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool highPriority = false,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'quantai_channel',
        'QuantAI Alerts',
        channelDescription: 'Trading notifications',
        importance: highPriority ? Importance.max : Importance.defaultImportance,
        priority: highPriority ? Priority.max : Priority.defaultPriority,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    await _plugin.show(id, title, body, details, payload: payload);
  }

  void _onTap(NotificationResponse response) {
    _logger.info('Notification tap: ${response.payload}');
  }
}
