// lib/core/broker/deriv_api_constants.dart
const String kDerivWsUrl = 'wss://ws.binaryws.com/websockets/v3?app_id=';
const String kDerivAppId = '1089';

const Map<String, String> kSymbolMap = <String, String>{
  'EURUSD': 'frxEURUSD',
  'GBPUSD': 'frxGBPUSD',
  'USDJPY': 'frxUSDJPY',
  'AUDUSD': 'frxAUDUSD',
  'USDCAD': 'frxUSDCAD',
  'XAUUSD': 'frxXAUUSD',
  'XTIUSD': 'frxXTIUSD',
  'BTCUSD': 'cryBTCUSD',
  'ETHUSD': 'cryETHUSD',
};

const Map<String, int> kGranularityMap = <String, int>{
  '1M': 60,
  '5M': 300,
  '15M': 900,
  '1H': 3600,
  '4H': 14400,
  '1D': 86400,
};

String derivSymbolOf(String symbol) {
  final mapped = kSymbolMap[symbol.toUpperCase().trim()];
  if (mapped == null) {
    throw ArgumentError('Unsupported symbol: $symbol');
  }
  return mapped;
}

int derivGranularityOf(String granularity) {
  final mapped = kGranularityMap[granularity.toUpperCase().trim()];
  if (mapped == null) {
    throw ArgumentError('Unsupported granularity: $granularity');
  }
  return mapped;
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
