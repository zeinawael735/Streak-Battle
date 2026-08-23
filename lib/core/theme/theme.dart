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
  static const Color cardColor = Color(0xFF0E0D12);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Color(0xFF9368D1)),
      primaryColor: AppColors.purple,
      cardColor: Color(0xFFF8F6FB),
      scaffoldBackgroundColor: AppColors.white,
      fontFamily: 'Manrope',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
        headlineSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodySmall: TextStyle(
          fontSize: 16,
          color: Color(0xFF9368D1),
        ),
        bodyMedium: TextStyle(
          fontSize: 20,
          color: Color(0xFF9368D1),
        ),
        bodyLarge: TextStyle(
          fontSize: 28,
          color: Color(0xFF9368D1),
        ),
        labelLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black
        ),
      ),
      colorScheme:  ColorScheme.light(
        ///home
        scrim: Color(0xFFEFE2F5),//next up icon background an active battles
        onTertiary: Color(0xFFEFE2F5),//active battles back ground icon an back of progress
        tertiaryContainer: Color(0xFFEFE2F5),//active battles back ground icon
        /// join battle
        onTertiaryContainer:  Color(0xFFEFE4F5),
        /// battle details screen
        tertiaryFixed: Color(0xFFD8CBEA),
        ///
        primary: AppColors.purple,
        surfaceBright: Colors.black12,
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
      iconTheme: IconThemeData(color: Color(0xFFD2BBFF)),
      primaryColor: AppColors.purple,
      cardColor: AppColors.cardColor,
      scaffoldBackgroundColor: AppColors.black,
      fontFamily: 'Manrope',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodySmall: TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 20,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 28,
          color:AppColors.textPrimary,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      colorScheme: ColorScheme.dark(
        ///home
        scrim: Color(0xFF353534),//next up icon background
        onTertiary: Color(0xFF131313),//active battles back of progress
        tertiaryContainer: Color(0xFF15004B),//active battles back ground icon
        ///join battle
        onTertiaryContainer:  Color(0xFF1A1525),
        ///battle details screen
        tertiaryFixed: Color(0xFF150050),
        ///
        primary: AppColors.purple,
        secondary: AppColors.violetFocus,
        surfaceBright: Colors.white,
        tertiary: AppColors.success,
        error: AppColors.error,
        surface: AppColors.indigo,
      ),
    );
  }
}