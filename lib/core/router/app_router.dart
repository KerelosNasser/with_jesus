import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/home.dart';
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
            path: _RoutePaths.settings,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      );
}

abstract final class _RoutePaths {
  _RoutePaths._();

  static const onboarding = '/';
  static const home = '/home';
  static const settings = '/settings';
}
