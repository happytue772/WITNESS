import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      scaffoldBackgroundColor: AppColors.background,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.burgundy,
      ),

      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.softYellow,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.burgundy,
          foregroundColor: AppColors.softYellow,
        ),
      ),
    );
  }
}