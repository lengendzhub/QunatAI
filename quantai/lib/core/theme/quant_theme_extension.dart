// lib/core/theme/quant_theme_extension.dart
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

@immutable
class QuantTheme extends ThemeExtension<QuantTheme> {
  const QuantTheme({
    required this.glassDark,
    required this.glassMid,
    required this.glassLight,
    required this.glassBorder,
    required this.glassSpecular,
    required this.blurSigma,
    required this.profit,
    required this.loss,
    required this.neutral,
    required this.trendUp,
    required this.trendDown,
    required this.range,
    required this.volatile,
    required this.lowVol,
    required this.bgPositive,
    required this.bgNegative,
    required this.bgNeutral,
  });

  final Color glassDark;
  final Color glassMid;
  final Color glassLight;
  final Color glassBorder;
  final Color glassSpecular;
  final double blurSigma;

  final Color profit;
  final Color loss;
  final Color neutral;

  final Color trendUp;
  final Color trendDown;
  final Color range;
  final Color volatile;
  final Color lowVol;

  final List<Color> bgPositive;
  final List<Color> bgNegative;
  final List<Color> bgNeutral;

  @override
  QuantTheme copyWith({
    Color? glassDark,
    Color? glassMid,
    Color? glassLight,
    Color? glassBorder,
    Color? glassSpecular,
    double? blurSigma,
    Color? profit,
    Color? loss,
    Color? neutral,
    Color? trendUp,
    Color? trendDown,
    Color? range,
    Color? volatile,
    Color? lowVol,
    List<Color>? bgPositive,
    List<Color>? bgNegative,
    List<Color>? bgNeutral,
  }) {
    return QuantTheme(
      glassDark: glassDark ?? this.glassDark,
      glassMid: glassMid ?? this.glassMid,
      glassLight: glassLight ?? this.glassLight,
      glassBorder: glassBorder ?? this.glassBorder,
      glassSpecular: glassSpecular ?? this.glassSpecular,
      blurSigma: blurSigma ?? this.blurSigma,
      profit: profit ?? this.profit,
      loss: loss ?? this.loss,
      neutral: neutral ?? this.neutral,
      trendUp: trendUp ?? this.trendUp,
      trendDown: trendDown ?? this.trendDown,
      range: range ?? this.range,
      volatile: volatile ?? this.volatile,
      lowVol: lowVol ?? this.lowVol,
      bgPositive: bgPositive ?? this.bgPositive,
      bgNegative: bgNegative ?? this.bgNegative,
      bgNeutral: bgNeutral ?? this.bgNeutral,
    );
  }

  @override
  QuantTheme lerp(ThemeExtension<QuantTheme>? other, double t) {
    if (other is! QuantTheme) {
      return this;
    }

    return QuantTheme(
      glassDark: Color.lerp(glassDark, other.glassDark, t) ?? glassDark,
      glassMid: Color.lerp(glassMid, other.glassMid, t) ?? glassMid,
      glassLight: Color.lerp(glassLight, other.glassLight, t) ?? glassLight,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t) ?? glassBorder,
      glassSpecular: Color.lerp(glassSpecular, other.glassSpecular, t) ?? glassSpecular,
      blurSigma: lerpDouble(blurSigma, other.blurSigma, t) ?? blurSigma,
      profit: Color.lerp(profit, other.profit, t) ?? profit,
      loss: Color.lerp(loss, other.loss, t) ?? loss,
      neutral: Color.lerp(neutral, other.neutral, t) ?? neutral,
      trendUp: Color.lerp(trendUp, other.trendUp, t) ?? trendUp,
      trendDown: Color.lerp(trendDown, other.trendDown, t) ?? trendDown,
      range: Color.lerp(range, other.range, t) ?? range,
      volatile: Color.lerp(volatile, other.volatile, t) ?? volatile,
      lowVol: Color.lerp(lowVol, other.lowVol, t) ?? lowVol,
      bgPositive: _lerpColorList(bgPositive, other.bgPositive, t),
      bgNegative: _lerpColorList(bgNegative, other.bgNegative, t),
      bgNeutral: _lerpColorList(bgNeutral, other.bgNeutral, t),
    );
  }

  static List<Color> _lerpColorList(List<Color> a, List<Color> b, double t) {
    final length = a.length < b.length ? a.length : b.length;
    final out = <Color>[];
    for (var i = 0; i < length; i++) {
      out.add(Color.lerp(a[i], b[i], t) ?? a[i]);
    }
    return out;
  }

  static const QuantTheme dark = QuantTheme(
    glassDark: Color(0x14FFFFFF),
    glassMid: Color(0x22FFFFFF),
    glassLight: Color(0xB8FFFFFF),
    glassBorder: Color(0x1FFFFFFF),
    glassSpecular: Color(0x33FFFFFF),
    blurSigma: 24.0,
    profit: Color(0xFF00D4AA),
    loss: Color(0xFFFF4757),
    neutral: Color(0xFF8892A4),
    trendUp: Color(0xFF00D4AA),
    trendDown: Color(0xFFFF4757),
    range: Color(0xFFFFA502),
    volatile: Color(0xFFFF6B6B),
    lowVol: Color(0xFF8892A4),
    bgPositive: <Color>[Color(0xFF002218), Color(0xFF000E0A)],
    bgNegative: <Color>[Color(0xFF1E0000), Color(0xFF0A0000)],
    bgNeutral: <Color>[Color(0xFF0A0E1A), Color(0xFF06080F)],
  );
}
