import 'package:flutter/material.dart';

class AppColors {
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color indigo = Color(0xFF150050);
  static const Color circleAvatarIconBackground = Color(0xFF2E263F);
  static const Color deepPurple = Color(0xFF3F0071);
  static const Color purple = Color(0xFF610094);
  static const Color violetFocus = Color(0xFFC77DFF);
  static const Color success = Color(0xFF32D583);
  static const Color warning = Color(0xFFFDB022);
  static const Color error = Color(0xFFF04438);
  static const Color primary = Color(0xFF7C16FF);
  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color textPrimary = Color(0xFFEADDFF);
  static const Color textSecondary = Color(0xFF9A9A9A);
  static const Color border = Color(0xFF2E2E2E);
  static const Color primaryGreen = Color(0xFF23BC56);
  static const Color progressIndicatorColor = Color(0xFFD3BBFF);
  static const Color progressIndicatorBackgroundColor = Color(0xFF39304A);
  static const Color inactiveGrey = Color(0xFFCCC3D8);
  static const Color cardColor = Color(0xFF1A1A1A);
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
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          color: AppColors.black,
          fontWeight: FontWeight.bold,
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
