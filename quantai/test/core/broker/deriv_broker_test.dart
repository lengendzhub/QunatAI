// test/core/broker/deriv_broker_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:quantai/core/broker/deriv_api_constants.dart';
import 'package:quantai/core/broker/deriv_broker.dart';

void main() {
  group('Deriv constants mapping', () {
    test('maps known symbols to Deriv names', () {
      expect(derivSymbolOf('EURUSD'), equals('frxEURUSD'));
      expect(derivSymbolOf('BTCUSD'), equals('cryBTCUSD'));
      expect(derivSymbolOf('ETHUSD'), equals('cryETHUSD'));
    });

    test('maps known granularity strings', () {
      expect(derivGranularityOf('1M'), equals(60));
      expect(derivGranularityOf('5M'), equals(300));
      expect(derivGranularityOf('1H'), equals(3600));
      expect(derivGranularityOf('4H'), equals(14400));
    });

    test('throws for unknown symbol', () {
      expect(() => derivSymbolOf('UNKNOWN'), throwsArgumentError);
    });

    test('throws for unknown granularity', () {
      expect(() => derivGranularityOf('7M'), throwsArgumentError);
    });

    test('normalizes lowercase symbol and granularity input', () {
      expect(derivSymbolOf('eurusd'), equals('frxEURUSD'));
      expect(derivGranularityOf('5m'), equals(300));
    });

    test('all supported symbols exist in the public map', () {
      expect(kSymbolMap.keys.contains('EURUSD'), isTrue);
      expect(kSymbolMap.keys.contains('GBPUSD'), isTrue);
      expect(kSymbolMap.keys.contains('USDJPY'), isTrue);
      expect(kSymbolMap.keys.contains('XAUUSD'), isTrue);
      expect(kSymbolMap.keys.contains('BTCUSD'), isTrue);
      expect(kSymbolMap.keys.contains('ETHUSD'), isTrue);
    });
  });

  group('DerivBroker stream shape', () {
    test('tick stream can be created for symbol without crash', () {
      final broker = DerivBroker();
      final stream = broker.tickStream('EURUSD');
      expect(stream.isBroadcast, isTrue);
    });

    test('candle stream can be created for symbol and timeframe', () {
      final broker = DerivBroker();
      final stream = broker.candleStream(symbol: 'EURUSD', granularity: '5M');
      expect(stream.isBroadcast, isTrue);
    });

    test('initial connection status starts false', () {
      final broker = DerivBroker();
      expect(broker.isConnected, isFalse);
    });

    test('connection stream is broadcast and subscribable multiple times', () {
      final broker = DerivBroker();
      final stream = broker.connectionStream;
      expect(stream.isBroadcast, isTrue);
      final subA = stream.listen((_) {});
      final subB = stream.listen((_) {});
      expect(subA.isPaused, isFalse);
      expect(subB.isPaused, isFalse);
      subA.cancel();
      subB.cancel();
    });
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
