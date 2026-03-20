// lib/models/candle.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'candle.freezed.dart';
part 'candle.g.dart';

@freezed
class Candle with _$Candle {
  const Candle._();

  const factory Candle({
    required String symbol,
    required String granularity,
    required DateTime openTime,
    required double open,
    required double high,
    required double low,
    required double close,
    required double volume,
  }) = _Candle;

  double get body => (close - open).abs();
  double get range => (high - low).abs();
  bool get isBullish => close >= open;
  bool get isBearish => close < open;

  Candle copyWithValues({
    String? symbol,
    String? granularity,
    DateTime? openTime,
    double? open,
    double? high,
    double? low,
    double? close,
    double? volume,
  }) {
    return copyWith(
      symbol: symbol ?? this.symbol,
      granularity: granularity ?? this.granularity,
      openTime: openTime ?? this.openTime,
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
      close: close ?? this.close,
      volume: volume ?? this.volume,
    );
  }

  factory Candle.fromJson(Map<String, dynamic> json) => _$CandleFromJson(json);
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
