import 'package:flutter/material.dart';
import 'colors.dart';

// Tema Aplikasi
ThemeData buildAppTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  return ThemeData(
    brightness: brightness,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      brightness: brightness,
    ),
    scaffoldBackgroundColor: isDark ? darkBackgroundColor : lightBackgroundColor,
    appBarTheme: AppBarTheme(
      color: isDark ? darkBackgroundColor : primaryColor,
      elevation: 0,
      iconTheme: IconThemeData(color: isDark ? lightTextColor : Colors.white),
      titleTextStyle: TextStyle(
        color: isDark ? lightTextColor : Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentColor,
      foregroundColor: darkTextColor,
    ),
    cardTheme: CardTheme(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: isDark ? lightTextColor : darkTextColor),
      bodyMedium: TextStyle(color: isDark ? lightTextColor : darkTextColor),
      bodySmall: TextStyle(color: isDark ? lightTextColor.withOpacity(0.7) : darkTextColor.withOpacity(0.7)),
    ),
    useMaterial3: true,
  );
}
