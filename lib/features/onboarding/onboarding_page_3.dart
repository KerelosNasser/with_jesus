import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import 'widgets/onboarding_widgets.dart';

/// Onboarding Page 3: "ابدأ رحلتك اليوم"
///
/// The final onboarding page with a centered illustration,
/// title + body, a prominent "ابدأ الآن" button, and pagination dots.
class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // ── Ambient Corners ──
            Positioned(
              top: -100,
              right: -100,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 64, sigmaY: 64),
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surfaceContainerLow.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -100,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 64, sigmaY: 64),
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surfaceContainerLow.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),

            // ── Main Content ──
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.containerPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 1),

                  // ── Illustration ──
                  const FadeInUp(
                    child: MonasticIllustration(
                      icon: Icons.favorite,
                      iconSize: 100,
                      glowSize: 280,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.sectionMargin),

                  // ── Typography ──
                  FadeInUp(
                    delay: const Duration(milliseconds: 100),
                    child: Text(
                      'ابدأ رحلتك اليوم',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium?.copyWith(
                        color: colors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.componentGap),
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      'اكتشف الهدوء الداخلي وابدأ مسيرتك الروحية في بيئة خالية من المشتتات.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // ── Action Button ──
                  FadeInUp(
                    delay: const Duration(milliseconds: 300),
                    child: FilledButton(
                      onPressed: onStart,
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.primaryContainer,
                        foregroundColor: colors.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
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
                          Text(
                            'ابدأ الآن',
                            style: textTheme.labelLarge?.copyWith(
                              color: colors.onPrimary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward,
                            size: 20,
                            color: colors.onPrimary,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxl),

                  // ── Pagination Dots ──
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    child: OnboardingDots(
                      count: 3,
                      activeIndex: 2,
                      activeColor: colors.primaryContainer,
                    ),
                  ),

                  const Spacer(flex: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
