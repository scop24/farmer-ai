import 'package:flutter/material.dart';

/// KisanSathi theme: Material 3, light, one calm green primary color.
/// Body text is kept at 16sp or larger for readability in the field.
ThemeData buildKisanSathiTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF2F7D32),
    brightness: Brightness.light,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 18),
      bodyMedium: TextStyle(fontSize: 16),
      bodySmall: TextStyle(fontSize: 14),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(minimumSize: const Size(64, 52)),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(minimumSize: const Size(64, 52)),
    ),
    chipTheme: const ChipThemeData(
      labelStyle: TextStyle(fontSize: 16),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
    cardTheme: const CardThemeData(margin: EdgeInsets.zero, elevation: 0),
  );
}
