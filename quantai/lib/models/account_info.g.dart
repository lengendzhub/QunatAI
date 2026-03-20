// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountInfoImpl _$$AccountInfoImplFromJson(Map<String, dynamic> json) =>
    _$AccountInfoImpl(
      loginId: json['loginId'] as String,
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] as String,
      equity: (json['equity'] as num).toDouble(),
      marginUsed: (json['marginUsed'] as num).toDouble(),
      freeMargin: (json['freeMargin'] as num).toDouble(),
      dailyPnl: (json['dailyPnl'] as num).toDouble(),
      winRate: (json['winRate'] as num).toDouble(),
      tradesToday: (json['tradesToday'] as num).toInt(),
      maxDailyDrawdown: (json['maxDailyDrawdown'] as num).toDouble(),
    );

Map<String, dynamic> _$$AccountInfoImplToJson(_$AccountInfoImpl instance) =>
    <String, dynamic>{
      'loginId': instance.loginId,
      'balance': instance.balance,
      'currency': instance.currency,
      'equity': instance.equity,
      'marginUsed': instance.marginUsed,
      'freeMargin': instance.freeMargin,
      'dailyPnl': instance.dailyPnl,
      'winRate': instance.winRate,
      'tradesToday': instance.tradesToday,
      'maxDailyDrawdown': instance.maxDailyDrawdown,
    };
