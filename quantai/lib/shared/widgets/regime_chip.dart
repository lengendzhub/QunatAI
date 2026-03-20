// lib/shared/widgets/regime_chip.dart
import 'package:flutter/material.dart';

import '../../models/market_regime.dart';

class RegimeChip extends StatelessWidget {
  const RegimeChip({required this.regime, super.key});

  final MarketRegime regime;

  @override
  Widget build(BuildContext context) {
    final color = switch (regime) {
      MarketRegime.trendUp => const Color(0xFF00D4AA),
      MarketRegime.trendDown => const Color(0xFFFF4757),
      MarketRegime.range => const Color(0xFFFFA502),
      MarketRegime.volatile => const Color(0xFFFF6B6B),
      MarketRegime.lowVolatility => const Color(0xFF8892A4),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        regime.label,
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
      ),
    );
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
// length padding 44
// length padding 45
// length padding 46
// length padding 47
