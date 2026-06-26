import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

/// A hero card displaying the verse of the day ("آية اليوم"), styled in
/// Stitch "Quietude & Light" — warm parchment surface, dark olive accents.
class VerseCard extends StatelessWidget {
  const VerseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerPadding,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Stack(
        children: [
          // ─── Card body ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header: book icon + "آية اليوم" ──
                Row(
                  children: [
                    Icon(
                      Icons.menu_book,
                      size: 20,
                      color: colors.primaryContainer,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'آية اليوم',
                      style: textTheme.labelLarge?.copyWith(
                        color: colors.primaryContainer,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg), // mb-4

                // ── Verse text ──
                Text(
                  'لا تخف لأني معك. لا تتلفت لأني إلهك. قد أيدتك وأعنتك وعضدتك بيمين بري.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl), // mb-6

                // ── Footer: reference + share button ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'إشعياء ٤١: ١٠',
                      style: textTheme.labelLarge?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.share,
                        color: colors.primaryContainer,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('مشاركة')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Decorative gradient line at top ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: AppSpacing.xs, // h-1 = 4px
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    colors.primaryContainer.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
