import 'package:flutter/material.dart';

// Color tokens are self-documenting; documenting each hex adds no value.
// ignore_for_file: public_member_api_docs

/// Color tokens from the Stitch "Quietude & Light" design system.
///
/// The palette is inspired by natural pigments and ancient manuscripts,
/// rooted in a "Monastery Minimalist" aesthetic. Earthy, organic tones
/// replace modern vibrancy.
///
/// Usage: only via [AppTheme] — feature code must never reference these directly.
abstract final class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════════
  // Light — "Quietude & Light" (exact from stitch-ui/DESIGN.md)
  // ═══════════════════════════════════════════════════════════════════

  static const lightPrimary = Color(0xFF204E2B);
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFF386641);
  static const lightOnPrimaryContainer = Color(0xFFAFE2B3);
  static const lightInversePrimary = Color(0xFFA0D3A5);

  static const lightSecondary = Color(0xFF645E4B);
  static const lightOnSecondary = Color(0xFFFFFFFF);
  static const lightSecondaryContainer = Color(0xFFECE2C9);
  static const lightOnSecondaryContainer = Color(0xFF6B6450);

  static const lightTertiary = Color(0xFF6C3600);
  static const lightOnTertiary = Color(0xFFFFFFFF);
  static const lightTertiaryContainer = Color(0xFF8F4A00);
  static const lightOnTertiaryContainer = Color(0xFFFFCBA6);

  static const lightError = Color(0xFFBA1A1A);
  static const lightOnError = Color(0xFFFFFFFF);
  static const lightErrorContainer = Color(0xFFFFDAD6);
  static const lightOnErrorContainer = Color(0xFF93000A);

  static const lightBackground = Color(0xFFFCF9F2);
  static const lightOnBackground = Color(0xFF1C1C18);

  static const lightSurface = Color(0xFFFCF9F2);
  static const lightOnSurface = Color(0xFF1C1C18);
  static const lightOnSurfaceVariant = Color(0xFF414941);
  static const lightSurfaceVariant = Color(0xFFE5E2DB);

  static const lightSurfaceDim = Color(0xFFDCDAD3);
  static const lightSurfaceBright = Color(0xFFFCF9F2);
  static const lightSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const lightSurfaceContainerLow = Color(0xFFF6F3EC);
  static const lightSurfaceContainer = Color(0xFFF0EEE7);
  static const lightSurfaceContainerHigh = Color(0xFFEBE8E1);
  static const lightSurfaceContainerHighest = Color(0xFFE5E2DB);

  static const lightInverseSurface = Color(0xFF31312C);
  static const lightInverseOnSurface = Color(0xFFF3F0EA);

  static const lightOutline = Color(0xFF727970);
  static const lightOutlineVariant = Color(0xFFC1C9BE);
  static const lightSurfaceTint = Color(0xFF3A6843);

  static const lightPrimaryFixed = Color(0xFFBCEFC0);
  static const lightPrimaryFixedDim = Color(0xFFA0D3A5);
  static const lightOnPrimaryFixed = Color(0xFF00210A);
  static const lightOnPrimaryFixedVariant = Color(0xFF22502D);

  static const lightSecondaryFixed = Color(0xFFECE2C9);
  static const lightSecondaryFixedDim = Color(0xFFCFC6AE);
  static const lightOnSecondaryFixed = Color(0xFF201B0C);
  static const lightOnSecondaryFixedVariant = Color(0xFF4C4634);

  static const lightTertiaryFixed = Color(0xFFFFDCC4);
  static const lightTertiaryFixedDim = Color(0xFFFFB781);
  static const lightOnTertiaryFixed = Color(0xFF2F1400);
  static const lightOnTertiaryFixedVariant = Color(0xFF6F3800);

  // ═══════════════════════════════════════════════════════════════════
  // Dark — "Night Vigil" (derived from light with monastic night tones)
  // ═══════════════════════════════════════════════════════════════════

  static const darkPrimary = Color(0xFFA0D3A5);
  static const darkOnPrimary = Color(0xFF00210A);
  static const darkPrimaryContainer = Color(0xFF204E2B);
  static const darkOnPrimaryContainer = Color(0xFFBCEFC0);
  static const darkInversePrimary = Color(0xFF204E2B);

  static const darkSecondary = Color(0xFFCFC6AE);
  static const darkOnSecondary = Color(0xFF201B0C);
  static const darkSecondaryContainer = Color(0xFF645E4B);
  static const darkOnSecondaryContainer = Color(0xFFECE2C9);

  static const darkTertiary = Color(0xFFFFB781);
  static const darkOnTertiary = Color(0xFF2F1400);
  static const darkTertiaryContainer = Color(0xFF6C3600);
  static const darkOnTertiaryContainer = Color(0xFFFFDCC4);

  static const darkError = Color(0xFFFFB4AB);
  static const darkOnError = Color(0xFF690005);
  static const darkErrorContainer = Color(0xFF93000A);
  static const darkOnErrorContainer = Color(0xFFFFDAD6);

  static const darkBackground = Color(0xFF1C1C18);
  static const darkOnBackground = Color(0xFFE5E2DB);

  static const darkSurface = Color(0xFF1C1C18);
  static const darkOnSurface = Color(0xFFE5E2DB);
  static const darkOnSurfaceVariant = Color(0xFFC1C9BE);
  static const darkSurfaceVariant = Color(0xFF31312C);

  static const darkSurfaceDim = Color(0xFF141410);
  static const darkSurfaceBright = Color(0xFF2A2A24);
  static const darkSurfaceContainerLowest = Color(0xFF11110D);
  static const darkSurfaceContainerLow = Color(0xFF1C1C18);
  static const darkSurfaceContainer = Color(0xFF242420);
  static const darkSurfaceContainerHigh = Color(0xFF2A2A24);
  static const darkSurfaceContainerHighest = Color(0xFF31312C);

  static const darkInverseSurface = Color(0xFFEBE8E1);
  static const darkInverseOnSurface = Color(0xFF31312C);

  static const darkOutline = Color(0xFF727970);
  static const darkOutlineVariant = Color(0xFF414941);
  static const darkSurfaceTint = Color(0xFFA0D3A5);

  static const darkPrimaryFixed = Color(0xFFBCEFC0);
  static const darkPrimaryFixedDim = Color(0xFFA0D3A5);
  static const darkOnPrimaryFixed = Color(0xFF00210A);
  static const darkOnPrimaryFixedVariant = Color(0xFF22502D);

  static const darkSecondaryFixed = Color(0xFFECE2C9);
  static const darkSecondaryFixedDim = Color(0xFFCFC6AE);
  static const darkOnSecondaryFixed = Color(0xFF201B0C);
  static const darkOnSecondaryFixedVariant = Color(0xFF4C4634);

  static const darkTertiaryFixed = Color(0xFFFFDCC4);
  static const darkTertiaryFixedDim = Color(0xFFFFB781);
  static const darkOnTertiaryFixed = Color(0xFF2F1400);
  static const darkOnTertiaryFixedVariant = Color(0xFF6F3800);

  // ═══════════════════════════════════════════════════════════════════
  // Candlelight — warm amber dark (evening prayer, softened)
  // ═══════════════════════════════════════════════════════════════════

  static const candlePrimary = Color(0xFFC9A66B);
  static const candleOnPrimary = Color(0xFF1B2216);
  static const candlePrimaryContainer = Color(0xFF4A3B22);
  static const candleOnPrimaryContainer = Color(0xFFE8D5B0);
  static const candleInversePrimary = Color(0xFF4A3B22);

  static const candleSecondary = Color(0xFFC9B98F);
  static const candleOnSecondary = Color(0xFF2B2410);
  static const candleSecondaryContainer = Color(0xFF5A5040);
  static const candleOnSecondaryContainer = Color(0xFFECE2C9);

  static const candleTertiary = Color(0xFFD6A574);
  static const candleOnTertiary = Color(0xFF2B1A0A);
  static const candleTertiaryContainer = Color(0xFF6C4A22);
  static const candleOnTertiaryContainer = Color(0xFFFFE0C0);

  static const candleError = Color(0xFFD98A6E);
  static const candleOnError = Color(0xFF4A1500);
  static const candleErrorContainer = Color(0xFF6B2205);
  static const candleOnErrorContainer = Color(0xFFFFCFC0);

  static const candleBackground = Color(0xFF0E0B07);
  static const candleOnBackground = Color(0xFFE8DCC8);

  static const candleSurface = Color(0xFF0E0B07);
  static const candleOnSurface = Color(0xFFE8DCC8);
  static const candleOnSurfaceVariant = Color(0xFFB0A898);
  static const candleSurfaceVariant = Color(0xFF2A2620);

  static const candleSurfaceDim = Color(0xFF0A0806);
  static const candleSurfaceBright = Color(0xFF1A1712);
  static const candleSurfaceContainerLowest = Color(0xFF080604);
  static const candleSurfaceContainerLow = Color(0xFF0E0B07);
  static const candleSurfaceContainer = Color(0xFF161410);
  static const candleSurfaceContainerHigh = Color(0xFF1C1912);
  static const candleSurfaceContainerHighest = Color(0xFF2A2620);

  static const candleInverseSurface = Color(0xFFE8DCC8);
  static const candleInverseOnSurface = Color(0xFF2A2620);

  static const candleOutline = Color(0xFF7A7264);
  static const candleOutlineVariant = Color(0xFF4A4538);
  static const candleSurfaceTint = Color(0xFFC9A66B);

  static const candlePrimaryFixed = Color(0xFFE8D5B0);
  static const candlePrimaryFixedDim = Color(0xFFC9A66B);
  static const candleOnPrimaryFixed = Color(0xFF1B2216);
  static const candleOnPrimaryFixedVariant = Color(0xFF5A4A2A);

  static const candleSecondaryFixed = Color(0xFFECE2C9);
  static const candleSecondaryFixedDim = Color(0xFFC9B98F);
  static const candleOnSecondaryFixed = Color(0xFF2B2410);
  static const candleOnSecondaryFixedVariant = Color(0xFF5A5040);

  static const candleTertiaryFixed = Color(0xFFFFE0C0);
  static const candleTertiaryFixedDim = Color(0xFFD6A574);
  static const candleOnTertiaryFixed = Color(0xFF2B1A0A);
  static const candleOnTertiaryFixedVariant = Color(0xFF6C4A22);
}
