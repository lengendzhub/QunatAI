// lib/core/broker/deriv_broker.dart
import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../models/account_info.dart';
import '../../models/candle.dart';
import '../../models/execution_result.dart';
import '../../models/tick.dart';
import '../../models/trade.dart';
import 'base_broker.dart';
import 'deriv_api_constants.dart';

class DerivBroker implements BaseBroker {
  final Logger _logger = Logger('DerivBroker');
  final StreamController<bool> _connectionCtrl = StreamController<bool>.broadcast();
  final Map<String, StreamController<Tick>> _tickCtrls = <String, StreamController<Tick>>{};
  final Map<String, StreamController<Candle>> _candleCtrls = <String, StreamController<Candle>>{};
  final Map<int, Completer<Map<String, dynamic>>> _requests = <int, Completer<Map<String, dynamic>>>{};
  final Map<String, String> _tickSubIds = <String, String>{};
  final Map<String, String> _ohlcSubIds = <String, String>{};

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _socketSub;
  Timer? _pingTimer;
  bool _isConnected = false;
  String? _apiToken;
  int _requestId = 1000;
  int _reconnectAttempts = 0;
  bool _intentionalClose = false;

  @override
  bool get isConnected => _isConnected;

  @override
  Stream<bool> get connectionStream => _connectionCtrl.stream;

  @override
  Future<void> connect(String apiToken) async {
    _apiToken = apiToken;
    _intentionalClose = false;
    await _openAndAuthorize();
  }

  @override
  Future<void> disconnect() async {
    _intentionalClose = true;
    _pingTimer?.cancel();
    await _socketSub?.cancel();
    await _channel?.sink.close();
    _channel = null;
    _isConnected = false;
    _connectionCtrl.add(false);
  }

  Future<void> _openAndAuthorize() async {
    final token = _apiToken;
    if (token == null || token.isEmpty) {
      throw StateError('API token is required');
    }

    final uri = Uri.parse('$kDerivWsUrl$kDerivAppId');
    _logger.info('Connecting to $uri');
    _channel = WebSocketChannel.connect(uri);
    _socketSub = _channel!.stream.listen(
      _onMessage,
      onError: (Object error, StackTrace stack) {
        _logger.warning('Socket error', error, stack);
        _onDisconnected();
      },
      onDone: _onDisconnected,
      cancelOnError: false,
    );

    final auth = await _sendRequest(<String, dynamic>{
      'authorize': token,
    }, expectType: 'authorize');

    if (auth['error'] != null) {
      throw StateError('Auth failed: ${auth['error']}');
    }

    _isConnected = true;
    _reconnectAttempts = 0;
    _connectionCtrl.add(true);
    _startPing();
    await _sendRequest(<String, dynamic>{'portfolio': 1}, expectType: 'portfolio');
    _logger.info('Connected and authorized');
  }

  void _onDisconnected() {
    _isConnected = false;
    _connectionCtrl.add(false);
    _pingTimer?.cancel();
    if (_intentionalClose) {
      return;
    }
    unawaited(_reconnect());
  }

  Future<void> _reconnect() async {
    while (!_intentionalClose && _reconnectAttempts < 10) {
      _reconnectAttempts += 1;
      final seconds = _backoffSeconds(_reconnectAttempts);
      await Future<void>.delayed(Duration(seconds: seconds));
      try {
        await _openAndAuthorize();
        for (final symbol in _tickCtrls.keys) {
          await _subscribeTicks(symbol);
        }
        for (final key in _candleCtrls.keys) {
          final parts = key.split('|');
          if (parts.length == 2) {
            await _subscribeOhlc(parts[0], parts[1]);
          }
        }
        return;
      } catch (error, stack) {
        _logger.warning('Reconnect attempt $_reconnectAttempts failed', error, stack);
      }
    }
    _connectionCtrl.add(false);
    _logger.severe('Reconnect failed after 10 attempts');
  }

  int _backoffSeconds(int attempt) {
    if (attempt <= 1) return 1;
    if (attempt == 2) return 2;
    if (attempt == 3) return 4;
    if (attempt == 4) return 8;
    if (attempt == 5) return 16;
    return 30;
  }

  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _channel?.sink.add(jsonEncode(<String, dynamic>{'ping': 1}));
    });
  }

  int _nextId() => ++_requestId;

  Future<Map<String, dynamic>> _sendRequest(
    Map<String, dynamic> payload, {
    String? expectType,
    Duration timeout = const Duration(seconds: 20),
  }) {
    final reqId = _nextId();
    final completer = Completer<Map<String, dynamic>>();
    _requests[reqId] = completer;

    final data = <String, dynamic>{...payload, 'req_id': reqId};
    _channel?.sink.add(jsonEncode(data));

    return completer.future.timeout(timeout, onTimeout: () {
      _requests.remove(reqId);
      throw TimeoutException('Deriv request timed out ($expectType)');
    });
  }

  void _onMessage(dynamic raw) {
    try {
      final msg = jsonDecode(raw as String) as Map<String, dynamic>;
      final reqId = msg['req_id'];
      if (reqId is int && _requests.containsKey(reqId)) {
        _requests.remove(reqId)?.complete(msg);
      }

      final type = msg['msg_type'] as String?;
      switch (type) {
        case 'authorize':
          break;
        case 'tick':
          _handleTick(msg);
          break;
        case 'ohlc':
          _handleOhlc(msg);
          break;
        case 'proposal':
        case 'buy':
        case 'sell':
        case 'portfolio':
        case 'proposal_open_contract':
          break;
        case 'error':
          _logger.warning('Deriv error: ${msg['error']}');
          break;
        default:
          break;
      }
    } catch (error, stack) {
      _logger.warning('Failed to process message', error, stack);
    }
  }

  void _handleTick(Map<String, dynamic> msg) {
    final tick = msg['tick'] as Map<String, dynamic>?;
    if (tick == null) return;

    final symbol = (tick['symbol'] as String? ?? '').replaceFirst('frx', '').replaceFirst('cry', '');
    final quote = (tick['quote'] as num?)?.toDouble();
    if (symbol.isEmpty || quote == null) return;

    final bid = quote;
    final ask = quote;
    final model = Tick.fromBidAsk(
      symbol: symbol,
      bid: bid,
      ask: ask,
      timestamp: DateTime.fromMillisecondsSinceEpoch((tick['epoch'] as int? ?? 0) * 1000, isUtc: true),
    );

    _tickCtrls[symbol]?.add(model);
  }

  void _handleOhlc(Map<String, dynamic> msg) {
    final ohlc = msg['ohlc'] as Map<String, dynamic>?;
    if (ohlc == null) return;

    final derivSymbol = ohlc['symbol'] as String?;
    final granularitySec = (ohlc['granularity'] as num?)?.toInt() ?? 60;
    if (derivSymbol == null) return;

    final symbol = kSymbolMap.entries.firstWhere(
      (e) => e.value == derivSymbol,
      orElse: () => const MapEntry<String, String>('UNKNOWN', 'UNKNOWN'),
    ).key;

    final granularity = kGranularityMap.entries.firstWhere(
      (e) => e.value == granularitySec,
      orElse: () => const MapEntry<String, int>('1M', 60),
    ).key;

    final candle = Candle(
      symbol: symbol,
      granularity: granularity,
      openTime: DateTime.fromMillisecondsSinceEpoch((ohlc['open_time'] as int? ?? 0) * 1000, isUtc: true),
      open: (ohlc['open'] as num?)?.toDouble() ?? 0,
      high: (ohlc['high'] as num?)?.toDouble() ?? 0,
      low: (ohlc['low'] as num?)?.toDouble() ?? 0,
      close: (ohlc['close'] as num?)?.toDouble() ?? 0,
      volume: (ohlc['volume'] as num?)?.toDouble() ?? 0,
    );

    _candleCtrls['$symbol|$granularity']?.add(candle);
  }

  Future<void> _subscribeTicks(String symbol) async {
    final req = await _sendRequest(<String, dynamic>{
      'ticks': derivSymbolOf(symbol),
      'subscribe': 1,
    }, expectType: 'tick');
    final id = req['subscription']?['id'] as String?;
    if (id != null) {
      _tickSubIds[symbol] = id;
    }
  }

  Future<void> _subscribeOhlc(String symbol, String granularity) async {
    final req = await _sendRequest(<String, dynamic>{
      'ticks_history': derivSymbolOf(symbol),
      'granularity': derivGranularityOf(granularity),
      'count': 1,
      'end': 'latest',
      'style': 'candles',
      'subscribe': 1,
    }, expectType: 'ohlc');
    final id = req['subscription']?['id'] as String?;
    if (id != null) {
      _ohlcSubIds['$symbol|$granularity'] = id;
    }
  }

  @override
  Stream<Tick> tickStream(String symbol) {
    final key = symbol.toUpperCase();
    final ctrl = _tickCtrls.putIfAbsent(key, () => StreamController<Tick>.broadcast(
          onListen: () => unawaited(_subscribeTicks(key)),
        ));
    return ctrl.stream;
  }

  @override
  Future<List<Candle>> getCandles({
    required String symbol,
    required String granularity,
    required int count,
  }) async {
    final resp = await _sendRequest(<String, dynamic>{
      'ticks_history': derivSymbolOf(symbol),
      'granularity': derivGranularityOf(granularity),
      'count': count,
      'end': 'latest',
      'style': 'candles',
    }, expectType: 'candles');

    final candlesRaw = resp['candles'] as List<dynamic>? ?? <dynamic>[];
    return candlesRaw.map((dynamic item) {
      final candle = item as Map<String, dynamic>;
      return Candle(
        symbol: symbol,
        granularity: granularity,
        openTime: DateTime.fromMillisecondsSinceEpoch((candle['epoch'] as int) * 1000, isUtc: true),
        open: (candle['open'] as num).toDouble(),
        high: (candle['high'] as num).toDouble(),
        low: (candle['low'] as num).toDouble(),
        close: (candle['close'] as num).toDouble(),
        volume: (candle['volume'] as num?)?.toDouble() ?? 0,
      );
    }).toList(growable: false);
  }

  @override
  Stream<Candle> candleStream({required String symbol, required String granularity}) {
    final key = '${symbol.toUpperCase()}|${granularity.toUpperCase()}';
    final ctrl = _candleCtrls.putIfAbsent(key, () => StreamController<Candle>.broadcast(
          onListen: () => unawaited(_subscribeOhlc(symbol.toUpperCase(), granularity.toUpperCase())),
        ));
    return ctrl.stream;
  }

  @override
  Future<AccountInfo> getAccountInfo() async {
    final auth = await _sendRequest(<String, dynamic>{'authorize': _apiToken}, expectType: 'authorize');
    final data = auth['authorize'] as Map<String, dynamic>?;
    if (data == null) {
      return AccountInfo.empty();
    }
    final balanceInfo = data['balance'] as Map<String, dynamic>?;
    return AccountInfo(
      loginId: data['loginid'] as String? ?? 'N/A',
      balance: (balanceInfo?['balance'] as num? ?? 0).toDouble(),
      currency: balanceInfo?['currency'] as String? ?? 'USD',
      equity: (balanceInfo?['balance'] as num? ?? 0).toDouble(),
      marginUsed: 0,
      freeMargin: (balanceInfo?['balance'] as num? ?? 0).toDouble(),
      dailyPnl: 0,
      winRate: 0,
      tradesToday: 0,
      maxDailyDrawdown: 0,
    );
  }

  @override
  Future<ExecutionResult> placeMarketOrder({
    required String symbol,
    required String direction,
    required double lotSize,
    required double stopLoss,
    required double takeProfit,
  }) async {
    final proposal = await _sendRequest(<String, dynamic>{
      'proposal': 1,
      'amount': lotSize,
      'basis': 'stake',
      'contract_type': direction == 'buy' ? 'MULTUP' : 'MULTDOWN',
      'currency': 'USD',
      'symbol': derivSymbolOf(symbol),
      'multiplier': 1,
      'limit_order': <String, dynamic>{
        'stop_loss': stopLoss,
        'take_profit': takeProfit,
      },
    }, expectType: 'proposal');

    final proposalId = proposal['proposal']?['id'];
    final askPrice = (proposal['proposal']?['ask_price'] as num?)?.toDouble() ?? 0;
    if (proposalId == null) {
      throw StateError('No proposal id from Deriv');
    }

    final buy = await _sendRequest(<String, dynamic>{
      'buy': proposalId,
      'price': askPrice,
    }, expectType: 'buy');

    final buyData = buy['buy'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return ExecutionResult(
      contractId: (buyData['contract_id'] ?? buyData['transaction_id'] ?? '').toString(),
      symbol: symbol,
      direction: direction,
      filledPrice: (buyData['buy_price'] as num? ?? askPrice).toDouble(),
      stopLoss: stopLoss,
      takeProfit: takeProfit,
      lotSize: lotSize,
      executedAt: DateTime.now().toUtc(),
      raw: buy,
    );
  }

  @override
  Future<bool> closePosition(String contractId) async {
    final result = await _sendRequest(<String, dynamic>{
      'sell': contractId,
      'price': 0,
    }, expectType: 'sell');
    return result['error'] == null;
  }

  @override
  Future<bool> modifyPosition({
    required String contractId,
    required double stopLoss,
    required double takeProfit,
  }) async {
    final result = await _sendRequest(<String, dynamic>{
      'contract_update': 1,
      'contract_id': contractId,
      'limit_order': <String, dynamic>{
        'stop_loss': stopLoss,
        'take_profit': takeProfit,
      },
    }, expectType: 'contract_update');
    return result['error'] == null;
  }

  @override
  Future<List<Trade>> getOpenPositions() async {
    final portfolio = await _sendRequest(<String, dynamic>{'portfolio': 1}, expectType: 'portfolio');
    final contracts = portfolio['portfolio']?['contracts'] as List<dynamic>? ?? <dynamic>[];

    return contracts.map((dynamic item) {
      final c = item as Map<String, dynamic>;
      final purchase = (c['buy_price'] as num? ?? 0).toDouble();
      final sl = (c['limit_order']?['stop_loss'] as num? ?? 0).toDouble();
      final tp = (c['limit_order']?['take_profit'] as num? ?? 0).toDouble();
      return Trade(
        id: (c['contract_id'] ?? '').toString(),
        symbol: _decodeDisplaySymbol((c['symbol'] ?? '') as String),
        direction: ((c['contract_type'] ?? '') as String).contains('UP') ? 'buy' : 'sell',
        entryPrice: purchase,
        exitPrice: null,
        stopLoss: sl,
        takeProfit: tp,
        lotSize: (c['amount'] as num? ?? 0).toDouble(),
        openedAt: DateTime.fromMillisecondsSinceEpoch(((c['date_start'] as int?) ?? 0) * 1000, isUtc: true),
        closedAt: null,
        pnlMoney: (c['profit'] as num? ?? 0).toDouble(),
        pnlPips: 0,
        riskRewardActual: 0,
        contractId: (c['contract_id'] ?? '').toString(),
        status: 'open',
        regime: 'range',
        session: 'Unknown',
        confidence: 0.0,
      );
    }).toList(growable: false);
  }

  String _decodeDisplaySymbol(String derivSymbol) {
    final found = kSymbolMap.entries.where((e) => e.value == derivSymbol).toList();
    if (found.isEmpty) return derivSymbol;
    return found.first.key;
  }
}
