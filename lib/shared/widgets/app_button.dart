import 'package:flutter/material.dart';
import 'package:with_jesus/core/theme/app_spacing.dart';

/// The visual variant of an [AppButton].
enum AppButtonType {
  /// Highest emphasis — filled background.
  primary,

  /// Medium emphasis — outlined border.
  secondary,

  /// Lowest emphasis — no border or fill.
  text,
}

/// A design-system-aligned button wrapping Flutter's Material 3 button widgets.
///
/// Always sources colors from [Theme.of(context).colorScheme] and spacing from
/// [AppSpacing]. Minimum height is [AppSpacing.touchTarget] (48 dp).
///
/// Use the named constructors for clarity:
/// ```dart
/// AppButton.primary(text: 'Save', onPressed: _save)
/// AppButton.secondary(text: 'Cancel', onPressed: _cancel)
/// AppButton.text(text: 'Learn more', onPressed: _learnMore)
/// ```
class AppButton extends StatelessWidget {
  /// The label displayed on the button.
  final String text;

  /// Called when the button is tapped. When `null`, the button is disabled.
  final VoidCallback? onPressed;

  /// The visual variant — [AppButtonType.primary], [AppButtonType.secondary],
  /// or [AppButtonType.text].
  final AppButtonType type;

  /// When `true`, shows a small [CircularProgressIndicator] replacing the label.
  final bool isLoading;

  /// An optional icon rendered before the label.
  final IconData? icon;

  /// Creates an [AppButton] with the given [type].
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.icon,
  });

  /// Filled button — highest emphasis. Uses [ColorScheme.primary].
  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : type = AppButtonType.primary;

  /// Outlined button — medium emphasis. Uses [ColorScheme.outline] border.
  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : type = AppButtonType.secondary;

  /// Text button — lowest emphasis. No border or fill.
  const AppButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : type = AppButtonType.text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Determine the foreground color for the loading spinner based on button type.
    final spinnerColor = switch (type) {
      AppButtonType.primary => colorScheme.onPrimary,
      AppButtonType.secondary || AppButtonType.text => colorScheme.primary,
    };

    final Widget child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          );

    const minSize = Size.fromHeight(AppSpacing.touchTarget);
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusMd)),
    );

    return switch (type) {
      AppButtonType.primary => FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            minimumSize: minSize,
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            disabledBackgroundColor: colorScheme.primary.withValues(alpha: 0.38),
            disabledForegroundColor: colorScheme.onPrimary.withValues(alpha: 0.38),
            shape: shape,
          ),
          child: child,
        ),
      AppButtonType.secondary => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: minSize,
            foregroundColor: colorScheme.primary,
            side: BorderSide(color: colorScheme.outline),
            shape: shape,
          ),
          child: child,
        ),
      AppButtonType.text => TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            minimumSize: minSize,
            foregroundColor: colorScheme.primary,
            shape: shape,
          ),
          child: child,
        ),
    };
  }
}
