// lib/shared/widgets/bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'liquid_glass_card.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({required this.index, super.key});

  final int index;

  @override
  Widget build(BuildContext context) {
    final items = <({IconData icon, String path})>[
      (icon: Icons.home_rounded, path: '/'),
      (icon: Icons.candlestick_chart, path: '/proposals'),
      (icon: Icons.account_balance_wallet_outlined, path: '/positions'),
      (icon: Icons.query_stats, path: '/performance'),
      (icon: Icons.settings, path: '/settings'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      child: LiquidGlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final selected = i == index;
            return IconButton(
              onPressed: () => context.go(items[i].path),
              icon: Icon(items[i].icon, color: selected ? const Color(0xFF00D4AA) : Colors.white70),
            );
          }),
        ),
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
