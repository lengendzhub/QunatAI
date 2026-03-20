// lib/features/proposals/proposal_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/proposal.dart';
import '../../providers/execution_provider.dart';
import '../../providers/proposals_provider.dart';
import '../../shared/widgets/confidence_ring.dart';
import '../../shared/widgets/direction_badge.dart';
import '../../shared/widgets/liquid_glass_card.dart';
import '../../shared/widgets/price_ladder.dart';
import '../../shared/widgets/regime_chip.dart';
import '../../shared/widgets/spring_button.dart';

class ProposalCard extends ConsumerStatefulWidget {
  const ProposalCard({required this.proposal, required this.index, super.key});

  final TradeProposal proposal;
  final int index;

  @override
  ConsumerState<ProposalCard> createState() => _ProposalCardState();
}

class _ProposalCardState extends ConsumerState<ProposalCard> with SingleTickerProviderStateMixin {
  late final AnimationController _mountCtrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _mountCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _slide = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(
      CurvedAnimation(parent: _mountCtrl, curve: Curves.easeOutCubic),
    );
    _fade = CurvedAnimation(parent: _mountCtrl, curve: Curves.easeOutCubic);

    Future<void>.delayed(Duration(milliseconds: widget.index * 60), () {
      if (mounted) _mountCtrl.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.proposal;

    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: LiquidGlassCard(
          borderRadius: 20,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  DirectionBadge(direction: p.direction),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(p.symbol, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      Text(p.timeframe, style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 12)),
                    ],
                  ),
                  const Spacer(),
                  ConfidenceRing(confidence: p.confidence),
                  const SizedBox(width: 8),
                  RegimeChip(regime: p.regime),
                ],
              ),
              const SizedBox(height: 12),
              PriceLadder(
                entry: p.entry,
                stopLoss: p.stopLoss,
                takeProfit: p.takeProfit,
                direction: p.direction,
                symbol: p.symbol,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Row(
                  children: <Widget>[
                    Text('ICT Analysis', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13)),
                    const Spacer(),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(Icons.keyboard_arrow_down, color: Colors.white.withValues(alpha: 0.4), size: 16),
                    ),
                  ],
                ),
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(p.explanation, style: TextStyle(color: Colors.white.withValues(alpha: 0.65))),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SpringButton(
                      hapticHeavy: true,
                      onTap: () => ref.read(executionProvider.notifier).approve(p),
                      child: _actionButton('Approve', const Color(0xFF00D4AA), true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SpringButton(
                      hapticHeavy: false,
                      onTap: () => ref.read(proposalsProvider.notifier).reject(p.id),
                      child: _actionButton('Reject', const Color(0xFFFF4757), false),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton(String label, Color color, bool strong) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: strong ? 0.15 : 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Center(child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600))),
    );
  }

  @override
  void dispose() {
    _mountCtrl.dispose();
    super.dispose();
  }
}
