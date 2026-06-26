import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import 'widgets/onboarding_widgets.dart';

/// Onboarding Page 1: "صمت رقمي.. حضور إلهي"
///
/// Features a skip button, centered illustration with glow,
/// title + body text, and bottom navigation with dots + next button.
class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({
    super.key,
    required this.onSkip,
    required this.onNext,
  });

  final VoidCallback onSkip;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Skip Button ──
            FadeInUp(
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    top: AppSpacing.lg,
                    end: AppSpacing.containerPadding,
                  ),
                  child: TextButton(
                    onPressed: onSkip,
                    style: TextButton.styleFrom(
                      foregroundColor: colors.onSurfaceVariant,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusFull,
                        ),
                      ),
                    ),
                    child: Text('تخطي', style: textTheme.labelLarge),
                  ),
                ),
              ),
            ),

            // ── Main Content ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerPadding,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Illustration
                    FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      child: MonasticIllustration(
                        icon: Icons.light_mode_outlined,
                        glowColor: colors.primary.withValues(alpha: 0.08),
                        iconSize: 100,
                        glowSize: 260,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sectionMargin),

                    // Title
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        'صمت رقمي.. حضور إلهي',
                        textAlign: TextAlign.center,
                        style: textTheme.headlineMedium?.copyWith(
                          color: colors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.componentGap),

                    // Body
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: Text(
                        'ابتعد عن ضجيج العالم وادخل في مساحة من الهدوء الروحي. صُمم هذا التطبيق ليكون خلوتك النقية.',
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom Navigation ──
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerPadding,
                ).copyWith(bottom: AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OnboardingDots(
                      count: 3,
                      activeIndex: 0,
                      activeColor: colors.primaryContainer,
                    ),
                      FilledButton(
                        onPressed: onNext,
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.primaryContainer,
                          foregroundColor: colors.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusFull,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chevron_left,
                              size: 20,
                              color: colors.onPrimary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'التالي',
                              style: textTheme.labelLarge?.copyWith(
                                color: colors.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
