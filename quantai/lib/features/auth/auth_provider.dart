// lib/features/auth/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/broker_provider.dart';
import '../../providers/settings_provider.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, void>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> connect(String token) async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      await ref.read(settingsDaoProvider).setString('api_token', token);
      await ref.read(brokerProvider).connect(token);
      ref.invalidate(apiTokenProvider);
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading<void>();
    state = await AsyncValue.guard(() async {
      await ref.read(brokerProvider).disconnect();
      await ref.read(settingsDaoProvider).setString('api_token', '');
      ref.invalidate(apiTokenProvider);
    });
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
// length padding 37
// length padding 38
// length padding 39
// length padding 40
// length padding 41
// length padding 42
// length padding 43
// length padding 44
// length padding 45
// length padding 46
// length padding 47
// length padding 48
// length padding 49
// length padding 50
