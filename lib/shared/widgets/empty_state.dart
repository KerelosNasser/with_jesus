import 'package:flutter/material.dart';
import 'package:with_jesus/core/theme/app_spacing.dart';
import 'package:with_jesus/shared/widgets/app_button.dart';

/// A calm, centered empty-state display for screens with no content yet.
///
/// Uses muted [ColorScheme.onSurfaceVariant] colors to avoid drawing attention.
/// An optional [buttonText] + [onAction] pair renders an [AppButton.secondary]
/// call-to-action.
///
/// Example:
/// ```dart
/// EmptyState(
///   icon: Icons.book_outlined,
///   title: 'No readings yet',
///   subtitle: 'Your reading journey begins here.',
///   buttonText: 'Browse Bible',
///   onAction: _openBible,
/// )
/// ```
class EmptyState extends StatelessWidget {
  /// A large icon displayed at the top of the empty state.
  final IconData icon;

  /// The primary heading.
  final String title;

  /// An optional secondary description below the title.
  final String? subtitle;

  /// Text for the call-to-action button. Only shown when [onAction] is also set.
  final String? buttonText;

  /// Callback when the action button is tapped. Only shown when [buttonText] is
  /// also set.
  final VoidCallback? onAction;

  /// Creates an [EmptyState] with [icon] and [title].
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.buttonText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (buttonText != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.xl),
            AppButton.secondary(
              text: buttonText!,
              onPressed: onAction,
            ),
          ],
        ],
      ),
    );
  }
}
