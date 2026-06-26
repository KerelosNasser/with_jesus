# M1 Core Architecture Completion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Complete the remaining components of Milestone 1 (M1), including the localized app shell, Drift database setup, bootstrap flow, and native channel skeleton.

**Architecture:** We will extract the app shell into `lib/app/app.dart` to keep `main.dart` clean, set up Flutter `intl` code generation, define a foundational Drift database, and scaffold the Dart/Kotlin native channel registry for future features.

**Tech Stack:** Flutter, Riverpod, Drift (SQLite), GoRouter, intl.

---

### Task 1: App Shell Extraction and Bootstrap

**Files:**
- Create: `lib/app/app.dart`
- Create: `lib/app/bootstrap.dart`
- Modify: `lib/main.dart`

- [ ] **Step 1: Extract `WithJesusApp` to `app.dart`**
Move the `WithJesusApp` class from `lib/main.dart` into `lib/app/app.dart` to keep the entry point clean. Wrap it in a `ConsumerWidget` (Riverpod) so it can eventually watch a theme provider.

```dart
// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';

class WithJesusApp extends ConsumerWidget {
  const WithJesusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'مع يسوع',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      locale: const Locale('ar'),
      theme: AppTheme.themeData(AppThemeMode.light),
      darkTheme: AppTheme.themeData(AppThemeMode.dark),
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
```

- [ ] **Step 2: Create Bootstrap class**
Create `lib/app/bootstrap.dart` to initialize async dependencies before running the app.

```dart
// lib/app/bootstrap.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Bootstrap {
  static Future<ProviderContainer> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Future: init Drift, secure storage, prefs, audio handler here
    
    return ProviderContainer(
      overrides: [
        // Future: provide initialized singletons here
      ],
    );
  }
}
```

- [ ] **Step 3: Update main.dart**
Modify `lib/main.dart` to use `Bootstrap` and `UncontrolledProviderScope`.

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/bootstrap.dart';

void main() async {
  final container = await Bootstrap.init();
  
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const WithJesusApp(),
    ),
  );
}
```

- [ ] **Step 4: Verify Compilation**
Run: `flutter analyze`
Expected: PASS

- [ ] **Step 5: Commit**
```bash
git add lib/main.dart lib/app/app.dart lib/app/bootstrap.dart
git commit -m "feat(core): extract app shell and setup bootstrap"
```

### Task 2: Localization Scaffolding (intl)

**Files:**
- Create: `l10n.yaml`
- Create: `lib/core/l10n/app_ar.arb`
- Create: `lib/core/l10n/app_en.arb`
- Modify: `lib/app/app.dart`

- [ ] **Step 1: Setup l10n.yaml**
Create `l10n.yaml` in the project root to configure localization generation.

```yaml
# l10n.yaml
arb-dir: lib/core/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
untranslated-messages-file: l10n_errors.txt
```

- [ ] **Step 2: Create English ARB**
Create `lib/core/l10n/app_en.arb` with basic keys.

```json
{
  "@@locale": "en",
  "appTitle": "With Jesus",
  "@appTitle": {
    "description": "The title of the application"
  }
}
```

- [ ] **Step 3: Create Arabic ARB**
Create `lib/core/l10n/app_ar.arb` with basic keys.

```json
{
  "@@locale": "ar",
  "appTitle": "مع يسوع"
}
```

- [ ] **Step 4: Generate and Wire up Localization**
Run: `flutter gen-l10n` to generate the code.
Then modify `lib/app/app.dart` to use `AppLocalizations`.

```dart
// In lib/app/app.dart, add import:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Inside MaterialApp.router, update localizationsDelegates and supportedLocales:
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
```

- [ ] **Step 5: Verify Compilation**
Run: `flutter analyze`
Expected: PASS

- [ ] **Step 6: Commit**
```bash
git add l10n.yaml lib/core/l10n/ lib/app/app.dart
git commit -m "feat(core): setup intl localization scaffolding"
```

### Task 3: Drift AppDatabase Skeleton

**Files:**
- Create: `lib/data/database/app_database.dart`

- [ ] **Step 1: Define AppDatabase class**
Create the initial Drift database with an empty schema version 1.

```dart
// lib/data/database/app_database.dart
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle future schema migrations
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'with_jesus.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    
    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
```

- [ ] **Step 2: Generate Drift code**
Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: `app_database.g.dart` generated successfully.

- [ ] **Step 3: Verify Compilation**
Run: `flutter analyze`
Expected: PASS

- [ ] **Step 4: Commit**
```bash
git add lib/data/database/
git commit -m "feat(data): setup drift AppDatabase skeleton"
```

### Task 4: Native Platform Channel Skeleton

**Files:**
- Create: `lib/native/channels/platform_channel_registry.dart`
- Create: `android/app/src/main/kotlin/com/example/with_jesus/native/PlatformChannelRegistry.kt`
- Modify: `android/app/src/main/kotlin/com/example/with_jesus/MainActivity.kt`

- [ ] **Step 1: Create Dart Registry**
Create `lib/native/channels/platform_channel_registry.dart` to centralize channel definitions.

```dart
// lib/native/channels/platform_channel_registry.dart
import 'package:flutter/services.dart';

class PlatformChannelRegistry {
  // Method Channels
  static const MethodChannel intentChannel = MethodChannel('app/native/intent');
  static const MethodChannel mediaStoreChannel = MethodChannel('app/native/mediastore');
  static const MethodChannel launcherChannel = MethodChannel('app/native/launcher');
  static const MethodChannel usageStatsChannel = MethodChannel('app/native/usage_stats');
  static const MethodChannel overlayChannel = MethodChannel('app/native/overlay');
  static const MethodChannel hapticsChannel = MethodChannel('app/native/haptics');
  
  // Event Channels can be added here
}
```

- [ ] **Step 2: Create Kotlin Registry**
Create the Kotlin counterpart in Android code. Make sure the package name matches (`com.example.with_jesus` or whatever is in your `MainActivity.kt`).

```kotlin
// android/app/src/main/kotlin/com/example/with_jesus/native/PlatformChannelRegistry.kt
package com.example.with_jesus.native

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object PlatformChannelRegistry {
    private const val INTENT_CHANNEL = "app/native/intent"
    private const val MEDIA_STORE_CHANNEL = "app/native/mediastore"
    private const val LAUNCHER_CHANNEL = "app/native/launcher"
    private const val USAGE_STATS_CHANNEL = "app/native/usage_stats"
    private const val OVERLAY_CHANNEL = "app/native/overlay"
    private const val HAPTICS_CHANNEL = "app/native/haptics"

    fun registerChannels(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, INTENT_CHANNEL).setMethodCallHandler { call, result ->
            result.notImplemented()
        }
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MEDIA_STORE_CHANNEL).setMethodCallHandler { call, result ->
            result.notImplemented()
        }
        
        // Register others similarly...
    }
}
```

- [ ] **Step 3: Wire to MainActivity**
Update `MainActivity.kt` to initialize the channels.

```kotlin
// android/app/src/main/kotlin/com/example/with_jesus/MainActivity.kt
package com.example.with_jesus

import com.example.with_jesus.native.PlatformChannelRegistry
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        PlatformChannelRegistry.registerChannels(flutterEngine)
    }
}
```

- [ ] **Step 4: Verify Build**
Run: `flutter build apk --debug` to ensure Android compiles cleanly.

- [ ] **Step 5: Commit**
```bash
git add lib/native/ android/app/src/main/kotlin/com/example/with_jesus/
git commit -m "feat(native): setup platform channel registry skeleton"
```
