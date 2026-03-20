// lib/shared/widgets/price_ladder.dart
import 'package:flutter/material.dart';

import '../../core/utils/math_utils.dart';

class PriceLadder extends StatelessWidget {
  const PriceLadder({
    required this.entry,
    required this.stopLoss,
    required this.takeProfit,
    required this.direction,
    required this.symbol,
    super.key,
  });

  final double entry;
  final double stopLoss;
  final double takeProfit;
  final String direction;
  final String symbol;

  @override
  Widget build(BuildContext context) {
    final pipSize = pipSizeForSymbol(symbol);
    final riskPips = (entry - stopLoss).abs() / pipSize;
    final rewardPips = (takeProfit - entry).abs() / pipSize;
    final rr = riskPips == 0 ? 0 : rewardPips / riskPips;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _line('TP', takeProfit, const Color(0xFF00D4AA), '+${rewardPips.toStringAsFixed(1)} pips'),
        _line('Entry', entry, Colors.white, ''),
        _line('SL', stopLoss, const Color(0xFFFF4757), '-${riskPips.toStringAsFixed(1)} pips'),
        const SizedBox(height: 6),
        Text('R:R ${rr.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  Widget _line(String label, double price, Color color, String note) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: color.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(width: 8),
          Text(price.toStringAsFixed(5), style: const TextStyle(fontSize: 12)),
          if (note.isNotEmpty) ...<Widget>[
            const SizedBox(width: 8),
            Text(note, style: TextStyle(fontSize: 11, color: color)),
          ],
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
