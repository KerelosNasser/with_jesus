import 'package:flutter/material.dart';
import 'package:with_jesus/core/theme/app_spacing.dart';

/// A design-system-aligned card surface wrapping Flutter's Material 3 [Card].
///
/// Sources all colors from [Theme.of(context).colorScheme]. Supports an optional
/// [onTap] callback that adds a Material ripple via [InkWell].
///
/// Example:
/// ```dart
/// SurfaceCard(
///   onTap: _handleTap,
///   child: Text('Content'),
/// )
/// ```
class SurfaceCard extends StatelessWidget {
  /// The content placed inside the card.
  final Widget child;

  /// Optional tap handler — when provided, wraps [child] in an [InkWell] with
  /// a Material ripple.
  final VoidCallback? onTap;

  /// The interior padding. Defaults to [AppSpacing.cardPadding].
  final EdgeInsetsGeometry padding;

  /// Overrides the card fill color. Defaults to [ColorScheme.surfaceContainer].
  final Color? backgroundColor;

  /// Creates a [SurfaceCard] wrapping [child].
  const SurfaceCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const borderRadius = BorderRadius.all(Radius.circular(AppSpacing.radiusXl));

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: backgroundColor ?? colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: borderRadius,
              child: Padding(padding: padding, child: child),
            )
          : Padding(padding: padding, child: child),
    );
  }
}
