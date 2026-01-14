import 'package:flutter/material.dart';
import 'package:course/app/resources/app_value.dart';
import 'package:course/app/resources/app_color.dart';

abstract class FontWeightsManager {
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

abstract class FontSizesManager {
  static const double tiny = AppValues.v8;
  static const double small = AppValues.v12;
  static const double medium = AppValues.v16;
  static const double large = AppValues.v20;
  static const double extraLarge = AppValues.v24;
  static const double massive = AppValues.v28;
  static const double huge = AppValues.v32;
}

abstract class AppStyle {
  // Light Text Theme
  static TextTheme get lightTextTheme => TextTheme(
    // Display Styles - For large headings
    displayLarge: TextStyle(
      fontSize: FontSizesManager.huge,
      fontWeight: FontWeightsManager.bold,
      color: AppColor.titleText,
    ),
    displayMedium: TextStyle(
      fontSize: FontSizesManager.massive,
      fontWeight: FontWeightsManager.bold,
      color: AppColor.titleText,
    ),
    displaySmall: TextStyle(
      fontSize: FontSizesManager.extraLarge,
      fontWeight: FontWeightsManager.bold,
      color: AppColor.titleText,
    ),

    // Headline Styles - For section headings
    headlineLarge: TextStyle(
      fontSize: FontSizesManager.large,
      fontWeight: FontWeightsManager.semiBold,
      color: AppColor.titleText,
    ),
    headlineMedium: TextStyle(
      fontSize: FontSizesManager.large,
      fontWeight: FontWeightsManager.semiBold,
      color: AppColor.titleText,
    ),
    headlineSmall: TextStyle(
      fontSize: FontSizesManager.medium,
      fontWeight: FontWeightsManager.semiBold,
      color: AppColor.titleText,
    ),

    // Title Styles - For card titles, list items
    titleLarge: TextStyle(
      fontSize: FontSizesManager.medium,
      fontWeight: FontWeightsManager.semiBold,
      color: AppColor.titleText,
    ),
    titleMedium: TextStyle(
      fontSize: FontSizesManager.small,
      fontWeight: FontWeightsManager.medium,
      color: AppColor.titleText,
    ),
    titleSmall: TextStyle(
      fontSize: FontSizesManager.small,
      fontWeight: FontWeightsManager.medium,
      color: AppColor.text,
    ),

    // Body Styles - For main content text
    bodyLarge: TextStyle(
      fontSize: FontSizesManager.medium,
      fontWeight: FontWeightsManager.regular,
      color: AppColor.text,
    ),
    bodyMedium: TextStyle(
      fontSize: FontSizesManager.small,
      fontWeight: FontWeightsManager.regular,
      color: AppColor.text,
    ),
    bodySmall: TextStyle(
      fontSize: FontSizesManager.small,
      fontWeight: FontWeightsManager.regular,
      color: AppColor.statisticLabel,
    ),

    // Label Styles - For buttons and UI elements
    labelLarge: TextStyle(
      fontSize: FontSizesManager.small,
      fontWeight: FontWeightsManager.semiBold,
      color: Colors.white,
      letterSpacing: AppValues.v0_5,
    ),
    labelMedium: TextStyle(
      fontSize: FontSizesManager.small,
      fontWeight: FontWeightsManager.medium,
      color: AppColor.text,
      letterSpacing: AppValues.v0_5,
    ),
    labelSmall: TextStyle(
      fontSize: FontSizesManager.tiny,
      fontWeight: FontWeightsManager.medium,
      color: AppColor.statisticLabel,
      letterSpacing: AppValues.v0_5,
    ),
  );

  // Dark Text Theme
  static TextTheme get darkTextTheme => TextTheme(
    displayLarge: TextStyle(
      fontSize: FontSizesManager.huge,
      fontWeight: FontWeightsManager.bold,
      color: Colors.white,
    ),
    displayMedium: TextStyle(
      fontSize: FontSizesManager.massive,
      fontWeight: FontWeightsManager.bold,
      color: Colors.white,
    ),
    displaySmall: TextStyle(
      fontSize: FontSizesManager.extraLarge,
      fontWeight: FontWeightsManager.bold,
      color: Colors.white,
    ),
    headlineLarge: TextStyle(
      fontSize: FontSizesManager.large,
      fontWeight: FontWeightsManager.semiBold,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontSize: FontSizesManager.large,
      fontWeight: FontWeightsManager.semiBold,
      color: Colors.white,
    ),
    headlineSmall: TextStyle(
      fontSize: FontSizesManager.medium,
      fontWeight: FontWeightsManager.semiBold,
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      fontSize: FontSizesManager.medium,
      fontWeight: FontWeightsManager.semiBold,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontSize: FontSizesManager.small,
      fontWeight: FontWeightsManager.medium,
      color: Colors.white70,
    ),
    titleSmall: TextStyle(
      fontSize: FontSizesManager.small,
      fontWeight: FontWeightsManager.medium,
      color: Colors.white60,
    ),
    bodyLarge: TextStyle(
      fontSize: FontSizesManager.medium,
      fontWeight: FontWeightsManager.regular,
      color: Colors.white70,
    ),
    bodyMedium: TextStyle(
      fontSize: FontSizesManager.small,
      fontWeight: FontWeightsManager.regular,
      color: Colors.white70,
    ),
    bodySmall: TextStyle(
      fontSize: FontSizesManager.small,
      fontWeight: FontWeightsManager.regular,
      color: Colors.white60,
    ),
    labelLarge: TextStyle(
      fontSize: FontSizesManager.small,
      fontWeight: FontWeightsManager.semiBold,
      color: Colors.white,
      letterSpacing: AppValues.v0_5,
    ),
    labelMedium: TextStyle(
      fontSize: FontSizesManager.small,
      fontWeight: FontWeightsManager.medium,
      color: Colors.white70,
      letterSpacing: AppValues.v0_5,
    ),
    labelSmall: TextStyle(
      fontSize: FontSizesManager.tiny,
      fontWeight: FontWeightsManager.medium,
      color: Colors.white60,
      letterSpacing: AppValues.v0_5,
    ),
  );
}
