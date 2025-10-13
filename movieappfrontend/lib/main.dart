import 'package:flutter/material.dart';
import 'package:movieappfrontend/splash_screen.dart'; // Import the splash screen
import 'package:movieappfrontend/main_screen.dart'; // Import the MainScreen
import 'package:movieappfrontend/theme/app_theme.dart'; // Import the app theme

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

void main() {
  runApp(const CineMatchApp());
}

class CineMatchApp extends StatelessWidget {
  const CineMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, currentMode, __) {
        return MaterialApp(
          title: 'CineMatch',
          theme: AppTheme.lightTheme, // Default light theme
          darkTheme: AppTheme.darkTheme, // Dark theme
          themeMode: currentMode, // Use the current theme mode
          home: const SplashScreen(), // Start with the SplashScreen
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
