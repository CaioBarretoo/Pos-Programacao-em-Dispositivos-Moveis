import 'package:flutter/material.dart';

class SizedBoxBackgroundColors
    extends ThemeExtension<SizedBoxBackgroundColors> {
  const SizedBoxBackgroundColors({
    required this.backgroundColor,
  });

  final Color backgroundColor;

  @override
  SizedBoxBackgroundColors copyWith({
    Color? backgroundColor,
  }) {
    return SizedBoxBackgroundColors(
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  @override
  SizedBoxBackgroundColors lerp(
      ThemeExtension<SizedBoxBackgroundColors>? other, double t) {
    if (other is! SizedBoxBackgroundColors) {
      return this;
    }
    return SizedBoxBackgroundColors(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }
}
