import 'package:flutter/material.dart';

/// Color tokens from design.md — "Vellum" (light), "Night Vigil" (dark),
/// and optional "Candlelight" (warm-dark for evening prayer).
///
/// Usage: only via [AppTheme] — feature code must never reference these directly.
abstract final class AppColors {
  AppColors._();

  // ─── Light — "Vellum" ───────────────────────────────────────────────────

  static const lightPrimary = Color(0xFF5C6B4F);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFFDCE4D2);
  static const lightSecondary = Color(0xFF8A7B5C);
  static const lightTertiary = Color(0xFF6E5544);
  static const lightSurface = Color(0xFFFBF8F1);
  static const lightSurfaceVariant = Color(0xFFEFE9DC);
  static const lightOnSurface = Color(0xFF1F1B16);
  static const lightOnSurfaceVariant = Color(0xFF4D4639);
  static const lightOutline = Color(0xFF7A7264);
  static const lightError = Color(0xFF9B4A3B);
  static const lightBackground = Color(0xFFFBF8F1);

  // ─── Dark — "Night Vigil" ────────────────────────────────────────────────

  static const darkPrimary = Color(0xFFA9C18C);
  static const darkOnPrimary = Color(0xFF1B2216);
  static const darkPrimaryContainer = Color(0xFF424F36);
  static const darkSecondary = Color(0xFFC9B98F);
  static const darkTertiary = Color(0xFFD6BCA5);
  static const darkSurface = Color(0xFF141210);
  static const darkSurfaceVariant = Color(0xFF2A2620);
  static const darkOnSurface = Color(0xFFEFE9DC);
  static const darkOnSurfaceVariant = Color(0xFFC9C2B5);
  static const darkOutline = Color(0xFF8E8676);
  static const darkError = Color(0xFFD98A6E);
  static const darkBackground = Color(0xFF100E0C);

  // ─── Candlelight (optional warm-dark) ───────────────────────────────────

  static const candlePrimary = Color(0xFFC9A66B);
  static const candleOnPrimary = Color(0xFF1B2216);
  static const candlePrimaryContainer = Color(0xFF424F36);
  static const candleSecondary = Color(0xFFC9B98F);
  static const candleTertiary = Color(0xFFD6BCA5);
  static const candleSurface = Color(0xFF0E0B07);
  static const candleSurfaceVariant = Color(0xFF2A2620);
  static const candleOnSurface = Color(0xFFEFE9DC);
  static const candleOnSurfaceVariant = Color(0xFFC9C2B5);
  static const candleOutline = Color(0xFF8E8676);
  static const candleError = Color(0xFFD98A6E);
  static const candleBackground = Color(0xFF0A0806);
}
