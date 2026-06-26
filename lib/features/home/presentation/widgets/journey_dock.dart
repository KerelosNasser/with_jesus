import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../data/bible/bible_apps_repository.dart';
import '../../../../data/reading_journey/continue_reading_repository.dart';
import '../../../../domain/bible/bible_app.dart';
import '../../../../domain/bible/bible_randomizer_service.dart';

/// A stateful journey picker that lets the user roll random Bible-reading
/// categories. Styled per the Stitch "Quietude & Light" design system.
///
/// When [_isRolled] is false each card shows a hidden-state ("؟") and its
/// category label in [colors.outline]. Rolling reveals the icon + label in
/// [colors.primary]. The user can accept the suggestion or re-roll.
class JourneyDock extends ConsumerStatefulWidget {
  /// Creates a [JourneyDock].
  const JourneyDock({super.key});

  @override
  ConsumerState<JourneyDock> createState() => _JourneyDockState();
}

class _JourneyDockState extends ConsumerState<JourneyDock> {
  final BibleRandomizerService _randomizer = BibleRandomizerService();
  List<_ReadingResult> _results = [];
  bool get _isRolled => _results.isNotEmpty;

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
                  _buildCard(0, _categories[0], colors),
                  const SizedBox(width: AppSpacing.componentGap),
                  _buildCard(1, _categories[1], colors),
                  const SizedBox(width: AppSpacing.componentGap),
                  _buildCard(2, _categories[2], colors),
                  const SizedBox(width: AppSpacing.componentGap),
                  _buildCard(3, _categories[3], colors),
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
                onPressed: _onRoll,
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
                    onPressed: _onReRoll,
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
                    onPressed: _onAccept,
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

  /// Generates random readings for all 4 categories using
  /// [BibleRandomizerService] and updates the state to reveal them.
  void _onRoll() {
    final results = <_ReadingResult>[];
    final exclude = <String>{};
    for (final cat in _categories) {
      final result = _randomizer.randomForCategory(
        cat.label,
        exclude: exclude,
      );
      exclude.add('${result.book}:${result.chapter}');
      results.add(_ReadingResult(result.book, result.chapter));
    }
    setState(() => _results = results);
  }

  /// Resets the rolled state back to hidden cards.
  void _onReRoll() {
    setState(() {
      _results = [];
    });
  }

  /// Accepts the generated reading: saves the first (Old Testament) result
  /// to [ContinueReadingRepository], then launches YouVersion.
  Future<void> _onAccept() async {
    if (_results.isEmpty) return;

    // Save the first reading (Old Testament) as the "continue reading" point.
    final first = _results[0];
    await ref.read(continueReadingRepositoryProvider).upsert(
          book: first.book,
          chapter: first.chapter,
          verse: null,
          appUsed: 'youversion',
        );
    // Invalidate the continue-reading provider so the banner refreshes.
    ref.invalidate(continueReadingProvider);

    // Launch YouVersion.
    final youversion = kSupportedBibleApps.firstWhere(
      (app) => app.id == 'youversion',
    );
    final repo = BibleAppsRepository();
    final launched = await repo.launchApp(youversion);
    if (!launched && context.mounted) {
      await repo.openStore(youversion);
    }
  }

  Widget _buildCard(int index, _CategoryInfo category, ColorScheme colors) {
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
                if (_isRolled && index < _results.length) ...[
                  Icon(category.icon, size: 28, color: colors.primary),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _results[index].book,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'أصحاح ${_results[index].chapter}',
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.black54,
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

/// A generated reading result: the book name and chapter number.
class _ReadingResult {
  final String book;
  final int chapter;

  const _ReadingResult(this.book, this.chapter);
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
