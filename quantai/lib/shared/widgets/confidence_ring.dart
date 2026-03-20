// lib/shared/widgets/confidence_ring.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';

class ConfidenceRing extends StatelessWidget {
  const ConfidenceRing({required this.confidence, super.key});

  final double confidence;

  @override
  Widget build(BuildContext context) {
    final value = confidence.clamp(0.0, 1.0);

    return SizedBox(
      width: 44,
      height: 44,
      child: CustomPaint(
        painter: _RingPainter(value),
        child: Center(
          child: Text(
            '${(value * 100).round()}%',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.value);

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 2;

    final bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = Colors.white.withValues(alpha: 0.15);

    final fg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..color = value >= 0.8 ? const Color(0xFF00D4AA) : const Color(0xFFFFA502);

    canvas.drawCircle(center, radius, bg);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * value,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.value != value;
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
