
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppColors {
  static const Color primary = Colors.blue;

  static const Color backgroundDark = Color(0xFF0B1E2D);
  static const Color surface = Color(0xFF122A3C);
  static const Color textDart = Colors.white;
  static const Color textSecondary = Colors.white70;

  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color surfaceLight = Colors.white;
  static const Color textLight = Color(0xFF1C1C1E);
  static const Color textSecondaryLight = Color(0xFF6E6E73);
}

class AppTheme extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  AppTheme() {
    _loadTheme();
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.name);
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('themeMode');
    print("Saved theme: $savedTheme");
    if (savedTheme != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.name == savedTheme,
        orElse: () => ThemeMode.dark,
      );
      notifyListeners();
    }
  }

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onSurface: AppColors.textDart,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textDart),
      bodyMedium: TextStyle(color: AppColors.textDart),
      bodySmall: TextStyle(color: AppColors.textSecondary),
      headlineMedium: TextStyle(color: AppColors.textDart),
    ),
  );

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onSurface: AppColors.textLight,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textLight),
      bodyMedium: TextStyle(color: AppColors.textLight),
      bodySmall: TextStyle(color: AppColors.textSecondaryLight),
      headlineMedium: TextStyle(color: AppColors.textLight),
    ),
  );
}
