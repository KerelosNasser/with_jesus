import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import 'presentation/widgets/bible_apps_launcher.dart';
import 'presentation/widgets/continue_reading_banner.dart';
import 'presentation/widgets/journey_dock.dart';
import 'presentation/widgets/verse_card.dart';

/// Home screen — the main hub of مع يسوع.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: CustomScrollView(
        slivers: [
          // ── TopAppBar ──
          SliverAppBar(
            pinned: true,
            backgroundColor: colors.surface,
            foregroundColor: colors.primary,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.menu, color: colors.primary),
              onPressed: () {},
            ),
            title: Text(
              'مع يسوع',
              style: textTheme.headlineMedium?.copyWith(color: colors.primary),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.account_circle_outlined, color: colors.primary),
                onPressed: () {},
              ),
            ],
          ),

          // ── Hero VerseCard ──
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.lg),
              child: VerseCard(),
            ),
          ),

          // ── Continue Reading Banner ──
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.lg),
              child: ContinueReadingBanner(),
            ),
          ),

          // ── Bible Apps Launcher ──
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xl),
              child: BibleAppsLauncher(),
            ),
          ),

          // ── Hymns Card ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: _HymnsCard(),
            ),
          ),

          // ── Journal Card ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: _JournalCard(),
            ),
          ),

          // ── Focus Retreat Card ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: _FocusRetreatCard(),
            ),
          ),

          // ── Journey Dock ──
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xxl),
              child: JourneyDock(),
            ),
          ),
        ],
      ),
    );
  }
}

/// A card linking to the Focus Retreat screen.
///
/// Displayed on the home page so users can start a distraction-free
/// meditation session.
class _FocusRetreatCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerPadding,
      ),
      child: Card(
        color: colors.surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          side: BorderSide(color: colors.surfaceContainerHighest),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          onTap: () => context.push('/focus-retreat'),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Icon(Icons.self_improvement,
                    color: colors.primary, size: 28),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'خلوة التركيز',
                        style: textTheme.titleMedium?.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'فترة تأمل بلا تشتيت',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_left, color: colors.outline),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A card linking to the Spiritual Journal screen.
///
/// Displayed on the home page so users can quickly access their personal
/// journal for reflections, prayers, and gratitude entries.
class _JournalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerPadding,
      ),
      child: Card(
        color: colors.surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          side: BorderSide(color: colors.surfaceContainerHighest),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          onTap: () => context.push('/journal'),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Icon(Icons.edit_document,
                    color: colors.primary, size: 28),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'المفكرة الروحية',
                        style: textTheme.titleMedium?.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'تأملاتك وصلواتك الشخصية',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_left, color: colors.outline),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A card linking to the Hymns screen.
///
/// Displayed prominently on the home page so users can quickly access
/// liturgical audio.
class _HymnsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerPadding,
      ),
      child: Card(
        color: colors.surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          side: BorderSide(color: colors.surfaceContainerHighest),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          onTap: () => context.push('/hymns'),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Icon(Icons.music_note, color: colors.primary, size: 28),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الألحان',
                        style: textTheme.titleMedium?.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'الترانيم والتسبحة',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_left, color: colors.outline),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
