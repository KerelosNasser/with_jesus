# M3 Bible Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or execute tasks sequentially.

**Goal:** Build the Android native channel and Dart domain layer to detect, launch, and install Orthodox Bible apps from the M2 Journey Grid.

**Architecture:** Kotlin `AppIntentChannel.kt` handles Android package queries and intent launches. Dart wrapper plus a lightweight domain model and repository expose the functionality. The M2 Journey Grid's dialog gets a "Read" button that calls into this service.

**Tech Stack:** Kotlin, Dart, Android Platform Channels (method), Material 3

---

### Task 1: Kotlin AppIntentChannel (native)

**Files:**
- Create: `android/app/src/main/kotlin/com/example/with_jesus/native/AppIntentChannel.kt`

- [ ] **Create AppIntentChannel.kt** — A standalone Kotlin class that implements `MethodChannel.MethodCallHandler` with the `app/native/intent` channel name. It handles three methods:

```kotlin
package com.example.with_jesus.native

import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class AppIntentChannel(private val context: Context) : MethodCallHandler {

    companion object {
        private const val CHANNEL = "app/native/intent"
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "isInstalled" -> {
                val package = call.argument<String>("package") ?: run {
                    result.error("INVALID_ARGS", "Missing 'package' argument", null)
                    return
                }
                result.success(isPackageInstalled(package))
            }
            "launch" -> {
                val package = call.argument<String>("package") ?: run {
                    result.error("INVALID_ARGS", "Missing 'package' argument", null)
                    return
                }
                val deepRef = call.argument<String>("deepRef")
                val launched = launchPackage(package, deepRef)
                result.success(launched)
            }
            "openStore" -> {
                val package = call.argument<String>("package") ?: run {
                    result.error("INVALID_ARGS", "Missing 'package' argument", null)
                    return
                }
                openPlayStore(package)
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    private fun isPackageInstalled(packageName: String): Boolean {
        return try {
            context.packageManager.getPackageInfo(packageName, 0)
            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }

    private fun launchPackage(packageName: String, deepRef: String?): Boolean {
        // Try deep link first if provided
        if (deepRef != null) {
            val deepIntent = Intent(Intent.ACTION_VIEW, Uri.parse(deepRef)).apply {
                `package` = packageName
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            if (deepIntent.resolveActivity(context.packageManager) != null) {
                context.startActivity(deepIntent)
                return true
            }
        }

        // Fallback to basic launch
        return try {
            val launchIntent = context.packageManager.getLaunchIntentForPackage(packageName)
            if (launchIntent != null) {
                context.startActivity(launchIntent)
                true
            } else {
                false
            }
        } catch (e: ActivityNotFoundException) {
            false
        }
    }

    private fun openPlayStore(packageName: String) {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=$packageName")).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        try {
            context.startActivity(intent)
        } catch (e: ActivityNotFoundException) {
            // Fallback to browser Play Store
            val webIntent = Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=$packageName")).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            context.startActivity(webIntent)
        }
    }
}
```

Partial commit: `git add -A && git commit -m "feat(native): create AppIntentChannel kotlin handler"`

### Task 2: Wire AppIntentChannel into PlatformChannelRegistry

**Files:**
- Modify: `android/app/src/main/kotlin/com/example/with_jesus/native/PlatformChannelRegistry.kt`

- [ ] **Update PlatformChannelRegistry.kt** — Replace the `INTENT_CHANNEL`'s `result.notImplemented()` with a delegate to `AppIntentChannel`. The method now accepts a `context: Context` parameter to pass to the channel.

```kotlin
package com.example.with_jesus.native

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object PlatformChannelRegistry {
    private const val INTENT_CHANNEL = "app/native/intent"
    private const val MEDIA_STORE_CHANNEL = "app/native/mediastore"
    private const val LAUNCHER_CHANNEL = "app/native/launcher"
    private const val USAGE_STATS_CHANNEL = "app/native/usage_stats"
    private const val OVERLAY_CHANNEL = "app/native/overlay"
    private const val HAPTICS_CHANNEL = "app/native/haptics"

    fun registerChannels(flutterEngine: FlutterEngine, context: Context) {
        val intentChannel = AppIntentChannel(context)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, INTENT_CHANNEL).setMethodCallHandler(intentChannel)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MEDIA_STORE_CHANNEL).setMethodCallHandler { call, result ->
            result.notImplemented()
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, LAUNCHER_CHANNEL).setMethodCallHandler { call, result ->
            result.notImplemented()
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, USAGE_STATS_CHANNEL).setMethodCallHandler { call, result ->
            result.notImplemented()
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, OVERLAY_CHANNEL).setMethodCallHandler { call, result ->
            result.notImplemented()
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, HAPTICS_CHANNEL).setMethodCallHandler { call, result ->
            result.notImplemented()
        }
    }
}
```

Then update `android/app/src/main/kotlin/com/example/with_jesus/MainActivity.kt` to pass the activity as context:

```kotlin
override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    PlatformChannelRegistry.registerChannels(flutterEngine, this)
}
```

- [ ] **Verify: Run `flutter build apk --debug`** — should pass with no errors.

Partial commit: `git add -A && git commit -m "feat(native): wire AppIntentChannel into PlatformChannelRegistry"`

### Task 3: Dart AppIntentChannel Wrapper + BibleApp Model

**Files:**
- Create: `lib/native/channels/app_intent_channel.dart`
- Create: `lib/domain/bible/bible_app.dart`
- Create: `lib/domain/bible/bible_randomizer_service.dart`

- [ ] **Create `app_intent_channel.dart`** — Dart wrapper that calls the Android channel's 3 methods:

```dart
// lib/native/channels/app_intent_channel.dart
import 'package:flutter/services.dart';
import '../platform_channel_registry.dart' as registry;

class AppIntentChannel {
  static const _channel = registry.PlatformChannelRegistry.intentChannel;

  static Future<bool> isInstalled(String package) async {
    try {
      final result = await _channel.invokeMethod<bool>('isInstalled', {'package': package});
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> launch(String package, {String? deepRef}) async {
    try {
      final args = <String, dynamic>{'package': package};
      if (deepRef != null) args['deepRef'] = deepRef;
      final result = await _channel.invokeMethod<bool>('launch', args);
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> openStore(String package) async {
    try {
      await _channel.invokeMethod<void>('openStore', {'package': package});
    } catch (e) {
      // Silent fail
    }
  }
}
```

- [ ] **Create `bible_app.dart`** — Pure Dart model:

```dart
// lib/domain/bible/bible_app.dart
class BibleApp {
  final String id;
  final String label;
  final String packageId;
  final String? iconAsset;

  const BibleApp({
    required this.id,
    required this.label,
    required this.packageId,
    this.iconAsset,
  });
}

/// The 3 supported Orthodox Bible apps.
const kSupportedBibleApps = [
  BibleApp(
    id: 'catena',
    label: 'Catena Bible',
    packageId: 'com.catena',
  ),
  BibleApp(
    id: 'coptic_reader',
    label: 'Coptic Reader',
    packageId: 'com.app.copticreader',
  ),
  BibleApp(
    id: 'orsozoxi',
    label: 'أرثوذكسى + القطمارس',
    packageId: 'coptic.avabishoy.katamars',
  ),
];
```

- [ ] **Create `bible_randomizer_service.dart`** — Maps the 4 journey categories to book/chapter ranges:

```dart
// lib/domain/bible/bible_randomizer_service.dart
import 'dart:math';

class BibleRandomizerService {
  final Random _random;

  BibleRandomizerService({Random? random}) : _random = random ?? Random();

  /// Returns a random {book: String, chapter: int} for the given category.
  ({String book, int chapter}) randomForCategory(String category) {
    final entry = _categoryMap[category];
    if (entry == null) return (book: 'مزامير', chapter: 1);

    final book = entry.books[_random.nextInt(entry.books.length)];
    final maxChapter = book.maxChapter;
    final chapter = _random.nextInt(maxChapter) + 1;
    return (book: book.name, chapter: chapter);
  }
}

class _Book {
  final String name;
  final int maxChapter;
  const _Book(this.name, this.maxChapter);
}

class _CategoryEntry {
  final List<_Book> books;
  const _CategoryEntry(this.books);
}

const _categoryMap = {
  'العهد القديم': _CategoryEntry([
    _Book('التكوين', 50), _Book('الخروج', 40), _Book('اللاويين', 27),
    _Book('العدد', 36), _Book('التثنية', 34), _Book('يشوع', 24),
    _Book('القضاة', 21), _Book('راعوث', 4), _Book('صموئيل الأول', 31),
    _Book('صموئيل الثاني', 24), _Book('الملوك الأول', 22), _Book('الملوك الثاني', 25),
    _Book('أخبار الأيام الأول', 29), _Book('أخبار الأيام الثاني', 36),
    _Book('عزرا', 10), _Book('نحميا', 13), _Book('أستير', 10),
    _Book('أيوب', 42), _Book('الأمثال', 31), _Book('الجامعة', 12),
    _Book('نشيد الأنشاد', 8),
  ]),
  'العهد الجديد': _CategoryEntry([
    _Book('متى', 28), _Book('مرقس', 16), _Book('لوقا', 24),
    _Book('يوحنا', 21), _Book('أعمال الرسل', 28), _Book('رومية', 16),
    _Book('كورنثوس الأولى', 16), _Book('كورنثوس الثانية', 13),
    _Book('غلاطية', 6), _Book('أفسس', 6), _Book('فيلبي', 4),
    _Book('كولوسي', 4), _Book('تسالونيكي الأولى', 5), _Book('تسالونيكي الثانية', 3),
    _Book('تيموثاوس الأولى', 6), _Book('تيموثاوس الثانية', 4),
    _Book('تيطس', 3), _Book('فليمون', 1), _Book('عبرانيين', 13),
    _Book('يعقوب', 5), _Book('بطرس الأولى', 5), _Book('بطرس الثانية', 3),
    _Book('يوحنا الأولى', 5), _Book('يوحنا الثانية', 1), _Book('يوحنا الثالثة', 1),
    _Book('يهوذا', 1), _Book('الرؤيا', 22),
  ]),
  'مزامير داود': _CategoryEntry([
    _Book('المزامير', 150),
  ]),
  'الأنبياء': _CategoryEntry([
    _Book('إشعياء', 66), _Book('إرميا', 52), _Book('مراثي إرميا', 5),
    _Book('حزقيال', 48), _Book('دانيال', 12),
    _Book('هوشع', 14), _Book('يويئيل', 3), _Book('عاموس', 9),
    _Book('عوبديا', 1), _Book('يونان', 4), _Book('ميخا', 7),
    _Book('ناحوم', 3), _Book('حبقوق', 3), _Book('صفنيا', 3),
    _Book('حجي', 2), _Book('زكريا', 14), _Book('ملاخي', 4),
  ]),
};
```

- [ ] **Run `flutter analyze`** — should pass with no new errors.

Partial commit: `git add -A && git commit -m "feat(bible): add domain models, randomizer, and dart channel wrapper"`

### Task 4: BibleAppsRepository (domain/data)

**Files:**
- Create: `lib/data/bible/bible_apps_repository.dart`
- Update barrel files

- [ ] **Create `bible_apps_repository.dart`** — Orchestrates app detection and launch:

```dart
// lib/data/bible/bible_apps_repository.dart
import '../../domain/bible/bible_app.dart';
import '../../native/channels/app_intent_channel.dart';

class BibleAppsRepository {
  /// Returns all supported apps.
  List<BibleApp> getSupportedApps() => List.from(kSupportedBibleApps);

  /// Returns only installed apps.
  Future<List<BibleApp>> getInstalledApps() async {
    final results = <BibleApp>[];
    for (final app in kSupportedBibleApps) {
      final installed = await AppIntentChannel.isInstalled(app.packageId);
      if (installed) results.add(app);
    }
    return results;
  }

  /// Launches the app. If [deepRef] is provided, attempts deep link.
  Future<bool> launchApp(BibleApp app, {String? deepRef}) async {
    return AppIntentChannel.launch(app.packageId, deepRef: deepRef);
  }

  /// Opens the Play Store page for the app.
  Future<void> openStore(BibleApp app) async {
    await AppIntentChannel.openStore(app.packageId);
  }
}
```

- [ ] **Create barrel exports**: Ensure `lib/native/native.dart` and `lib/domain/domain.dart` (or `lib/data/data.dart`) export the new modules. Follow the existing barrel file pattern in `lib/features/features.dart`.

Partial commit: `git add -A && git commit -m "feat(bible): add BibleAppsRepository with channel integration"`

### Task 5: Update JourneyGrid with Read Button + Randomizer

**Files:**
- Modify: `lib/features/home/presentation/widgets/journey_grid.dart`

- [ ] **Update `journey_grid.dart`** — Replace the fake randomizer and snackbar with the real `BibleRandomizerService` and `BibleAppsRepository`. The dialog now has:
  - A book/chapter suggestion from `BibleRandomizerService`
  - A "Read" button that calls `BibleAppsRepository.launchApp` with a `deepRef`
  - A "Reroll" button that generates a new suggestion
  - If no Bible app is installed, the "Read" button opens the Play Store.

```dart
// Key changes inside _RandomizerDialogState:

final _randomizer = BibleRandomizerService();
final _repository = BibleAppsRepository();

late ({String book, int chapter}) _suggestion;

@override
void initState() {
  super.initState();
  _reroll();
}

void _reroll() {
  setState(() {
    _suggestion = _randomizer.randomForCategory(widget.category);
  });
}

Future<void> _onRead() async {
  final apps = await _repository.getInstalledApps();
  if (apps.isEmpty) {
    // No app installed — open store for the first supported app
    await _repository.openStore(_repository.getSupportedApps().first);
    return;
  }
  // Launch the first installed app with the reference
  final ref = _buildDeepRef(_suggestion.book, _suggestion.chapter);
  final launched = await _repository.launchApp(apps.first, deepRef: ref);
  if (!launched && mounted) {
    // Deep link failed — try without deepRef
    await _repository.launchApp(apps.first);
  }
  if (mounted) Navigator.pop(context);
}

String _buildDeepRef(String book, int chapter) {
  // Attempt a common deep link pattern
  return 'https://www.bible.com/bible/$book/$chapter';
}
```

The dialog UI should show the suggested book and chapter, plus the two buttons.

- [ ] **Run `flutter analyze`** — should pass with 0 errors.
- [ ] **Run `flutter build apk --debug`** — should build successfully.

Final commit: `git add -A && git commit -m "feat(home): integrate Bible randomizer and app launch into JourneyGrid"`
