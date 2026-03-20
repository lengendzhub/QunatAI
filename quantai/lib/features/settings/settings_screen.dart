// lib/features/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/risk/kill_switch.dart';
import '../../providers/settings_provider.dart';
import '../../shared/widgets/ambient_background.dart';
import '../../shared/widgets/bottom_nav.dart';
import '../../shared/widgets/liquid_glass_card.dart';
import '../../shared/widgets/spring_button.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  double risk = 1.0;
  double dd = 3.0;
  int maxOpen = 2;

  @override
  Widget build(BuildContext context) {
    final dao = ref.watch(settingsDaoProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AmbientBackground(
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                children: <Widget>[
                  LiquidGlassCard(
                    borderRadius: 20,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text('Risk % per trade'),
                        Slider(
                          min: 0.5,
                          max: 3.0,
                          divisions: 25,
                          value: risk,
                          onChanged: (v) => setState(() => risk = v),
                          onChangeEnd: (v) => dao.setString('risk_pct_per_trade', (v / 100).toString()),
                        ),
                        const Text('Max Daily DD %'),
                        Slider(
                          min: 1,
                          max: 5,
                          divisions: 40,
                          value: dd,
                          onChanged: (v) => setState(() => dd = v),
                          onChangeEnd: (v) => dao.setString('max_daily_dd_pct', v.toString()),
                        ),
                        Row(
                          children: <Widget>[
                            const Text('Max Open Trades'),
                            const Spacer(),
                            IconButton(
                              onPressed: () => setState(() => maxOpen = (maxOpen - 1).clamp(1, 5)),
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text('$maxOpen'),
                            IconButton(
                              onPressed: () => setState(() => maxOpen = (maxOpen + 1).clamp(1, 5)),
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                        SpringButton(
                          hapticHeavy: true,
                          onTap: () async => KillSwitch.activate('Manual emergency stop'),
                          child: Container(
                            height: 46,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF4757).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFFF4757).withValues(alpha: 0.35)),
                            ),
                            child: const Text('Emergency Stop', style: TextStyle(color: Color(0xFFFF4757))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Align(alignment: Alignment.bottomCenter, child: BottomNav(index: 4)),
            ],
          ),
        ),
      ),
    );
  }
}
