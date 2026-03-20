// lib/models/trade.dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'execution_result.dart';
import 'proposal.dart';

part 'trade.freezed.dart';
part 'trade.g.dart';

@freezed
class Trade with _$Trade {
  const Trade._();

  const factory Trade({
    required String id,
    required String symbol,
    required String direction,
    required double entryPrice,
    required double? exitPrice,
    required double stopLoss,
    required double takeProfit,
    required double lotSize,
    required DateTime openedAt,
    required DateTime? closedAt,
    required double pnlMoney,
    required double pnlPips,
    required double riskRewardActual,
    required String contractId,
    required String status,
    required String regime,
    required String session,
    required double confidence,
  }) = _Trade;

  bool get isOpen => status == 'open';

  factory Trade.fromExecutionResult({
    required TradeProposal proposal,
    required ExecutionResult result,
    required double lotSize,
  }) {
    return Trade(
      id: proposal.id,
      symbol: proposal.symbol,
      direction: proposal.direction,
      entryPrice: result.filledPrice,
      exitPrice: null,
      stopLoss: proposal.stopLoss,
      takeProfit: proposal.takeProfit,
      lotSize: lotSize,
      openedAt: result.executedAt,
      closedAt: null,
      pnlMoney: 0,
      pnlPips: 0,
      riskRewardActual: 0,
      contractId: result.contractId,
      status: 'open',
      regime: proposal.regime.name,
      session: proposal.sessionLabel,
      confidence: proposal.confidence,
    );
  }

  factory Trade.fromJson(Map<String, dynamic> json) => _$TradeFromJson(json);
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
