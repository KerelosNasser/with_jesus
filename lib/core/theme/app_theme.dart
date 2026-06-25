import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Available visual themes.
///
/// Default is [light]; [dark] and [candlelight] are user-selectable.
enum AppThemeMode {
  /// "Vellum" — warm parchment, daytime.
  light,

  /// "Night Vigil" — warm charcoal, nighttime.
  dark,

  /// "Candlelight" — warmer amber dark, evening prayer.
  candlelight,
}

/// Builds Material 3 [ThemeData] from our design tokens.
///
/// All theme configuration lives here — feature code must never build
/// [ThemeData] directly.
class AppTheme {
  AppTheme._();

  /// Returns the [ColorScheme] for the given [mode].
  static ColorScheme colorScheme(AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.light => const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.lightPrimary,
          onPrimary: AppColors.lightOnPrimary,
          primaryContainer: AppColors.lightPrimaryContainer,
          secondary: AppColors.lightSecondary,
          onSecondary: AppColors.lightOnSurface,
          tertiary: AppColors.lightTertiary,
          surface: AppColors.lightSurface,
          surfaceContainerHighest: AppColors.lightSurfaceVariant,
          onSurface: AppColors.lightOnSurface,
          onSurfaceVariant: AppColors.lightOnSurfaceVariant,
          outline: AppColors.lightOutline,
          error: AppColors.lightError,
          onError: AppColors.lightOnPrimary,
        ),
      AppThemeMode.dark => const ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.darkPrimary,
          onPrimary: AppColors.darkOnPrimary,
          primaryContainer: AppColors.darkPrimaryContainer,
          secondary: AppColors.darkSecondary,
          onSecondary: AppColors.darkOnSurface,
          tertiary: AppColors.darkTertiary,
          surface: AppColors.darkSurface,
          surfaceContainerHighest: AppColors.darkSurfaceVariant,
          onSurface: AppColors.darkOnSurface,
          onSurfaceVariant: AppColors.darkOnSurfaceVariant,
          outline: AppColors.darkOutline,
          error: AppColors.darkError,
          onError: AppColors.darkOnPrimary,
        ),
      AppThemeMode.candlelight => const ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.candlePrimary,
          onPrimary: AppColors.candleOnPrimary,
          primaryContainer: AppColors.candlePrimaryContainer,
          secondary: AppColors.candleSecondary,
          onSecondary: AppColors.candleOnSurface,
          tertiary: AppColors.candleTertiary,
          surface: AppColors.candleSurface,
          surfaceContainerHighest: AppColors.candleSurfaceVariant,
          onSurface: AppColors.candleOnSurface,
          onSurfaceVariant: AppColors.candleOnSurfaceVariant,
          outline: AppColors.candleOutline,
          error: AppColors.candleError,
          onError: AppColors.candleOnPrimary,
        ),
    };
  }

  /// Returns complete [ThemeData] for the given [mode].
  ///
  /// Fonts are placeholders until the pairing is finalized (M0 open decision).
  static ThemeData themeData(AppThemeMode mode) {
    final colors = colorScheme(mode);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      fontFamily: 'NotoNaskhArabic',
      textTheme: _textTheme(colors),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: colors.outline.withValues(alpha: 0.3),
          ),
        ),
      ),
      scaffoldBackgroundColor: colors.surface,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surface,
        selectedItemColor: colors.primary,
        unselectedItemColor: colors.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  /// Type scale tuned for Arabic (design.md §2).
  ///
  /// Large, airy for long-form reading; no uppercase transforms (Arabic-safe).
  static TextTheme _textTheme(ColorScheme colors) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: colors.onSurface,
        letterSpacing: 0, // Arabic: never add letter-spacing
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: colors.onSurface,
        letterSpacing: 0,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: colors.onSurface,
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: colors.onSurface,
        letterSpacing: 0,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        height: 1.8, // Extra leading for long-form Arabic
        color: colors.onSurface,
        letterSpacing: 0,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.7,
        color: colors.onSurface,
        letterSpacing: 0,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: colors.onSurface,
        letterSpacing: 0, // Arabic has no case
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.2,
        color: colors.onSurfaceVariant,
        letterSpacing: 0,
      ),
    );
  }

  /// Returns [ThemeMode] for Riverpod / MaterialApp consumption.
  ///
  /// Note: [candlelight] maps to [ThemeMode.dark]; the candlelight *look* is
  /// applied via [themeData], independent of this system classification.
  static ThemeMode materialThemeMode(AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.candlelight => ThemeMode.dark,
    };
  }
}
