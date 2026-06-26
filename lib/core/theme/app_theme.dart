import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Available visual themes.
///
/// Default is [light]; [dark] and [candlelight] are user-selectable.
enum AppThemeMode {
  /// "Quietude & Light" — warm parchment, daytime.
  light,

  /// "Night Vigil" — warm charcoal, nighttime.
  dark,

  /// "Candlelight" — warmer amber dark, evening prayer.
  candlelight,
}

/// Builds Material 3 [ThemeData] from the Stitch "Quietude & Light" design tokens.
///
/// All theme configuration lives here — feature code must never build
/// [ThemeData] directly.
class AppTheme {
  AppTheme._();

  // ───────────────────────────────────────────────────────────────────────
  // Color Schemes
  // ───────────────────────────────────────────────────────────────────────

  /// Returns the [ColorScheme] for the given [mode].
  static ColorScheme colorScheme(AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.light => _lightColorScheme,
      AppThemeMode.dark => _darkColorScheme,
      AppThemeMode.candlelight => _candlelightColorScheme,
    };
  }

  static const _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.lightPrimary,
    onPrimary: AppColors.lightOnPrimary,
    primaryContainer: AppColors.lightPrimaryContainer,
    onPrimaryContainer: AppColors.lightOnPrimaryContainer,
    secondary: AppColors.lightSecondary,
    onSecondary: AppColors.lightOnSecondary,
    secondaryContainer: AppColors.lightSecondaryContainer,
    onSecondaryContainer: AppColors.lightOnSecondaryContainer,
    tertiary: AppColors.lightTertiary,
    onTertiary: AppColors.lightOnTertiary,
    tertiaryContainer: AppColors.lightTertiaryContainer,
    onTertiaryContainer: AppColors.lightOnTertiaryContainer,
    error: AppColors.lightError,
    onError: AppColors.lightOnError,
    errorContainer: AppColors.lightErrorContainer,
    onErrorContainer: AppColors.lightOnErrorContainer,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightOnSurface,
    onSurfaceVariant: AppColors.lightOnSurfaceVariant,
    outline: AppColors.lightOutline,
    outlineVariant: AppColors.lightOutlineVariant,
    inverseSurface: AppColors.lightInverseSurface,
    onInverseSurface: AppColors.lightInverseOnSurface,
    inversePrimary: AppColors.lightInversePrimary,
    surfaceTint: AppColors.lightSurfaceTint,
    surfaceContainerLowest: AppColors.lightSurfaceContainerLowest,
    surfaceContainerLow: AppColors.lightSurfaceContainerLow,
    surfaceContainer: AppColors.lightSurfaceContainer,
    surfaceContainerHigh: AppColors.lightSurfaceContainerHigh,
    surfaceContainerHighest: AppColors.lightSurfaceContainerHighest,
    scrim: Color(0xFF000000),
    shadow: Color(0xFF000000),
  );

  static const _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.darkPrimary,
    onPrimary: AppColors.darkOnPrimary,
    primaryContainer: AppColors.darkPrimaryContainer,
    onPrimaryContainer: AppColors.darkOnPrimaryContainer,
    secondary: AppColors.darkSecondary,
    onSecondary: AppColors.darkOnSecondary,
    secondaryContainer: AppColors.darkSecondaryContainer,
    onSecondaryContainer: AppColors.darkOnSecondaryContainer,
    tertiary: AppColors.darkTertiary,
    onTertiary: AppColors.darkOnTertiary,
    tertiaryContainer: AppColors.darkTertiaryContainer,
    onTertiaryContainer: AppColors.darkOnTertiaryContainer,
    error: AppColors.darkError,
    onError: AppColors.darkOnError,
    errorContainer: AppColors.darkErrorContainer,
    onErrorContainer: AppColors.darkOnErrorContainer,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkOnSurface,
    onSurfaceVariant: AppColors.darkOnSurfaceVariant,
    outline: AppColors.darkOutline,
    outlineVariant: AppColors.darkOutlineVariant,
    inverseSurface: AppColors.darkInverseSurface,
    onInverseSurface: AppColors.darkInverseOnSurface,
    inversePrimary: AppColors.darkInversePrimary,
    surfaceTint: AppColors.darkSurfaceTint,
    surfaceContainerLowest: AppColors.darkSurfaceContainerLowest,
    surfaceContainerLow: AppColors.darkSurfaceContainerLow,
    surfaceContainer: AppColors.darkSurfaceContainer,
    surfaceContainerHigh: AppColors.darkSurfaceContainerHigh,
    surfaceContainerHighest: AppColors.darkSurfaceContainerHighest,
    scrim: Color(0xFF000000),
    shadow: Color(0xFF000000),
  );

  static const _candlelightColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.candlePrimary,
    onPrimary: AppColors.candleOnPrimary,
    primaryContainer: AppColors.candlePrimaryContainer,
    onPrimaryContainer: AppColors.candleOnPrimaryContainer,
    secondary: AppColors.candleSecondary,
    onSecondary: AppColors.candleOnSecondary,
    secondaryContainer: AppColors.candleSecondaryContainer,
    onSecondaryContainer: AppColors.candleOnSecondaryContainer,
    tertiary: AppColors.candleTertiary,
    onTertiary: AppColors.candleOnTertiary,
    tertiaryContainer: AppColors.candleTertiaryContainer,
    onTertiaryContainer: AppColors.candleOnTertiaryContainer,
    error: AppColors.candleError,
    onError: AppColors.candleOnError,
    errorContainer: AppColors.candleErrorContainer,
    onErrorContainer: AppColors.candleOnErrorContainer,
    surface: AppColors.candleSurface,
    onSurface: AppColors.candleOnSurface,
    onSurfaceVariant: AppColors.candleOnSurfaceVariant,
    outline: AppColors.candleOutline,
    outlineVariant: AppColors.candleOutlineVariant,
    inverseSurface: AppColors.candleInverseSurface,
    onInverseSurface: AppColors.candleInverseOnSurface,
    inversePrimary: AppColors.candleInversePrimary,
    surfaceTint: AppColors.candleSurfaceTint,
    surfaceContainerLowest: AppColors.candleSurfaceContainerLowest,
    surfaceContainerLow: AppColors.candleSurfaceContainerLow,
    surfaceContainer: AppColors.candleSurfaceContainer,
    surfaceContainerHigh: AppColors.candleSurfaceContainerHigh,
    surfaceContainerHighest: AppColors.candleSurfaceContainerHighest,
    scrim: Color(0xFF000000),
    shadow: Color(0xFF000000),
  );

  // ───────────────────────────────────────────────────────────────────────
  // Theme Data
  // ───────────────────────────────────────────────────────────────────────

  /// Returns complete [ThemeData] for the given [mode].
  static ThemeData themeData(AppThemeMode mode) {
    final colors = colorScheme(mode);
    final isDark = colors.brightness == Brightness.dark;

    final textTheme = _buildTextTheme(colors);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      textTheme: textTheme,
      fontFamily: GoogleFonts.notoSansArabic().fontFamily,

      // ── Scaffold & General ──
      scaffoldBackgroundColor: colors.surface,
      canvasColor: colors.surface,
      dividerColor: colors.outlineVariant.withValues(alpha: 0.4),
      disabledColor: colors.onSurface.withValues(alpha: 0.38),
      hintColor: colors.onSurfaceVariant,
      splashColor: colors.primary.withValues(alpha: 0.08),
      highlightColor: colors.primary.withValues(alpha: 0.04),

      // ── App Bar ──
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.headlineMedium,
        iconTheme: IconThemeData(color: colors.primary, size: 24),
        actionsIconTheme: IconThemeData(color: colors.primary, size: 24),
      ),

      // ── Card ──
      // Cards use Soft Beige (surfaceContainerLow) as background per
      // the Stitch design: "Elevated style, but using Soft Beige (#F2E8CF)"
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? colors.surfaceContainerLow : colors.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colors.outline.withValues(alpha: 0.12)),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      ),

      // ── Elevated Button ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              backgroundColor: colors.primaryContainer,
              foregroundColor: colors.onPrimaryContainer,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: textTheme.labelLarge,
              minimumSize: const Size(48, 48),
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return colors.primary.withValues(alpha: 0.12);
                }
                if (states.contains(WidgetState.hovered)) {
                  return colors.primary.withValues(alpha: 0.08);
                }
                return null;
              }),
            ),
      ),

      // ── Filled Button ──
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: textTheme.labelLarge,
          minimumSize: const Size(48, 48),
        ),
      ),

      // ── Outlined Button ──
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.onSurface,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(color: colors.outline, width: 1),
          textStyle: textTheme.labelLarge,
          minimumSize: const Size(48, 48),
        ),
      ),

      // ── Text Button ──
      textButtonTheme: TextButtonThemeData(
        style:
            TextButton.styleFrom(
              foregroundColor: colors.onSurfaceVariant,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: textTheme.labelLarge,
              minimumSize: const Size(48, 48),
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return colors.primary.withValues(alpha: 0.08);
                }
                return null;
              }),
            ),
      ),

      // ── Input Decoration ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.outline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.error, width: 2),
        ),
        labelStyle: textTheme.labelLarge?.copyWith(
          color: colors.onSurfaceVariant,
        ),
        floatingLabelStyle: textTheme.labelLarge?.copyWith(
          color: colors.primary,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colors.onSurfaceVariant.withValues(alpha: 0.6),
        ),
      ),

      // ── Chip ──
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceContainerLow,
        selectedColor: colors.primary,
        labelStyle: textTheme.labelLarge,
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(
          color: colors.onPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: colors.outline.withValues(alpha: 0.2)),
        ),
        showCheckmark: false,
      ),

      // ── List Tile ──
      listTileTheme: ListTileThemeData(
        tileColor: colors.surfaceContainerLow,
        selectedTileColor: colors.surfaceContainerHigh,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(
          color: colors.onSurfaceVariant,
        ),
        leadingAndTrailingTextStyle: textTheme.labelLarge,
        minLeadingWidth: 24,
        minTileHeight: 56,
      ),

      // ── Bottom Navigation ──
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surface,
        selectedItemColor: colors.primary,
        unselectedItemColor: colors.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: textTheme.labelSmall,
        unselectedLabelStyle: textTheme.labelSmall,
      ),

      // ── Navigation Bar (M3) ──
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surfaceContainer,
        indicatorColor: colors.secondaryContainer,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w500,
            );
          }
          return textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colors.onSecondaryContainer, size: 24);
          }
          return IconThemeData(color: colors.onSurfaceVariant, size: 24);
        }),
      ),

      // ── Floating Action Button ──
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primaryContainer,
        foregroundColor: colors.onPrimaryContainer,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // ── Dialog ──
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surfaceContainerHigh,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // ── Switch ──
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primaryContainer;
          }
          return colors.surfaceContainerHighest;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return colors.surfaceContainerHighest;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return colors.outline;
        }),
      ),

      // ── Checkbox ──
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primary;
          }
          return colors.surfaceContainerHighest;
        }),
        checkColor: WidgetStateProperty.all(colors.onPrimary),
        side: BorderSide(color: colors.outline, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // ── Slider ──
      sliderTheme: SliderThemeData(
        activeTrackColor: colors.primary,
        inactiveTrackColor: colors.surfaceContainerHighest,
        thumbColor: colors.primaryContainer,
        overlayColor: colors.primary.withValues(alpha: 0.12),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
      ),

      // ── Progress Indicator ──
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.tertiary,
        linearTrackColor: colors.surfaceContainerHighest,
        circularTrackColor: colors.surfaceContainerHighest,
      ),

      // ── Snack Bar ──
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colors.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      // ── Tooltip ──
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colors.inverseSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: textTheme.labelMedium?.copyWith(
          color: colors.onInverseSurface,
        ),
      ),
      tabBarTheme: TabBarThemeData(indicatorColor: colors.primary),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // Typography
  // ───────────────────────────────────────────────────────────────────────

  /// Type scale from stitch-ui DESIGN.md § Typography.
  ///
  /// All values tuned for Arabic (RTL-safe, no letter-spacing, generous leading).
  static TextTheme _buildTextTheme(ColorScheme colors) {
    final baseTextStyle = GoogleFonts.notoSansArabic();

    TextStyle style({
      required double fontSize,
      required FontWeight fontWeight,
      required double height,
      Color? color,
    }) {
      return baseTextStyle.copyWith(
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height / fontSize,
        color: color ?? colors.onSurface,
        letterSpacing: 0,
      );
    }

    return TextTheme(
      // display-lg: 57px / 400 / 64px
      displayLarge: style(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        height: 64,
      ),
      // headline-lg: 32px / 500 / 40px
      headlineLarge: style(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        height: 40,
      ),
      // headline-lg-mobile: 28px / 500 / 36px
      headlineMedium: style(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        height: 36,
      ),
      headlineSmall: style(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 32,
      ),
      // title-lg: 22px / 500 / 28px
      titleLarge: style(fontSize: 22, fontWeight: FontWeight.w500, height: 28),
      titleMedium: style(fontSize: 18, fontWeight: FontWeight.w500, height: 26),
      titleSmall: style(fontSize: 16, fontWeight: FontWeight.w500, height: 24),
      // body-lg: 18px / 400 / 30px
      bodyLarge: style(fontSize: 18, fontWeight: FontWeight.w400, height: 30),
      // body-md: 16px / 400 / 26px
      bodyMedium: style(fontSize: 16, fontWeight: FontWeight.w400, height: 26),
      bodySmall: style(fontSize: 14, fontWeight: FontWeight.w400, height: 22),
      // label-lg: 14px / 500 / 20px
      labelLarge: style(fontSize: 14, fontWeight: FontWeight.w500, height: 20),
      labelMedium: style(fontSize: 12, fontWeight: FontWeight.w500, height: 18),
      labelSmall: style(fontSize: 11, fontWeight: FontWeight.w500, height: 16),
    );
  }

  // ───────────────────────────────────────────────────────────────────────
  // Utilities
  // ───────────────────────────────────────────────────────────────────────

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
