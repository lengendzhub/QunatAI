// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ict_features.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderBlockZoneImpl _$$OrderBlockZoneImplFromJson(Map<String, dynamic> json) =>
    _$OrderBlockZoneImpl(
      direction: json['direction'] as String,
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      midpoint: (json['midpoint'] as num).toDouble(),
      strength: (json['strength'] as num).toDouble(),
      isValid: json['isValid'] as bool,
    );

Map<String, dynamic> _$$OrderBlockZoneImplToJson(
        _$OrderBlockZoneImpl instance) =>
    <String, dynamic>{
      'direction': instance.direction,
      'high': instance.high,
      'low': instance.low,
      'midpoint': instance.midpoint,
      'strength': instance.strength,
      'isValid': instance.isValid,
    };

_$FairValueGapZoneImpl _$$FairValueGapZoneImplFromJson(
        Map<String, dynamic> json) =>
    _$FairValueGapZoneImpl(
      direction: json['direction'] as String,
      upper: (json['upper'] as num).toDouble(),
      lower: (json['lower'] as num).toDouble(),
      isFilled: json['isFilled'] as bool,
    );

Map<String, dynamic> _$$FairValueGapZoneImplToJson(
        _$FairValueGapZoneImpl instance) =>
    <String, dynamic>{
      'direction': instance.direction,
      'upper': instance.upper,
      'lower': instance.lower,
      'isFilled': instance.isFilled,
    };

_$FibLevelsImpl _$$FibLevelsImplFromJson(Map<String, dynamic> json) =>
    _$FibLevelsImpl(
      swingHigh: (json['swingHigh'] as num).toDouble(),
      swingLow: (json['swingLow'] as num).toDouble(),
      levels: (json['levels'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$$FibLevelsImplToJson(_$FibLevelsImpl instance) =>
    <String, dynamic>{
      'swingHigh': instance.swingHigh,
      'swingLow': instance.swingLow,
      'levels': instance.levels,
    };

_$IctFeaturesImpl _$$IctFeaturesImplFromJson(Map<String, dynamic> json) =>
    _$IctFeaturesImpl(
      regime: $enumDecode(_$MarketRegimeEnumMap, json['regime']),
      session: $enumDecode(_$TradingSessionEnumMap, json['session']),
      ob: json['ob'] == null
          ? null
          : OrderBlockZone.fromJson(json['ob'] as Map<String, dynamic>),
      fvg: json['fvg'] == null
          ? null
          : FairValueGapZone.fromJson(json['fvg'] as Map<String, dynamic>),
      liquiditySweep: json['liquiditySweep'] as String,
      mss: json['mss'] as bool,
      bos: json['bos'] as bool,
      displacementBull: json['displacementBull'] as bool,
      displacementBear: json['displacementBear'] as bool,
      fibLevels: FibLevels.fromJson(json['fibLevels'] as Map<String, dynamic>),
      po3Phase: (json['po3Phase'] as num).toInt(),
      pdZone: (json['pdZone'] as num).toDouble(),
      pdDistance: (json['pdDistance'] as num).toDouble(),
      inducement: (json['inducement'] as num).toDouble(),
      inducementSwept: json['inducementSwept'] as bool,
      oteZoneUpper: (json['oteZoneUpper'] as num).toDouble(),
      oteZoneLower: (json['oteZoneLower'] as num).toDouble(),
      oteConfluence: json['oteConfluence'] as bool,
      mtfAligned: json['mtfAligned'] as bool,
      mtfBias4h: json['mtfBias4h'] as String?,
      mtfBias1h: json['mtfBias1h'] as String?,
    );

Map<String, dynamic> _$$IctFeaturesImplToJson(_$IctFeaturesImpl instance) =>
    <String, dynamic>{
      'regime': _$MarketRegimeEnumMap[instance.regime]!,
      'session': _$TradingSessionEnumMap[instance.session]!,
      'ob': instance.ob,
      'fvg': instance.fvg,
      'liquiditySweep': instance.liquiditySweep,
      'mss': instance.mss,
      'bos': instance.bos,
      'displacementBull': instance.displacementBull,
      'displacementBear': instance.displacementBear,
      'fibLevels': instance.fibLevels,
      'po3Phase': instance.po3Phase,
      'pdZone': instance.pdZone,
      'pdDistance': instance.pdDistance,
      'inducement': instance.inducement,
      'inducementSwept': instance.inducementSwept,
      'oteZoneUpper': instance.oteZoneUpper,
      'oteZoneLower': instance.oteZoneLower,
      'oteConfluence': instance.oteConfluence,
      'mtfAligned': instance.mtfAligned,
      'mtfBias4h': instance.mtfBias4h,
      'mtfBias1h': instance.mtfBias1h,
    };

const _$MarketRegimeEnumMap = {
  MarketRegime.trendUp: 'trendUp',
  MarketRegime.trendDown: 'trendDown',
  MarketRegime.range: 'range',
  MarketRegime.volatile: 'volatile',
  MarketRegime.lowVolatility: 'lowVolatility',
};

const _$TradingSessionEnumMap = {
  TradingSession.asian: 'asian',
  TradingSession.london: 'london',
  TradingSession.newYork: 'newYork',
  TradingSession.deadZone: 'deadZone',
};
