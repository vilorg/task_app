import 'package:flutter/material.dart';
import 'constants/colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppLightColors.colorBlue,
    scaffoldBackgroundColor: AppLightColors.backPrimary,
    cardColor: AppLightColors.backElevated,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: AppLightColors.backSecondary,
      hintStyle: const TextStyle(
        color: AppLightColors.labelTertiary,
        fontSize: 16,
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: AppLightColors.labelPrimary,
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: AppLightColors.labelPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: AppLightColors.labelPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(color: AppLightColors.labelPrimary, fontSize: 16),
      bodySmall: TextStyle(color: AppLightColors.labelPrimary, fontSize: 14),
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all<Color>(AppLightColors.backSecondary),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppLightColors.backPrimary,
      iconTheme: IconThemeData(color: AppLightColors.labelPrimary),
      titleTextStyle: TextStyle(
          color: AppLightColors.labelPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppLightColors.colorBlue,
      foregroundColor: AppLightColors.colorWhite,
      shape: CircleBorder(),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppLightColors.colorBlue,
    ),
    dividerColor: AppLightColors.supportSeparator,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppLightColors.colorBlue,
      brightness: Brightness.dark,
      primary: AppLightColors.colorBlue,
      tertiary: AppLightColors.backSecondary,
      surface: AppLightColors.backElevated,
      secondary: AppLightColors.labelTertiary,
      error: AppLightColors.colorRed,
      scrim: AppLightColors.colorGreen,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.all<Color>(AppLightColors.colorBlue),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: AppDarkColors.colorBlue,
    scaffoldBackgroundColor: AppDarkColors.backPrimary,
    cardColor: AppDarkColors.backElevated,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: AppDarkColors.backSecondary,
      hintStyle: const TextStyle(
        color: AppDarkColors.labelTertiary,
        fontSize: 16,
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: AppDarkColors.labelPrimary,
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: AppDarkColors.labelPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: AppDarkColors.labelPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(color: AppDarkColors.labelPrimary, fontSize: 16),
      bodySmall: TextStyle(color: AppDarkColors.labelPrimary, fontSize: 14),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppDarkColors.backPrimary,
      iconTheme: IconThemeData(color: AppDarkColors.labelPrimary),
      titleTextStyle: TextStyle(
          color: AppDarkColors.labelPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppDarkColors.colorBlue,
      foregroundColor: AppDarkColors.colorWhite,
      shape: CircleBorder(),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppDarkColors.colorBlue,
    ),
    dividerColor: AppDarkColors.supportSeparator,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppDarkColors.colorBlue,
      brightness: Brightness.light,
      primary: AppDarkColors.colorBlue,
      surface: AppDarkColors.backElevated,
      tertiary: AppDarkColors.backSecondary,
      secondary: AppDarkColors.labelTertiary,
      error: AppDarkColors.colorRed,
      scrim: AppDarkColors.colorGreen,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.all<Color>(AppDarkColors.colorBlue),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all<Color>(AppDarkColors.backSecondary),
    ),
  );
}
