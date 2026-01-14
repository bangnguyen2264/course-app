import 'package:course/app/resources/app_value.dart';
import 'package:flutter/material.dart';

// Base spacing values
abstract class _BaseSpacing {
  static const double small = AppValues.v8;
  static const double medium = AppValues.v12;
  static const double large = AppValues.v16;
  static const double extraLarge = AppValues.v20;
  static const double massive = AppValues.v24;
  static const double huge = AppValues.v32;
  static const double extreme = AppValues.v40;
}

abstract class AppPadding extends _BaseSpacing {}

abstract class AppMargin extends _BaseSpacing {}

abstract class AppBorderRadius extends _BaseSpacing {}

abstract class AppBoxShadow {
  // Box Shadow values
  static const List<BoxShadow> lightShadow = [
    BoxShadow(color: Color(0x1A000000), blurRadius: AppValues.v8, offset: Offset(0, AppValues.v4)),
  ];

  static const List<BoxShadow> darkShadow = [
    BoxShadow(color: Color(0x33000000), blurRadius: AppValues.v8, offset: Offset(0, AppValues.v4)),
  ];
}
