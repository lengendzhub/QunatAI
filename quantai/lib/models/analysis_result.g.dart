// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalysisResultImpl _$$AnalysisResultImplFromJson(Map<String, dynamic> json) =>
    _$AnalysisResultImpl(
      proposal:
          TradeProposal.fromJson(json['proposal'] as Map<String, dynamic>),
      features: IctFeatures.fromJson(json['features'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AnalysisResultImplToJson(
        _$AnalysisResultImpl instance) =>
    <String, dynamic>{
      'proposal': instance.proposal,
      'features': instance.features,
    };
