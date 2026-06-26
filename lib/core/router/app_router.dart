import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/focus_retreat/focus_retreat.dart';
import '../../features/home/home.dart';
import '../../features/hymns/hymns.dart';
import '../../features/journal/journal.dart';
import '../../features/onboarding/onboarding.dart';
import '../../features/settings/settings.dart';

/// App router using go_router.
///
/// Routes:
///   /           → Onboarding flow (3 pages)
///   /settings   → Settings screen
final class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: _RoutePaths.onboarding,
        routes: [
          GoRoute(
            path: _RoutePaths.onboarding,
            builder: (context, state) => const OnboardingPage(),
          ),
          GoRoute(
            path: _RoutePaths.home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: _RoutePaths.hymns,
            builder: (context, state) => const HymnsPage(),
          ),
          GoRoute(
            path: _RoutePaths.settings,
            builder: (context, state) => const SettingsPage(),
          ),
          // ── Journal ──
          GoRoute(
            path: _RoutePaths.journal,
            builder: (context, state) => const JournalListPage(),
            routes: [
              GoRoute(
                path: 'composer',
                builder: (context, state) {
                  final idStr = state.uri.queryParameters['id'];
                  return JournalComposerPage(
                    entryId: idStr != null ? int.tryParse(idStr) : null,
                  );
                },
              ),
            ],
          ),

          // ── Fullscreen: outside bottom-nav shell ──
          GoRoute(
            path: _RoutePaths.focusRetreat,
            builder: (context, state) => const FocusRetreatPage(),
          ),
        ],
      );
}

abstract final class _RoutePaths {
  _RoutePaths._();

  static const onboarding = '/';
  static const home = '/home';
  static const hymns = '/hymns';
  static const journal = '/journal';
  static const settings = '/settings';
  static const focusRetreat = '/focus-retreat';
}
