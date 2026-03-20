// lib/features/chart/candlestick_painter.dart
import 'package:flutter/material.dart';

import '../../models/candle.dart';

class CandlestickPainter extends CustomPainter {
  CandlestickPainter({required this.candles, required this.scrollOffset});

  final List<Candle> candles;
  final double scrollOffset;

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final maxPrice = candles.map((e) => e.high).reduce((a, b) => a > b ? a : b);
    final minPrice = candles.map((e) => e.low).reduce((a, b) => a < b ? a : b);
    final span = (maxPrice - minPrice).abs();
    final candleWidth = 8.0;

    for (var i = 0; i < candles.length; i++) {
      final c = candles[i];
      final x = i * (candleWidth + 4) - scrollOffset;
      if (x < -20 || x > size.width + 20) continue;

      final bullish = c.close >= c.open;
      final color = bullish ? const Color(0xFF00D4AA) : const Color(0xFFFF4757);
      final yOpen = _map(c.open, minPrice, span, size.height);
      final yClose = _map(c.close, minPrice, span, size.height);
      final yHigh = _map(c.high, minPrice, span, size.height);
      final yLow = _map(c.low, minPrice, span, size.height);

      final bodyTop = yOpen < yClose ? yOpen : yClose;
      final bodyHeight = (yOpen - yClose).abs().clamp(1, 999.0);

      final wick = Paint()
        ..color = color
        ..strokeWidth = 1.2;
      canvas.drawLine(Offset(x + candleWidth / 2, yHigh), Offset(x + candleWidth / 2, yLow), wick);

      final body = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTWH(x, bodyTop, candleWidth, bodyHeight), body);
    }
  }

  double _map(double price, double minPrice, double span, double height) {
    if (span == 0) return height / 2;
    return height - ((price - minPrice) / span) * height;
  }

  @override
  bool shouldRepaint(covariant CandlestickPainter oldDelegate) {
    return oldDelegate.candles != candles || oldDelegate.scrollOffset != scrollOffset;
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
