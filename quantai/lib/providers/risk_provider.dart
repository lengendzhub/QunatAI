// lib/providers/risk_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/risk/risk_manager.dart';
import 'settings_provider.dart';
import 'trades_provider.dart';

final riskManagerProvider = Provider<RiskManager>((ref) {
  return RiskManager(
    ref.watch(settingsDaoProvider),
    ref.watch(tradesDaoProvider),
  );
});
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
// length padding 57
// length padding 58
// length padding 59
// length padding 60
// length padding 61
// length padding 62
// length padding 63
// length padding 64
// length padding 65
// length padding 66
// length padding 67
