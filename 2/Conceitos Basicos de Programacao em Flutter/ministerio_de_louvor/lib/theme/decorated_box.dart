import 'package:flutter/material.dart';

class DecoratedBoxBorderColors
    extends ThemeExtension<DecoratedBoxBorderColors> {
  const DecoratedBoxBorderColors({
    required this.borderColor,
  });

  final Color borderColor;

  @override
  DecoratedBoxBorderColors copyWith({
    Color? borderColor,
  }) {
    return DecoratedBoxBorderColors(
      borderColor: borderColor ?? this.borderColor,
    );
  }

  @override
  DecoratedBoxBorderColors lerp(
      ThemeExtension<DecoratedBoxBorderColors>? other, double t) {
    if (other is! DecoratedBoxBorderColors) {
      return this;
    }
    return DecoratedBoxBorderColors(
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
    );
  }
}
