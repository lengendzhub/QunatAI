// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proposal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TradeProposalImpl _$$TradeProposalImplFromJson(Map<String, dynamic> json) =>
    _$TradeProposalImpl(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      timeframe: json['timeframe'] as String,
      direction: json['direction'] as String,
      entry: (json['entry'] as num).toDouble(),
      stopLoss: (json['stopLoss'] as num).toDouble(),
      takeProfit: (json['takeProfit'] as num).toDouble(),
      confidence: (json['confidence'] as num).toDouble(),
      explanation: json['explanation'] as String,
      regime: $enumDecode(_$MarketRegimeEnumMap, json['regime']),
      po3Phase: (json['po3Phase'] as num).toInt(),
      oteConfluence: json['oteConfluence'] as bool,
      mtfAligned: json['mtfAligned'] as bool,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      status: json['status'] as String? ?? 'pending',
    );

Map<String, dynamic> _$$TradeProposalImplToJson(_$TradeProposalImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'timeframe': instance.timeframe,
      'direction': instance.direction,
      'entry': instance.entry,
      'stopLoss': instance.stopLoss,
      'takeProfit': instance.takeProfit,
      'confidence': instance.confidence,
      'explanation': instance.explanation,
      'regime': _$MarketRegimeEnumMap[instance.regime]!,
      'po3Phase': instance.po3Phase,
      'oteConfluence': instance.oteConfluence,
      'mtfAligned': instance.mtfAligned,
      'generatedAt': instance.generatedAt.toIso8601String(),
      'status': instance.status,
    };

const _$MarketRegimeEnumMap = {
  MarketRegime.trendUp: 'trendUp',
  MarketRegime.trendDown: 'trendDown',
  MarketRegime.range: 'range',
  MarketRegime.volatile: 'volatile',
  MarketRegime.lowVolatility: 'lowVolatility',
};
