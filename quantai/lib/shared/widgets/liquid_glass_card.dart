// lib/shared/widgets/liquid_glass_card.dart
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/quant_theme_extension.dart';

class LiquidGlassCard extends StatelessWidget {
  const LiquidGlassCard({
    required this.child,
    super.key,
    this.borderRadius = 16,
    this.padding,
    this.tintColor,
  });

  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? tintColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<QuantTheme>()!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: theme.blurSigma,
          sigmaY: theme.blurSigma,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: tintColor != null ? tintColor!.withValues(alpha: 0.12) : theme.glassDark,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: theme.glassBorder, width: 0.5),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const <double>[0.0, 0.03, 1.0],
              colors: <Color>[
                theme.glassSpecular,
                theme.glassDark,
                theme.glassDark,
              ],
            ),
          ),
          padding: padding,
          child: child,
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
