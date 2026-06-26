import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const WithJesusApp());
}

class WithJesusApp extends StatelessWidget {
  const WithJesusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'مع يسوع',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'AE'),
        Locale('ar', 'SA'),
      ],
      locale: const Locale('ar', 'AE'),
      theme: AppTheme.themeData(AppThemeMode.light),
      darkTheme: AppTheme.themeData(AppThemeMode.dark),
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
