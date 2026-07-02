import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations.dart';

/// A floating pill-shaped bottom navigation bar with 4 branch icons.
///
/// Used inside [AppShell] to switch between Home, Hymns, Journal, and Focus
/// branches of the [StatefulShellRoute].
class AppDock extends StatelessWidget {
  /// The navigation shell that manages the current branch index.
  final StatefulNavigationShell navigationShell;

  /// {@macro flutter.widgets.widget.key}
  const AppDock({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final branches = [
      _DockItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: l10n.homeTab,
        index: 0,
      ),
      _DockItem(
        icon: Icons.music_note_outlined,
        activeIcon: Icons.music_note,
        label: l10n.hymnsTab,
        index: 1,
      ),
      _DockItem(
        icon: Icons.book_outlined,
        activeIcon: Icons.book,
        label: l10n.journalTab,
        index: 2,
      ),
      _DockItem(
        icon: Icons.self_improvement_outlined,
        activeIcon: Icons.self_improvement,
        label: l10n.focusTab,
        index: 3,
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9999),
        color: theme.colorScheme.surfaceContainerHighest,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: branches.map((item) {
            final isSelected = navigationShell.currentIndex == item.index;
            return IconButton(
              icon: Icon(isSelected ? item.activeIcon : item.icon),
              tooltip: item.label,
              style: IconButton.styleFrom(
                foregroundColor: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              onPressed: () => navigationShell.goBranch(
                item.index,
                initialLocation: item.index == navigationShell.currentIndex,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _DockItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;

  const _DockItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
  });
}
