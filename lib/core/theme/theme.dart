import 'package:flutter/material.dart';

class AppColors {
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color indigo = Color(0xFF150050);
  static const Color deepPurple = Color(0xFF3F0071);
  static const Color purple = Color(0xFF610094);
  static const Color violetFocus = Color(0xFFC77DFF);
  static const Color success = Color(0xFF32D583);
  static const Color warning = Color(0xFFFDB022);
  static const Color error = Color(0xFFF04438);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.purple,
      scaffoldBackgroundColor: AppColors.white,
      fontFamily: 'Manrope',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          color: AppColors.black,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.purple,
        secondary: AppColors.violetFocus,
        tertiary: AppColors.success,
        error: AppColors.error,
        surface: AppColors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.purple,
      scaffoldBackgroundColor: AppColors.black,
      fontFamily: 'Manrope',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          color: Colors.white,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.purple,
        secondary: AppColors.violetFocus,
        tertiary: AppColors.success,
        error: AppColors.error,
        surface: AppColors.indigo,
      ),
    );
  }
}
