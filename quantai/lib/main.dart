// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';

import 'app.dart';
import 'core/ai/onnx_engine.dart';
import 'core/notifications/notification_service.dart';
import 'providers/broker_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _configureLogging();

  final logger = Logger('Main');

  final onnxEngine = OnnxEngine();
  try {
    await onnxEngine.load();
    logger.info('ONNX model loaded');
  } catch (error, stack) {
    logger.severe('Failed to load ONNX model', error, stack);
  }

  final notifications = NotificationService();
  try {
    await notifications.init();
  } catch (error, stack) {
    logger.severe('Notification init failed', error, stack);
  }

  await SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  runApp(
    ProviderScope(
      overrides: <Override>[
        onnxEngineProvider.overrideWithValue(onnxEngine),
        notificationServiceProvider.overrideWithValue(notifications),
      ],
      child: const QuantAiApp(),
    ),
  );
}

void _configureLogging() {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((LogRecord record) {
    debugPrint(
      '[${record.level.name}] ${record.time.toIso8601String()} '
      '${record.loggerName}: ${record.message}',
    );
    if (record.error != null) {
      debugPrint('Error: ${record.error}');
    }
    if (record.stackTrace != null) {
      debugPrint('Stack: ${record.stackTrace}');
    }
  });
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
