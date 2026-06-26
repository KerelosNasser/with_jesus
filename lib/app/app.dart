import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/l10n/app_localizations.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';

/// Root widget for مع يسوع.
///
/// Wraps [MaterialApp.router] with Arabic-first localization, light/dark/candlelight
/// theming, and Riverpod integration for future reactive theme switching.
class WithJesusApp extends ConsumerWidget {
  const WithJesusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ar'),
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: AppTheme.themeData(AppThemeMode.light),
      darkTheme: AppTheme.themeData(AppThemeMode.dark),
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
