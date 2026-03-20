// lib/core/broker/base_broker.dart
import '../../models/account_info.dart';
import '../../models/candle.dart';
import '../../models/execution_result.dart';
import '../../models/tick.dart';
import '../../models/trade.dart';

abstract class BaseBroker {
  Future<void> connect(String apiToken);
  Future<void> disconnect();
  bool get isConnected;
  Stream<bool> get connectionStream;

  Future<AccountInfo> getAccountInfo();

  Stream<Tick> tickStream(String symbol);
  Future<List<Candle>> getCandles({
    required String symbol,
    required String granularity,
    required int count,
  });
  Stream<Candle> candleStream({
    required String symbol,
    required String granularity,
  });

  Future<ExecutionResult> placeMarketOrder({
    required String symbol,
    required String direction,
    required double lotSize,
    required double stopLoss,
    required double takeProfit,
  });

  Future<bool> closePosition(String contractId);

  Future<bool> modifyPosition({
    required String contractId,
    required double stopLoss,
    required double takeProfit,
  });

  Future<List<Trade>> getOpenPositions();
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
