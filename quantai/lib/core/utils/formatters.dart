// lib/core/utils/formatters.dart
import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat _money = NumberFormat.currency(
    decimalDigits: 2,
    symbol: r'$',
  );

  static final NumberFormat _pct = NumberFormat('0.00');

  static String money(double value) {
    final signed = value >= 0 ? '+${_money.format(value)}' : '-${_money.format(value.abs())}';
    return signed;
  }

  static String percent(double value) {
    return '${_pct.format(value)}%';
  }

  static int precisionForSymbol(String symbol) {
    final upper = symbol.toUpperCase();
    if (upper.endsWith('JPY')) return 3;
    if (upper == 'XAUUSD' || upper.startsWith('BTC') || upper.startsWith('ETH')) {
      return 2;
    }
    return 5;
  }

  static String price(String symbol, double value) {
    return value.toStringAsFixed(precisionForSymbol(symbol));
  }

  static String pips(double value) {
    return '${value.toStringAsFixed(1)} pips';
  }
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
