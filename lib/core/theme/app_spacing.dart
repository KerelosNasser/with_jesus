import 'package:flutter/material.dart';

/// Spacing tokens from design.md — a single 4 dp base grid.
///
/// Usage: `AppSpacing.lg` everywhere in widgets. Never hardcode inset values.
abstract final class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;

  /// Extra breathing room — used around the Verse of the Day hero.
  static const double verse = 64.0;

  /// Default screen horizontal padding for phones.
  static const double screenHorizontal = 24.0;

  /// Default card padding.
  static const double cardPadding = 16.0;

  /// Gap between cards.
  static const double cardGap = 24.0;

  /// Minimum touch target size (48×48 dp — a11y).
  static const double touchTarget = 48.0;
}
