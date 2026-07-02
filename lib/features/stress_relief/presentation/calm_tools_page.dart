import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_spacing.dart';
import 'providers/ambience_player_provider.dart';

/// Hub page with a 2×2 grid of calm tools.
///
/// Landing page when the user taps the calm icon in the AppBar.
class CalmToolsPage extends ConsumerWidget {
  /// Creates a [CalmToolsPage].
  const CalmToolsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final ambienceState = ref.watch(ambiencePlayerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.calmTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.lg,
          crossAxisSpacing: AppSpacing.lg,
          childAspectRatio: 1.0,
          children: [
            _ToolCard(
              icon: Icons.air,
              label: l.calmBreathe,
              onTap: () => context.go('/calm/breathe'),
            ),
            _ToolCard(
              icon: Icons.church_outlined,
              label: l.calmPrayer,
              onTap: () => context.go('/calm/prayer'),
            ),
            _ToolCard(
              icon: Icons.music_note_outlined,
              label: l.calmAmbience,
              onTap: () => context.go('/calm/ambience'),
              badge: ambienceState.isPlaying,
            ),
            const _PlaceholderCard(),
          ],
        ),
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 48, color: theme.colorScheme.primary),
                  const SizedBox(height: AppSpacing.sm),
                  Text(label, style: theme.textTheme.titleMedium),
                ],
              ),
            ),
            if (badge)
              PositionedDirectional(
                top: AppSpacing.sm,
                end: AppSpacing.sm,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outline
              .withValues(alpha: 0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: const SizedBox.expand(),
    );
  }
}
