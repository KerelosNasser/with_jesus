import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/detox/presentation/detox_reflections_page.dart';
import '../../features/detox/presentation/detox_session_page.dart';
import '../../features/focus_retreat/focus_retreat.dart';
import '../../features/stress_relief/presentation/ambience_page.dart';
import '../../features/stress_relief/presentation/breathing_exercise_page.dart';
import '../../features/stress_relief/presentation/calm_tools_page.dart';
import '../../features/stress_relief/presentation/prayer_timer_page.dart';
import '../../features/home/home.dart';
import '../../features/hymns/hymns.dart';
import '../../features/journal/journal.dart';
import '../../features/onboarding/onboarding.dart';
import '../../features/settings/settings.dart';
import '../../shared/widgets/app_shell.dart';

/// App router using go_router with [StatefulShellRoute.indexedStack].
///
/// Routes inside the shell (with bottom nav):
///   /home           → Home screen
///   /home/settings  → Settings screen
///   /hymns          → Hymns screen
///   /journal        → Journal list screen
///   /journal/composer → Journal composer screen
///   /focus-retreat  → Focus retreat screen
///
/// Routes outside the shell (fullscreen):
///   /               → Onboarding flow
///   /detox/session  → Detox session
///   /detox/reflections → Detox reflections
///   /calm           → Calm tools hub
///   /calm/breathe   → Breathing exercise
///   /calm/prayer    → Prayer timer
///   /calm/ambience  → Ambient sounds
final class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _homeNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'home');
  static final _hymnsNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'hymns');
  static final _journalNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'journal');
  static final _focusNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'focus');

  static GoRouter get router => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: _RoutePaths.onboarding,
        routes: [
          // ── Fullscreen routes (outside shell) ──
          GoRoute(
            path: _RoutePaths.onboarding,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const OnboardingPage(),
          ),
          GoRoute(
            path: _RoutePaths.detoxSession,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const DetoxSessionPage(),
          ),
          GoRoute(
            path: _RoutePaths.detoxReflections,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const DetoxReflectionsPage(),
          ),
          GoRoute(
            path: _RoutePaths.calm,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const CalmToolsPage(),
          ),
          GoRoute(
            path: _RoutePaths.calmBreathe,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const BreathingExercisePage(),
          ),
          GoRoute(
            path: _RoutePaths.calmPrayer,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const PrayerTimerPage(),
          ),
          GoRoute(
            path: _RoutePaths.calmAmbience,
            parentNavigatorKey: _rootNavigatorKey,
            builder: (context, state) => const AmbiencePage(),
          ),

          // ── Main shell with 4 branches ──
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) {
              return AppShell(navigationShell: navigationShell);
            },
            branches: [
              // Branch 0: Home
              StatefulShellBranch(
                navigatorKey: _homeNavigatorKey,
                routes: [
                  GoRoute(
                    path: _RoutePaths.home,
                    builder: (context, state) => const HomePage(),
                    routes: [
                      GoRoute(
                        path: 'settings',
                        builder: (context, state) => const SettingsPage(),
                      ),
                    ],
                  ),
                ],
              ),

              // Branch 1: Hymns
              StatefulShellBranch(
                navigatorKey: _hymnsNavigatorKey,
                routes: [
                  GoRoute(
                    path: _RoutePaths.hymns,
                    builder: (context, state) => const HymnsPage(),
                  ),
                ],
              ),

              // Branch 2: Journal
              StatefulShellBranch(
                navigatorKey: _journalNavigatorKey,
                routes: [
                  GoRoute(
                    path: _RoutePaths.journal,
                    builder: (context, state) => const JournalListPage(),
                    routes: [
                      GoRoute(
                        path: 'composer',
                        builder: (context, state) {
                          final idStr = state.uri.queryParameters['id'];
                          return JournalComposerPage(
                            entryId:
                                idStr != null ? int.tryParse(idStr) : null,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),

              // Branch 3: Focus
              StatefulShellBranch(
                navigatorKey: _focusNavigatorKey,
                routes: [
                  GoRoute(
                    path: _RoutePaths.focusRetreat,
                    builder: (context, state) => const FocusRetreatPage(),
                  ),
                ],
              ),
            ],
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
  static const focusRetreat = '/focus-retreat';
  static const detoxSession = '/detox/session';
  static const detoxReflections = '/detox/reflections';
  static const calm = '/calm';
  static const calmBreathe = '/calm/breathe';
  static const calmPrayer = '/calm/prayer';
  static const calmAmbience = '/calm/ambience';
}
