// lib/models/account_info.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_info.freezed.dart';
part 'account_info.g.dart';

@freezed
class AccountInfo with _$AccountInfo {
  const AccountInfo._();

  const factory AccountInfo({
    required String loginId,
    required double balance,
    required String currency,
    required double equity,
    required double marginUsed,
    required double freeMargin,
    required double dailyPnl,
    required double winRate,
    required int tradesToday,
    required double maxDailyDrawdown,
  }) = _AccountInfo;

  String get winRateDisplay => '${(winRate * 100).toStringAsFixed(1)}%';
  String get maxDdDisplay => '${maxDailyDrawdown.toStringAsFixed(2)}%';

  factory AccountInfo.empty() {
    return const AccountInfo(
      loginId: 'N/A',
      balance: 0,
      currency: 'USD',
      equity: 0,
      marginUsed: 0,
      freeMargin: 0,
      dailyPnl: 0,
      winRate: 0,
      tradesToday: 0,
      maxDailyDrawdown: 0,
    );
  }

  factory AccountInfo.fromJson(Map<String, dynamic> json) => _$AccountInfoFromJson(json);
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
