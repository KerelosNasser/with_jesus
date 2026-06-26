import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

/// A monastic-style illustration with a soft glow backdrop and a centered icon.
///
/// Used in onboarding pages to create a serene, contemplative visual
/// without relying on external image assets.
class MonasticIllustration extends StatelessWidget {
  /// Creates a [MonasticIllustration] with the given [icon].
  const MonasticIllustration({
    super.key,
    required this.icon,
    this.glowColor,
    this.iconSize = 120,
    this.glowSize = 280,
  });

  /// The icon displayed at the center of the glow.
  final IconData icon;

  /// Optional override for the glow backdrop color.
  final Color? glowColor;

  /// The size of the center icon. Defaults to 120.
  final double iconSize;

  /// The outer diameter of the glow backdrop. Defaults to 280.
  final double glowSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glow = glowColor ?? theme.colorScheme.primary.withValues(alpha: 0.12);
    final iconColor = theme.colorScheme.onSurface.withValues(alpha: 0.85);

    return SizedBox(
      width: glowSize,
      height: glowSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft glow backdrop
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
            child: Container(
              width: glowSize,
              height: glowSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: glow,
              ),
            ),
          ),
          // Secondary glow ring
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
            child: Container(
              width: glowSize * 0.7,
              height: glowSize * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.surfaceContainerLow,
              ),
            ),
          ),
          // Icon
          Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
        ],
      ),
    );
  }
}

/// Staggered fade-in-up animation for onboarding content.
///
/// Delays its entrance by [delay] milliseconds, then animates opacity
/// and a slight upward slide over [duration].
class FadeInUp extends StatefulWidget {
  /// Creates a [FadeInUp] wrapping [child] with staggered animation.
  const FadeInUp({
    super.key,
    required this.child,
    this.delay = const Duration(milliseconds: 0),
    this.duration = const Duration(milliseconds: 800),
  });

  /// The widget to animate in.
  final Widget child;

  /// Delay before the animation starts. Defaults to zero.
  final Duration delay;

  /// Duration of the fade-in-up animation. Defaults to 800 ms.
  final Duration duration;

  @override
  State<FadeInUp> createState() => _FadeInUpState();
}

class _FadeInUpState extends State<FadeInUp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Cubic(0.2, 0.0, 0.0, 1.0),
      ),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _controller.value)),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Pagination dots used across onboarding pages.
class OnboardingDots extends StatelessWidget {
  /// Creates an [OnboardingDots] row with [count] dots.
  const OnboardingDots({
    super.key,
    required this.count,
    required this.activeIndex,
    this.activeColor,
    this.inactiveColor,
  });

  /// Total number of dots.
  final int count;

  /// Index of the currently active (highlighted) dot.
  final int activeIndex;

  /// Color of the active dot. Defaults to [ColorScheme.primary].
  final Color? activeColor;

  /// Color of inactive dots. Defaults to [ColorScheme.outlineVariant].
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: isActive ? 24 : 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: isActive
                ? (activeColor ?? colors.primary)
                : (inactiveColor ?? colors.outlineVariant),
          ),
        );
      }),
    );
  }
}

/// Progress bar segments used at the top of onboarding page 2.
class OnboardingProgressBars extends StatelessWidget {
  /// Creates an [OnboardingProgressBars] with [count] segments.
  const OnboardingProgressBars({
    super.key,
    required this.count,
    required this.activeIndex,
    this.activeColor,
  });

  /// Total number of progress segments.
  final int count;

  /// Index of the currently active (filled) segment.
  final int activeIndex;

  /// Color of the active segment. Defaults to `Color(0xFFBC6C25)`.
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: isActive
                  ? (activeColor ?? const Color(0xFFBC6C25))
                  : colors.surfaceContainerHigh,
            ),
          ),
        );
      }),
    );
  }
}
