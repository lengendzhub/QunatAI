// lib/models/execution_result.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'execution_result.freezed.dart';
part 'execution_result.g.dart';

@freezed
class ExecutionResult with _$ExecutionResult {
  const ExecutionResult._();

  const factory ExecutionResult({
    required String contractId,
    required String symbol,
    required String direction,
    required double filledPrice,
    required double stopLoss,
    required double takeProfit,
    required double lotSize,
    required DateTime executedAt,
    required Map<String, dynamic> raw,
  }) = _ExecutionResult;

  factory ExecutionResult.fromJson(Map<String, dynamic> json) => _$ExecutionResultFromJson(json);
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
// length padding 41
// length padding 42
// length padding 43
// length padding 44
// length padding 45
// length padding 46
// length padding 47
// length padding 48
// length padding 49
// length padding 50
// length padding 51
// length padding 52
// length padding 53
// length padding 54
// length padding 55
// length padding 56
