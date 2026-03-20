// lib/shared/widgets/pnl_hero_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/account_provider.dart';
import 'count_up_text.dart';
import 'liquid_glass_card.dart';

class PnlHeroCard extends ConsumerWidget {
  const PnlHeroCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider);

    return account.when(
      loading: () => const SizedBox(height: 180, child: Center(child: CircularProgressIndicator())),
      error: (e, _) => SizedBox(height: 180, child: Center(child: Text('Error: $e'))),
      data: (info) => LiquidGlassCard(
        borderRadius: 24,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Today\'s P&L',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
                    letterSpacing: 1.2,
                  ),
            ),
            const SizedBox(height: 8),
            CountUpText(
              value: info.dailyPnl,
              formatter: (v) => '${v >= 0 ? '+' : ''}\$${v.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.5,
              ),
            ),
            const SizedBox(height: 4),
            CountUpText(
              value: info.balance,
              formatter: (v) => 'Balance \$${v.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium!,
              overrideColor: Colors.white.withValues(alpha: 0.45),
            ),
          ],
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
