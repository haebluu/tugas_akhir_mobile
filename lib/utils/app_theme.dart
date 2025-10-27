import 'package:flutter/material.dart';
import 'colors.dart';

// Tema Aplikasi
ThemeData buildAppTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  return ThemeData(
    brightness: brightness,
    primaryColor: primaryColor,
    // FIX: Properti 'color' diganti menjadi cardColor di ThemeData (seperti pada perbaikan sebelumnya)
    cardColor: isDark ? const Color(0xFF1E1E1E) : Colors.white, 
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      brightness: brightness,
    ),
    scaffoldBackgroundColor: isDark ? darkBackgroundColor : lightBackgroundColor,
    appBarTheme: AppBarTheme(
      // FIX: Menggunakan backgroundColor yang tidak deprecated
      backgroundColor: isDark ? darkBackgroundColor : primaryColor, 
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
    // FIX UTAMA: Menghapus properti cardTheme sepenuhnya untuk menghindari error tipe data
    // Karena shape dan elevation yang Anda gunakan sudah merupakan default Material 3
    // dan warna sudah diatur melalui cardColor di atas.
    textTheme: TextTheme(
      titleLarge: TextStyle(color: isDark ? lightTextColor : darkTextColor),
      bodyMedium: TextStyle(color: isDark ? lightTextColor : darkTextColor),
      // FIX: Mengganti .withOpacity() yang deprecated
      bodySmall: TextStyle(
        color: isDark ? lightTextColor.withAlpha((255 * 0.7).round()) : darkTextColor.withAlpha((255 * 0.7).round()),
      ),
    ),
    useMaterial3: true,
  );
}
