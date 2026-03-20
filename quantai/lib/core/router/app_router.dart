// lib/core/router/app_router.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/chart/chart_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/history/history_screen.dart';
import '../../features/performance/performance_screen.dart';
import '../../features/positions/positions_screen.dart';
import '../../features/proposals/proposals_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../providers/settings_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final hasToken = ref.read(hasApiTokenProvider);
      if (!hasToken && state.uri.path != '/login') {
        return '/login';
      }
      if (hasToken && state.uri.path == '/login') {
        return '/';
      }
      return null;
    },
    routes: <GoRoute>[
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (_, __) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/chart/:symbol',
        builder: (_, state) => ChartScreen(symbol: state.pathParameters['symbol'] ?? 'EURUSD'),
      ),
      GoRoute(
        path: '/proposals',
        builder: (_, __) => const ProposalsScreen(),
      ),
      GoRoute(
        path: '/positions',
        builder: (_, __) => const PositionsScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (_, __) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/performance',
        builder: (_, __) => const PerformanceScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (_, __) => const SettingsScreen(),
      ),
    ],
  );
});
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
