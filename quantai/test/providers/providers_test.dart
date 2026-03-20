// test/providers/providers_test.dart
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quantai/models/account_info.dart';
import 'package:quantai/models/candle.dart';
import 'package:quantai/models/execution_result.dart';
import 'package:quantai/models/tick.dart';
import 'package:quantai/models/trade.dart';
import 'package:quantai/providers/broker_provider.dart';
import 'package:quantai/providers/ticker_provider.dart';
import 'package:quantai/core/broker/base_broker.dart';

class FakeBroker implements BaseBroker {
  final StreamController<bool> _connectionController = StreamController<bool>.broadcast();

  int connectCallCount = 0;
  int disconnectCallCount = 0;

  @override
  Future<void> connect(String apiToken) async {
    connectCallCount += 1;
    _connectionController.add(true);
  }

  @override
  Stream<bool> get connectionStream => _connectionController.stream;

  @override
  Future<void> disconnect() async {
    disconnectCallCount += 1;
    _connectionController.add(false);
  }

  @override
  Future<AccountInfo> getAccountInfo() async => AccountInfo.empty();

  @override
  Future<List<Candle>> getCandles({required String symbol, required String granularity, required int count}) async => <Candle>[];

  @override
  Future<List<Trade>> getOpenPositions() async => <Trade>[];

  @override
  bool get isConnected => true;

  @override
  Future<ExecutionResult> placeMarketOrder({required String symbol, required String direction, required double lotSize, required double stopLoss, required double takeProfit}) async {
    return ExecutionResult(
      contractId: '1',
      symbol: symbol,
      direction: direction,
      filledPrice: 1,
      stopLoss: stopLoss,
      takeProfit: takeProfit,
      lotSize: lotSize,
      executedAt: DateTime.utc(2026, 1, 1),
      raw: <String, dynamic>{},
    );
  }

  @override
  Stream<Candle> candleStream({required String symbol, required String granularity}) => const Stream<Candle>.empty();

  @override
  Stream<Tick> tickStream(String symbol) => Stream<Tick>.value(
        Tick(symbol: symbol, bid: 1.1, ask: 1.1001, spread: 0.0001, timestamp: DateTime.utc(2026, 1, 1)),
      );

  @override
  Future<bool> closePosition(String contractId) async => true;

  @override
  Future<bool> modifyPosition({required String contractId, required double stopLoss, required double takeProfit}) async => true;

  Future<void> dispose() async {
    await _connectionController.close();
  }
}

void main() {
  test('brokerProvider returns overridden broker instance', () {
    final fake = FakeBroker();
    final container = ProviderContainer(
      overrides: <Override>[brokerProvider.overrideWithValue(fake)],
    );

    addTearDown(() async {
      await fake.dispose();
      container.dispose();
    });

    final resolved = container.read(brokerProvider);
    expect(identical(resolved, fake), isTrue);
  });

  test('tickStreamProvider yields tick from broker override', () async {
    final fake = FakeBroker();
    final container = ProviderContainer(
      overrides: <Override>[
        brokerProvider.overrideWithValue(fake),
      ],
    );

    addTearDown(() async {
      await fake.dispose();
      container.dispose();
    });

    final value = await container.read(tickStreamProvider('EURUSD').future);
    expect(value.symbol, equals('EURUSD'));
    expect(value.ask > value.bid, isTrue);
    expect(value.spread, closeTo(0.0001, 0.000001));
  });

  test('connectionStateProvider relays broker connection stream', () async {
    final fake = FakeBroker();
    final container = ProviderContainer(
      overrides: <Override>[brokerProvider.overrideWithValue(fake)],
    );

    addTearDown(() async {
      await fake.dispose();
      container.dispose();
    });

    final events = <bool>[];
    final sub = container.read(connectionStateProvider.stream).listen(events.add);

    await fake.connect('demo-token');
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await fake.disconnect();
    await Future<void>.delayed(const Duration(milliseconds: 5));

    await sub.cancel();

    expect(events, isNotEmpty);
    expect(events.contains(true), isTrue);
    expect(events.contains(false), isTrue);
    expect(fake.connectCallCount, equals(1));
    expect(fake.disconnectCallCount, equals(1));
  });
}
// length padding 1
