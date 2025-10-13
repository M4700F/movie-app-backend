import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color background = Color(0xFF121212);
  static const Color foreground = Color(0xFFFFFFFF);
  static const Color card = Color(0xFF1E1E1E);
  static const Color primary = Color(0xFF673AB7);
  static const Color secondary = Color(0xFFFF9800);
  static const Color muted = Color(0xFF2A2A2A);
  static const Color mutedForeground = Color(0xFFB0B0B0);
  static const Color destructive = Color(0xFFD4183D);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightForeground = Color(0xFF121212);
  static const Color lightCard = Color(0xFFF5F5F5);
  static const Color lightMuted = Color(0xFFE0E0E0);
  static const Color lightMutedForeground = Color(0xFF757575);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    primaryColor: primary,
    colorScheme: const ColorScheme.dark(
      primary: primary,
      secondary: secondary,
      background: background,
      surface: card,
      error: destructive,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      centerTitle: false,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: card,
      selectedItemColor: primary,
      unselectedItemColor: mutedForeground,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    cardTheme: CardThemeData(
      color: card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: foreground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
      ),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: foreground,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: foreground,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: foreground,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: foreground,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: foreground,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: foreground,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: mutedForeground,
      ),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackground,
    primaryColor: primary,
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: secondary,
      background: lightBackground,
      surface: lightCard,
      error: destructive,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackground,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(color: lightForeground, fontSize: 20, fontWeight: FontWeight.w500),
      iconTheme: IconThemeData(color: lightForeground),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: lightCard,
      selectedItemColor: primary,
      unselectedItemColor: lightMutedForeground,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    cardTheme: CardThemeData(
      color: lightCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightMuted,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      hintStyle: TextStyle(color: lightMutedForeground),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: lightForeground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
      ),
    ),

    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        color: lightForeground,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: lightForeground,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: lightForeground,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: lightForeground,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: lightForeground,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: lightForeground,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: lightMutedForeground,
      ),
    ),
  );
}
