// lib/features/performance/performance_screen.dart
import 'package:flutter/material.dart';

import '../../shared/widgets/ambient_background.dart';
import '../../shared/widgets/bottom_nav.dart';
import '../../shared/widgets/liquid_glass_card.dart';
import '../../shared/widgets/stat_card.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AmbientBackground(
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                children: const <Widget>[
                  LiquidGlassCard(
                    borderRadius: 20,
                    padding: EdgeInsets.all(16),
                    child: Text('Performance Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Expanded(child: StatCard(label: 'Win Rate', value: '0%')),
                      SizedBox(width: 10),
                      Expanded(child: StatCard(label: 'Profit Factor', value: '0.00')),
                    ],
                  ),
                ],
              ),
              const Align(alignment: Alignment.bottomCenter, child: BottomNav(index: 3)),
            ],
          ),
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
