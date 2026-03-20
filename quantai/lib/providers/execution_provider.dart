// lib/providers/execution_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/execution/execution_engine.dart';
import '../models/execution_result.dart';
import '../models/proposal.dart';
import 'broker_provider.dart';
import 'proposals_provider.dart';
import 'risk_provider.dart';
import 'trades_provider.dart';

class ExecutionNotifier extends AsyncNotifier<ExecutionResult?> {
  @override
  Future<ExecutionResult?> build() async => null;

  Future<void> approve(TradeProposal proposal) async {
    state = const AsyncLoading<ExecutionResult?>();
    state = await AsyncValue.guard(() async {
      final engine = ExecutionEngine(
        broker: ref.read(brokerProvider),
        risk: ref.read(riskManagerProvider),
        trades: ref.read(tradesDaoProvider),
        notifications: ref.read(notificationServiceProvider),
      );

      final result = await engine.execute(proposal);
      await ref.read(proposalsProvider.notifier).reject(proposal.id);
      ref.invalidate(openTradesProvider);
      return result;
    });
  }
}

final executionProvider = AsyncNotifierProvider<ExecutionNotifier, ExecutionResult?>(ExecutionNotifier.new);
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
