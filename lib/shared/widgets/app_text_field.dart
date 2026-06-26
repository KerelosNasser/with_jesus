import 'package:flutter/material.dart';
import 'package:with_jesus/core/theme/app_spacing.dart';

/// A design-system-aligned text input with the label rendered **above** the
/// field (not floating inside it).
///
/// Sources all colors from [Theme.of(context).colorScheme] and spacing from
/// [AppSpacing]. Handles focused, enabled, error, and focused-error border states.
///
/// Example:
/// ```dart
/// AppTextField(
///   controller: _controller,
///   labelText: 'Email',
///   hintText: 'name@example.com',
///   errorText: _emailError,
/// )
/// ```
class AppTextField extends StatelessWidget {
  /// Controls the text being edited.
  final TextEditingController? controller;

  /// The label displayed **above** the field.
  final String? labelText;

  /// Placeholder text shown inside the field when it is empty.
  final String? hintText;

  /// When non-null, displays an error state and message below the field.
  final String? errorText;

  /// When `true`, hides the typed text (e.g. for passwords).
  final bool obscureText;

  /// An optional icon placed at the start of the input.
  final Widget? prefixIcon;

  /// Creates an [AppTextField] with an optional label and input configuration.
  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const borderRadius = BorderRadius.all(Radius.circular(AppSpacing.radiusMd));

    OutlineInputBorder buildBorder(Color color, {double width = 1}) =>
        OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: color, width: width),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            prefixIcon: prefixIcon,
            filled: true,
            fillColor: colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            border: buildBorder(colorScheme.outlineVariant),
            enabledBorder: buildBorder(colorScheme.outlineVariant),
            focusedBorder: buildBorder(colorScheme.primary, width: 2),
            errorBorder: buildBorder(colorScheme.error),
            focusedErrorBorder: buildBorder(colorScheme.error, width: 2),
          ),
        ),
      ],
    );
  }
}
