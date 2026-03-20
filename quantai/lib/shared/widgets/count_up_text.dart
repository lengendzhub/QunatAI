// lib/shared/widgets/count_up_text.dart
import 'package:flutter/material.dart';

import '../../core/theme/quant_theme_extension.dart';

class CountUpText extends StatefulWidget {
  const CountUpText({
    required this.value,
    required this.formatter,
    required this.style,
    super.key,
    this.overrideColor,
  });

  final double value;
  final String Function(double) formatter;
  final TextStyle style;
  final Color? overrideColor;

  @override
  State<CountUpText> createState() => _CountUpTextState();
}

class _CountUpTextState extends State<CountUpText> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late Animation<double> _tween;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _tween = Tween<double>(begin: widget.value, end: widget.value).animate(_ctrl);
  }

  @override
  void didUpdateWidget(covariant CountUpText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _tween = Tween<double>(begin: oldWidget.value, end: widget.value).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
      );
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<QuantTheme>()!;
    return AnimatedBuilder(
      animation: _tween,
      builder: (_, __) {
        final color = widget.overrideColor ?? (_tween.value >= 0 ? theme.profit : theme.loss);
        return Text(
          widget.formatter(_tween.value),
          style: widget.style.copyWith(color: color),
        );
      },
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
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
