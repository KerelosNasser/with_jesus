import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../shared/widgets/widgets.dart';

/// Home screen — the main hub of مع يسوع.
///
/// Displays a greeting, quick navigation cards (daily verse, hymns, focus
/// retreat, journal), and a top bar with menu/profile actions.
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
            floating: false,
            backgroundColor: colors.surface,
            foregroundColor: colors.primary,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: Icon(Icons.menu, color: colors.primary),
              onPressed: () {},
            ),
            title: Text(
              'مع يسوع',
              style: textTheme.headlineMedium?.copyWith(
                color: colors.primary,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.account_circle_outlined, color: colors.primary),
                onPressed: () {},
              ),
            ],
          ),

          // ── Greeting Header ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.containerPadding,
              ).copyWith(top: AppSpacing.lg, bottom: AppSpacing.xxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'صباح الخير',
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'دعنا نبدأ يومك بكلمة الله',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Feature Cards Grid ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.containerPadding,
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.sm,
                crossAxisSpacing: AppSpacing.sm,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _FeatureCard(item: _featureItems[index]),
                childCount: _featureItems.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Feature card data & widget
// ─────────────────────────────────────────────────────────────────────────────

/// Data for a single feature card on the home screen.
class _FeatureItem {
  final String label;
  final IconData icon;

  const _FeatureItem({required this.label, required this.icon});
}

/// The four home-screen feature cards.
const _featureItems = <_FeatureItem>[
  _FeatureItem(label: 'آية اليوم', icon: Icons.menu_book),
  _FeatureItem(label: 'الألحان', icon: Icons.music_note),
  _FeatureItem(label: 'خلوة التركيز', icon: Icons.self_improvement),
  _FeatureItem(label: 'المذكرات', icon: Icons.book),
];

/// A single feature card: icon + label inside a [SurfaceCard].
class _FeatureCard extends StatelessWidget {
  final _FeatureItem item;

  const _FeatureCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SurfaceCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, size: 36, color: colors.primary),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.label,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
