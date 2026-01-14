import 'dart:math';

import 'package:flutter/material.dart';

class ColorUtility {
  static MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  static int tintValue(int value, double factor) =>
      max(0, min(255, (value + ((255 - value) * factor)).round()));

  static Color tintColor(Color color, double factor) => Color.fromARGB(
    color.alpha,
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
  );

  static int shadeValue(int value, double factor) =>
      max(0, min(255, (value - (value * factor)).round()));

  static Color shadeColor(Color color, double factor) => Color.fromARGB(
    color.alpha,
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
  );
}
