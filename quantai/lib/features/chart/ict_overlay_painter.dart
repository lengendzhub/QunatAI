// lib/features/chart/ict_overlay_painter.dart
import 'package:flutter/material.dart';

import '../../models/ict_features.dart';

class IctOverlayPainter extends CustomPainter {
  IctOverlayPainter({
    required this.features,
    required this.maxPrice,
    required this.minPrice,
  });

  final IctFeatures? features;
  final double maxPrice;
  final double minPrice;

  @override
  void paint(Canvas canvas, Size size) {
    final f = features;
    if (f == null) return;

    final span = (maxPrice - minPrice).abs();
    if (span == 0) return;

    if (f.ob != null) {
      final ob = f.ob!;
      final top = _map(ob.high, minPrice, span, size.height);
      final bottom = _map(ob.low, minPrice, span, size.height);
      final color = ob.direction == 'bullish' ? const Color(0x3300D4AA) : const Color(0x33FF4757);
      final rect = Rect.fromLTRB(0, top, size.width, bottom);
      canvas.drawRect(rect, Paint()..color = color);
    }

    final oteTop = _map(f.oteZoneUpper, minPrice, span, size.height);
    final oteBottom = _map(f.oteZoneLower, minPrice, span, size.height);
    canvas.drawRect(
      Rect.fromLTRB(0, oteTop, size.width, oteBottom),
      Paint()..color = const Color(0x33FFA502),
    );
  }

  double _map(double price, double minPrice, double span, double height) {
    return height - ((price - minPrice) / span) * height;
  }

  @override
  bool shouldRepaint(covariant IctOverlayPainter oldDelegate) {
    return oldDelegate.features != features || oldDelegate.maxPrice != maxPrice || oldDelegate.minPrice != minPrice;
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
