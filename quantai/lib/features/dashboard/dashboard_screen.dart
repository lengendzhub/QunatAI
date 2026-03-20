// lib/features/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';

import '../../shared/widgets/ambient_background.dart';
import '../../shared/widgets/bottom_nav.dart';
import '../../shared/widgets/live_dot.dart';
import '../../shared/widgets/pnl_hero_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AmbientBackground(
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        children: const <Widget>[
                          LiveDot(),
                          SizedBox(width: 8),
                          Text('Live', style: TextStyle(fontWeight: FontWeight.w600)),
                          Spacer(),
                          Text('QuantAI Dashboard'),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: PnlHeroCard(),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: BottomNav(index: 0),
              ),
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
