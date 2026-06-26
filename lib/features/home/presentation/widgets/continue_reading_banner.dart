import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../data/bible/bible_apps_repository.dart';
import '../../../../data/database/app_database.dart';
import '../../../../data/reading_journey/continue_reading_repository.dart';
import '../../../../domain/bible/bible_app.dart';

/// Banner that shows the user's last-read Bible passage so they can resume.
///
/// Reads from [continueReadingProvider] reactively. When no previous reading
/// exists a calm empty state is displayed. Pressing "متابعة" launches the
/// Bible app that was used for that reading.
class ContinueReadingBanner extends ConsumerWidget {
  const ContinueReadingBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final asyncReading = ref.watch(continueReadingProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerPadding,
      ),
      child: asyncReading.when(
        data: (reading) {
          if (reading == null) return _buildEmptyState(colors);
          return _buildReadingCard(reading, colors, context, ref);
        },
        loading: () => _buildEmptyState(colors),
        error: (error, stack) => _buildEmptyState(colors),
      ),
    );
  }

  /// Calm empty state shown when no previous reading has been saved.
  Widget _buildEmptyState(ColorScheme colors) {
    return Card(
      elevation: 0,
      color: colors.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        leading: Icon(Icons.menu_book, color: colors.outline),
        title: Text(
          'لا يوجد قراءة سابقة',
          style: TextStyle(color: colors.onSurfaceVariant),
        ),
        subtitle: Text(
          'ابدأ رحلة اليوم للقراءة',
          style: TextStyle(
            color: colors.onSurfaceVariant.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  /// Card showing the saved reading with a "متابعة" resume button.
  Widget _buildReadingCard(
    ContinueReadingData reading,
    ColorScheme colors,
    BuildContext context,
    WidgetRef ref,
  ) {
    final subtitle = reading.verse != null
        ? '${reading.book} - الأصحاح ${reading.chapter} : الآية ${reading.verse}'
        : '${reading.book} - الأصحاح ${reading.chapter}';

    return Card(
      elevation: 0,
      color: colors.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        leading: Icon(Icons.menu_book, color: colors.primary),
        title: const Text('متابعة القراءة'),
        subtitle: Text(subtitle),
        trailing: FilledButton.tonal(
          onPressed: () => _onResume(reading, context),
          child: const Text('متابعة'),
        ),
      ),
    );
  }

  /// Launches the Bible app that was used for the saved reading.
  Future<void> _onResume(ContinueReadingData reading, BuildContext context) async {
    final app = kSupportedBibleApps.firstWhere(
      (a) => a.id == reading.appUsed,
      orElse: () => kSupportedBibleApps.first,
    );
    final repo = BibleAppsRepository();
    final launched = await repo.launchApp(app);
    if (!launched && context.mounted) {
      await repo.openStore(app);
    }
  }
}
