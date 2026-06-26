// Documenting every numeric constant here adds no value; the names are the docs.
// ignore_for_file: public_member_api_docs

/// Spacing tokens from the Stitch "Quietude & Light" design system.
///
/// Based on an 8 px unit grid, emphasizing a "breathable" interface.
///
/// Usage: `AppSpacing.lg` everywhere in widgets. Never hardcode inset values.
abstract final class AppSpacing {
  AppSpacing._();

  // ─── Unit Grid (8 px base) ───────────────────────────────────────────

  static const double unit = 8.0;
  static const double xs = 4.0;   // 0.5 unit
  static const double sm = 8.0;   // 1 unit
  static const double md = 12.0;  // 1.5 units — component gap
  static const double lg = 16.0;  // 2 units — gutter
  static const double xl = 24.0;  // 3 units — container padding
  static const double xxl = 32.0; // 4 units
  static const double xxxl = 40.0; // 5 units — section margin
  static const double xxxxl = 48.0; // 6 units

  // ─── Semantic Tokens (from stitch DESIGN.md) ─────────────────────────

  /// 24 px — generous side margin on mobile for "inset" focus.
  static const double containerPadding = 24.0;

  /// 16 px — gap between columns or major layout areas.
  static const double gutter = 16.0;

  /// 12 px — internal gap between related items inside a card or group.
  static const double componentGap = 12.0;

  /// 40 px — breathing room between major sections.
  static const double sectionMargin = 40.0;

  // ─── Component Spacing ──────────────────────────────────────────────

  /// Default screen horizontal padding for phones.
  static const double screenHorizontal = 24.0;

  /// Default card padding.
  static const double cardPadding = 16.0;

  /// Gap between cards.
  static const double cardGap = 24.0;

  /// Extra breathing room — used around the Verse of the Day hero.
  static const double verse = 64.0;

  /// Minimum touch target size (48×48 dp — a11y).
  static const double touchTarget = 48.0;

  // ─── Shape Radii (from stitch DESIGN.md) ───────────────────────────

  /// 4 px — small chips, tags.
  static const double radiusSm = 4.0;

  /// 8 px — buttons, inputs, small components (default / rounded).
  static const double radiusMd = 8.0;

  /// 12 px — medium components.
  static const double radiusLg = 12.0;

  /// 16 px — cards, main containers (rounded-lg in design).
  static const double radiusXl = 16.0;

  /// 24 px — dialogs, large surfaces.
  static const double radius2xl = 24.0;

  /// Fully rounded (9999 px equivalent).
  static const double radiusFull = 9999.0;
}
