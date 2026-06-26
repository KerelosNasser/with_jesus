import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../data/bible/bible_apps_repository.dart';
import '../../../../domain/bible/bible_app.dart';

/// A stateful journey picker that lets the user roll random Bible-reading
/// categories. Styled per the Stitch "Quietude & Light" design system.
///
/// When [_isRolled] is false each card shows a hidden-state ("؟") and its
/// category label in [colors.outline]. Rolling reveals the icon + label in
/// [colors.primary]. The user can accept the suggestion or re-roll.
class JourneyDock extends StatefulWidget {
  /// Creates a [JourneyDock].
  const JourneyDock({super.key});

  @override
  State<JourneyDock> createState() => _JourneyDockState();
}

class _JourneyDockState extends State<JourneyDock> {
  bool _isRolled = false;

  static const List<_CategoryInfo> _categories = [
    _CategoryInfo('العهد القديم', Icons.auto_stories),
    _CategoryInfo('العهد الجديد', Icons.menu_book),
    _CategoryInfo('مزامير داود', Icons.library_music),
    _CategoryInfo('الأنبياء', Icons.record_voice_over),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Text(
            'رحلة اليوم',
            style: textTheme.titleLarge?.copyWith(
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.componentGap),

          // ── Horizontal row of 4 fixed-size cards ──
          Center(
            child: SizedBox(
              height: 128,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCard(_categories[0], colors),
                  const SizedBox(width: AppSpacing.componentGap),
                  _buildCard(_categories[1], colors),
                  const SizedBox(width: AppSpacing.componentGap),
                  _buildCard(_categories[2], colors),
                  const SizedBox(width: AppSpacing.componentGap),
                  _buildCard(_categories[3], colors),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.componentGap),

          // ── Action Buttons ──
          if (!_isRolled)
            Center(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                ),
                onPressed: () => setState(() => _isRolled = true),
                icon: const Icon(Icons.casino),
                label: const Text('تدوير الرحلة'),
              ),
            )
          else
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.primary,
                      side: BorderSide(color: colors.primary),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                    ),
                    onPressed: () => setState(() => _isRolled = false),
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('إعادة التدوير'),
                  ),
                  const SizedBox(width: AppSpacing.componentGap),
                  FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                    ),
                    onPressed: () async {
                      final youversion = kSupportedBibleApps.firstWhere(
                        (app) => app.id == 'youversion',
                      );
                      final repo = BibleAppsRepository();
                      final launched = await repo.launchApp(youversion);
                      if (!launched && context.mounted) {
                        await repo.openStore(youversion);
                      }
                    },
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('قبول'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCard(_CategoryInfo category, ColorScheme colors) {
    return SizedBox(
      width: 80,
      height: 128,
      child: CustomPaint(
        foregroundPainter: _DashedBorderPainter(color: colors.outlineVariant),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isRolled) ...[
                  Icon(category.icon, size: 28, color: colors.primary),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    category.label,
                    style: TextStyle(
                      fontSize: 10,
                      color: colors.primary,
                    ),
                  ),
                ] else ...[
                  Text(
                    '؟',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: colors.outline,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    category.label,
                    style: TextStyle(
                      fontSize: 10,
                      color: colors.outline,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Holds a category label and its associated icon.
class _CategoryInfo {
  final String label;
  final IconData icon;

  const _CategoryInfo(this.label, this.icon);
}

/// Draws a dashed border around a rectangle with rounded corners.
///
/// Uses [Path.computeMetrics] to segment the rounded-rect path into
/// dashes. Matches the `border-2 border-dashed` Tailwind classes from
/// the Stitch design system.
class _DashedBorderPainter extends CustomPainter {
  final Color color;

  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(AppSpacing.radiusLg),
    );

    final path = Path()..addRRect(rrect);

    const dashWidth = 6.0;
    const dashGap = 4.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      color != oldDelegate.color;
}
