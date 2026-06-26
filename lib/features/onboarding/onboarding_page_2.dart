import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import 'widgets/onboarding_widgets.dart';

/// Onboarding Page 2: "نمو روحي هادئ"
///
/// Features top progress bars, centered illustration with warm glow,
/// title + body text, and bottom primary + skip buttons.
class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({
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
            // ── Progress Bars ──
            const FadeInUp(
              child: Padding(
                padding: EdgeInsets.only(
                  top: AppSpacing.xl,
                  left: AppSpacing.containerPadding,
                  right: AppSpacing.containerPadding,
                ),
                child: OnboardingProgressBars(count: 3, activeIndex: 1),
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
                        icon: Icons.menu_book_outlined,
                        glowColor: colors.secondaryContainer.withValues(
                          alpha: 0.5,
                        ),
                        iconSize: 100,
                        glowSize: 280,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sectionMargin),

                    // Title
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        'نمو روحي هادئ',
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
                        'مساحتك الخاصة للابتعاد عن ضجيج العالم. اكتشف مفهوم "الخلوة الرقمية" حيث تلتقي التكنولوجيا بالصمت المقدس لتعميق علاقتك مع الله.',
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

            // ── Bottom Actions ──
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerPadding,
                ).copyWith(bottom: AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      onPressed: onNext,
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.primaryContainer,
                        foregroundColor: colors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusFull,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                    const SizedBox(height: AppSpacing.componentGap),
                    OutlinedButton(
                      onPressed: onSkip,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.onSurface,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: colors.outline),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusFull,
                          ),
                        ),
                      ),
                      child: Text('تخطي', style: textTheme.labelLarge),
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
