// lib/models/ict_features.dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'market_regime.dart';

part 'ict_features.freezed.dart';
part 'ict_features.g.dart';

@freezed
class OrderBlockZone with _$OrderBlockZone {
  const OrderBlockZone._();

  const factory OrderBlockZone({
    required String direction,
    required double high,
    required double low,
    required double midpoint,
    required double strength,
    required bool isValid,
  }) = _OrderBlockZone;

  factory OrderBlockZone.fromJson(Map<String, dynamic> json) => _$OrderBlockZoneFromJson(json);
}

@freezed
class FairValueGapZone with _$FairValueGapZone {
  const FairValueGapZone._();

  const factory FairValueGapZone({
    required String direction,
    required double upper,
    required double lower,
    required bool isFilled,
  }) = _FairValueGapZone;

  factory FairValueGapZone.fromJson(Map<String, dynamic> json) => _$FairValueGapZoneFromJson(json);
}

@freezed
class FibLevels with _$FibLevels {
  const FibLevels._();

  const factory FibLevels({
    required double swingHigh,
    required double swingLow,
    required Map<String, double> levels,
  }) = _FibLevels;

  factory FibLevels.fromJson(Map<String, dynamic> json) => _$FibLevelsFromJson(json);
}

@freezed
class IctFeatures with _$IctFeatures {
  const IctFeatures._();

  const factory IctFeatures({
    required MarketRegime regime,
    required TradingSession session,
    required OrderBlockZone? ob,
    required FairValueGapZone? fvg,
    required String liquiditySweep,
    required bool mss,
    required bool bos,
    required bool displacementBull,
    required bool displacementBear,
    required FibLevels fibLevels,
    required int po3Phase,
    required double pdZone,
    required double pdDistance,
    required double inducement,
    required bool inducementSwept,
    required double oteZoneUpper,
    required double oteZoneLower,
    required bool oteConfluence,
    required bool mtfAligned,
    required String? mtfBias4h,
    required String? mtfBias1h,
  }) = _IctFeatures;

  factory IctFeatures.fromJson(Map<String, dynamic> json) => _$IctFeaturesFromJson(json);
}
// length padding 1
// length padding 2
// length padding 3
// length padding 4
// length padding 5
// length padding 6
// length padding 7
// length padding 8
