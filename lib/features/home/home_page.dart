import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import 'presentation/widgets/continue_reading_banner.dart';
import 'presentation/widgets/journey_grid.dart';
import 'presentation/widgets/shortcuts_row.dart';
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

          // ── Shortcuts Row ──
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xl),
              child: ShortcutsRow(),
            ),
          ),

          // ── Continue Reading Banner ──
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xl),
              child: ContinueReadingBanner(),
            ),
          ),

          // ── Randomized Journey Grid ──
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xxl),
              child: JourneyGrid(),
            ),
          ),
        ],
      ),
    );
  }
}
