# M3 — Bible Integration Design Spec

## Overview
Detect installed Orthodox Bible apps on the user's device, launch them to specific scripture references, and offer Play Store installation when a preferred app is missing. Integrated with M2's Reading Journey Grid so "Read" actions redirect seamlessly to external Bible apps.

## Supported Apps Registry

| App | Package ID | Notes |
|-----|-----------|-------|
| Catena Bible & Commentaries | `com.catena` | Supports deep linking via `catena://bible/{book}/{chapter}` |
| Coptic Reader | `com.app.copticreader` | Popular comprehensive Orthodox reader |
| Orsozoxi + Katamars | `coptic.avabishoy.katamars` | "أرثوذكسى + القطمارس" — comprehensive offline library |

## Kotlin Native Layer

### `AppIntentChannel.kt`
A new handler registered in `PlatformChannelRegistry` under `"app/native/intent"` with three methods:

| Method | Args | Returns | Behavior |
|--------|------|---------|----------|
| `isInstalled` | `package: String` | `bool` | Checks `PackageManager.getPackageInfo` for the given package |
| `launch` | `package: String`, `deepRef: String?` | `bool` | Resolves `packageManager.getLaunchIntentForPackage`. If `deepRef` provided, attempts deep link scheme first as `ACTION_VIEW` URI. Falls back to basic launch intent. |
| `openStore` | `package: String` | `void` | Opens `market://details?id={package}` via `ACTION_VIEW` |

### Integration with existing PlatformChannelRegistry
- The `app/native/intent` channel is already declared. Its handler is replaced from `result.notImplemented()` to delegate to the new `AppIntentChannelHandler`.

## Dart Domain Layer

### `lib/data/bible/bible_apps_repository.dart`
A repository holding the supported apps registry. Methods:
- `List<BibleApp> getSupportedApps()` — returns all 3 hardcoded entries
- `Future<List<BibleApp>> getInstalledApps()` — calls channel to filter by installed status
- `Future<void> launchApp(BibleApp app, {String? deepRef})` — calls channel to launch
- `Future<void> openStore(BibleApp app)` — calls channel to open Play Store

### `lib/domain/bible/bible_app.dart`
A pure Dart model:
```dart
class BibleApp {
  final String id;
  final String label;
  final String packageId;
  final String? iconAsset;

  const BibleApp({...});
}
```

### `lib/domain/bible/bible_randomizer_service.dart`
Pure Dart utility that maps the 4 journey categories (Old Testament, New Testament, Psalms, Prophets) to their constituent books and generates random chapters.

## M2 Journey Grid Integration
The existing `journey_grid.dart` will be updated:
- **Tap card** → Rerolls the random chapter suggestion (existing behavior preserved)
- **Tap "Read" button** underneath each card → Uses `BibleAppsService` to find the preferred installed app, then launches it with the selected chapter reference as a `deepRef`
- **No app installed?** → Shows a snackbar/dialog offering to install from Play Store using `openStore()`

## Deep Linking Strategy
- Attempt `ACTION_VIEW` with an `https://` or custom scheme URI (`catena://bible/{book}/{chapter}`)
- Wrap in `try/catch` — if the deep link fails, fallback to `launchIntentForPackage` (basic app launch)
- Document exact URI schemes for each app as they're verified (research item)

## Testing
- `BibleAppsRepository`: unit test with a fake channel
- `BibleRandomizerService`: unit test for randomness within valid ranges
- Journey Grid: widget test verifying "Read" button renders and calls the repository
- Kotlin unit test: `isInstalled` returns correct Boolean for known package IDs
