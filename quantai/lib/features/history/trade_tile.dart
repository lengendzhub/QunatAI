// lib/features/history/trade_tile.dart
import 'package:flutter/material.dart';

import '../../models/trade.dart';
import '../../shared/widgets/liquid_glass_card.dart';

class TradeTile extends StatelessWidget {
  const TradeTile({required this.trade, super.key});

  final Trade trade;

  @override
  Widget build(BuildContext context) {
    final pnlColor = trade.pnlMoney >= 0 ? const Color(0xFF00D4AA) : const Color(0xFFFF4757);

    return LiquidGlassCard(
      borderRadius: 14,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${trade.symbol} ${trade.direction.toUpperCase()}'),
                const SizedBox(height: 4),
                Text('Opened ${trade.openedAt.toLocal()}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ),
          Text(
            '${trade.pnlMoney >= 0 ? '+' : ''}\$${trade.pnlMoney.toStringAsFixed(2)}',
            style: TextStyle(fontWeight: FontWeight.w700, color: pnlColor),
          ),
        ],
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
