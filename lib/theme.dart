import 'package:flutter/material.dart';

extension ThemeDataExt on ThemeData {
  Color get cardColorWithElevation {
    return ElevationOverlay.applySurfaceTint(cardColor, colorScheme.surfaceTint, 1);
  }
}

class FontWeights {
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight normal = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight demiBold = FontWeight.w600;
  static const FontWeight semiBold = FontWeight.w700;
  static const FontWeight bold = FontWeight.w800;
  static const FontWeight heavy = FontWeight.w900;
}