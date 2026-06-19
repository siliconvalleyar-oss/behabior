import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF6C5CE7);
  static const Color secondary = Color(0xFF00CEC9);
  static const Color accent = Color(0xFFFD79A8);
  static const Color background = Color(0xFF2D3436);
  static const Color surface = Color(0xFF353B48);
  static const Color error = Color(0xFFD63031);
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color textPrimary = Color(0xFFDFE6E9);
  static const Color textSecondary = Color(0xFFB2BEC3);
  static const Color glassLight = Color(0x88B0E0FF);
  static const Color liquidBlue = Color(0x8866BBFF);
  static const Color liquidGreen = Color(0x8844FF88);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: error,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.w900,
          color: textPrimary,
          letterSpacing: 2,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: secondary,
          side: const BorderSide(color: secondary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: secondary,
        inactiveTrackColor: surface,
        thumbColor: primary,
        overlayColor: primary.withOpacity(0.2),
      ),
    );
  }

  static BoxDecoration get glassDecoration {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Colors.white.withOpacity(0.2),
        width: 1,
      ),
    );
  }

  static BoxDecoration get liquidDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          liquidBlue.withOpacity(0.3),
          liquidGreen.withOpacity(0.3),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
    );
  }

  static LinearGradient get primaryGradient {
    return const LinearGradient(
      colors: [primary, Color(0xFFA29BFE)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
