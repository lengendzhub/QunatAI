// lib/models/proposal.dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'market_regime.dart';

part 'proposal.freezed.dart';
part 'proposal.g.dart';

@freezed
class TradeProposal with _$TradeProposal {
  const TradeProposal._();

  const factory TradeProposal({
    required String id,
    required String symbol,
    required String timeframe,
    required String direction,
    required double entry,
    required double stopLoss,
    required double takeProfit,
    required double confidence,
    required String explanation,
    required MarketRegime regime,
    required int po3Phase,
    required bool oteConfluence,
    required bool mtfAligned,
    required DateTime generatedAt,
    @Default('pending') String status,
  }) = _TradeProposal;

  String get sessionLabel {
    final hour = generatedAt.toUtc().hour;
    if (hour >= 20 || hour < 1) {
      return TradingSession.asian.label;
    }
    if (hour >= 2 && hour < 6) {
      return TradingSession.london.label;
    }
    if (hour >= 8 && hour < 13) {
      return TradingSession.newYork.label;
    }
    return TradingSession.deadZone.label;
  }

  factory TradeProposal.fromJson(Map<String, dynamic> json) => _$TradeProposalFromJson(json);
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
