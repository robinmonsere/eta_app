import 'package:flutter/material.dart';

final etaTheme = ThemeData(
  brightness: Brightness.dark, // Dark mode only
  primaryColor: const Color(0xFF1a8cd8),
  scaffoldBackgroundColor: const Color(0xFF000000),

  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF1a8cd8),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF00b87a),
    onSecondary: Color(0xFFFFFFFF),
    error: Color(0xFFF64C5D),
    onError: Color(0xFFFFFFFF),
    surface: Color(0xFF000000),
    onSurface: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF0D0F10),
    secondaryContainer: Color(0xFF202327),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF202327),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(color: Color(0xFF1a8cd8)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(color: Color(0xFF1a8cd8)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(color: Color(0xFF1a8cd8), width: 2),
    ),
    hintStyle: const TextStyle(color: Color(0xFFFFFFFF)),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return const Color(0xFF202327);
          }
          return const Color(0xFF1a8cd8);
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.white.withOpacity(
              0.5,
            );
          }
          return Colors.white;
        },
      ),
    ),
  ),
);
