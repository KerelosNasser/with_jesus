import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations.dart';
import 'app_dock.dart';

/// Scaffold shell for [StatefulShellRoute] with [AppDock] at the bottom
/// and calm + detox icons in the AppBar.
class AppShell extends StatelessWidget {
  /// The navigation shell that manages the current branch index.
  final StatefulNavigationShell navigationShell;

  /// {@macro flutter.widgets.widget.key}
  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_outlined),
            tooltip: l10n.calmTitle,
            onPressed: () => context.go('/calm'),
          ),
          IconButton(
            icon: const Icon(Icons.phone_android_outlined),
            tooltip: l10n.detoxTitle,
            onPressed: () => context.go('/detox/session'),
          ),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: AppDock(navigationShell: navigationShell),
    );
  }
}
