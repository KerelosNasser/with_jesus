# Architecture — مع يسوع (With Jesus)

> **Status:** Blueprint / pre-implementation. Last updated: 2026-06-25.
> **Audience:** Flutter architects, contributors, AI agents implementing features.
> **Companion files:** `design.md`, `context.md`, `progress-tracker.md`, `agents.md`.

This document defines *how* the app is built and *why*. Every rule here exists to
serve the product philosophy: **a digital spiritual retreat that makes the phone
quieter, not busier.** If a decision cannot be justified against that philosophy,
it does not belong in this codebase.

---

## 1. Architectural Pillars

| # | Pillar | What it means in practice |
|---|--------|---------------------------|
| 1 | **Offline-first, always** | Every feature works in airplane mode. No feature may require network for its core path. Network is a *future enhancement*, never a *prerequisite*. |
| 2 | **Feature-modular monolith** | One Flutter app, but each feature is an isolated module with its own `data/`, `domain/`, `presentation/`. A feature cannot import another feature's `data` or `domain` layer directly — only through declared ports. |
| 3 | **Riverpod as the single container** | Riverpod provides state management **and** dependency injection. No `GetIt`, no `flutter_bloc` unless a specific feature proves it necessary (see §6). |
| 4 | **Streams for reactive data** | Drift exposes reactive `Stream<List<Row>>`. Riverpod `StreamProvider` consumes them. UI rebuilds are scoped to exactly the data that changed. |
| 5 | **Platform channels only at the edges** | Kotlin is used *only* where a Flutter package cannot reach an Android capability (MediaStore scan, intent launch, launcher/home redirect, usage-stats, breathing-haptics). Everything else stays Dart. |
| 6 | **Privacy is a feature, not a setting** | No analytics, no trackers, no crash reporting by default. The encrypted journal never leaves the device. Logs are local-only and strip PII. |
| 7 | **Readable before clever** | We optimize for the contributor reading the code 3 years from now. No premature abstraction. No "flexible" interfaces with one implementation. |

---

## 2. Technology Stack (locked recommendations)

| Layer | Choice | Rationale |
|-------|--------|-----------|
| Framework | **Flutter (latest stable), Dart 3.x** | Single codebase, Android-first, iOS-shareable. |
| Rendering | **Impeller** (default) | Hardware-accelerated, smoother on low-end devices. |
| Design system | **Material 3** | Modern, accessible, theming primitives we need. |
| State + DI | **Riverpod 2.x** (`flutter_riverpod` + `riverpod_annotation` codegen) | Compile-time safe, testable, no `BuildContext` coupling, serves as DI. |
| Routing | **GoRouter** | Declarative, deep-linkable, redirect guards (e.g., onboarding/retreat). |
| Local DB | **Drift** (SQLite) ⭐ | Relational, **reactive streams**, first-class migrations, stable, ships with Android. Chosen over Isar: this app's data volumes are tiny, so Isar's raw-speed edge is imperceptible, while Drift's migration story + stream integration win for a multi-year OSS project. |
| KV prefs (non-sensitive) | **`shared_preferences`** | Theme, locale, onboarding flags. Lightweight. |
| KV secrets | **`flutter_secure_storage`** (Android Keystore) | Master encryption key, allowlists. |
| Journal crypto | **`cryptography` package — AES-256-GCM** (envelope encryption; key in Keystore) | Real at-rest encryption, never exported. |
| Audio playback | **`just_audio`** | ExoPlayer (Android) / AVAudioPlayer (iOS). Hardware decode, gapless, speed, EQ. Plays local `file://` and content URIs — fully offline. |
| Audio background/lock screen | **`audio_service`** (paired with `just_audio`) | Media session, notification, background playback. **Required** for the hymns feature. |
| Media discovery | **Kotlin platform channel → `MediaStore`** + Dart `FileSystemEntity` fallback | Native-speed scan of the user's hymn folders with metadata. |
| Filesystem | **`path_provider`** + **SAF (`file_picker`/document URIs)** | Android scoped-storage compliant folder selection. |
| Permissions | **`permission_handler`** | Runtime audio/storage/notification permissions. |
| Intl | **`intl`** + **`flutter_localizations`** | Arabic (default) + English. RTL-first. |
| Logging | **`logging`** (Dart) wrapped, **local-only** | No remote logging. PII stripped. |
| Testing | **`flutter_test`, `mocktail`, `patrol`** | Unit / widget / integration. Golden tests for key screens. |

> **Why not Isar?** Isar is faster on paper for huge datasets; we have none. Drift's reactive
> streams + migration tooling + SQLite ubiquity are worth far more to a long-lived project than
> microsecond gains on tables of a few thousand rows. Decision recorded in `context.md` (ADR-001).

> **Why not `flutter_bloc`?** Adds ceremony for no gain in this domain. Riverpod handles
> async, caching, disposal, and DI in one model. `flutter_bloc` is reserved (ADR-002) only if a
> future feature has many complex state transitions that Riverpod expresses awkwardly.

---

## 3. Folder Structure

Feature-first inside a layered core. Each feature owns its three layers and exposes
only its presentation widgets (and any declared ports) to the app shell.

```
lib/
├── main.dart                      # entry: ProviderScope, runApp(App)
├── app/
│   ├── app.dart                   # MaterialApp.router root widget
│   ├── app_router.dart            # GoRouter config + redirect guards
│   ├── app_providers.dart         # top-level overrides (env, logger)
│   └── bootstrap.dart             # async init: drift, secure storage, prefs
│
├── core/                          # shared, feature-agnostic primitives
│   ├── constants/                 # app-wide constants
│   ├── errors/                    # Failure types, AppException
│   ├── extensions/                # Dart/Flutter extensions
│   ├── result/                    # Result<T> sealed type (success/failure)
│   ├── theme/                     # Material 3 theme, tokens (see design.md)
│   ├── l10n/                      # ARB files, locale handling, RTL config
│   ├── utils/                     # date, debounce, id generators
│   └── platform/                  # platform_info.dart (isAndroid, sdkInt)
│
├── data/                          # cross-feature data infrastructure
│   ├── database/
│   │   ├── app_database.dart      # Drift @DriftDatabase definition
│   │   ├── app_database.g.dart    # generated
│   │   ├── tables/                # one file per Drift table
│   │   └── migrations/            # MigrationStrategy + versioned steps
│   ├── secure/                    # secure storage + crypto wrappers
│   └── prefs/                     # typed prefs repositories
│
├── shared/                        # reusable presentation widgets & components
│   ├── widgets/                   # buttons, cards, sheets (design.md library)
│   ├── layout/                    # scaffolds, sliver helpers
│   └── feedback/                  # loaders, empty/error state widgets
│
├── features/                      # ← each feature is self-contained
│   ├── home/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── reading_journey/
│   ├── continue_reading/
│   ├── bible_integration/
│   ├── hymns/
│   ├── focus_retreat/
│   ├── phone_detox/
│   ├── stress_relief/
│   ├── journal/
│   ├── emergency_contacts/
│   └── settings/
│
└── native/                        # Dart-side wrappers around platform channels
    ├── channels/                  # method/event channel definitions
    └── models/                    # POCOs crossing the channel boundary

android/app/src/main/kotlin/.../
└── native/                        # Kotlin handlers matching lib/native/channels
    ├── MediaStoreChannel.kt
    ├── AppIntentChannel.kt        # launch Catena/Coptic Reader/Katamaras
    ├── LauncherChannel.kt
    ├── UsageStatsChannel.kt
    └── PlatformChannelRegistry.kt # registers all handlers in one place

test/                              # mirrors lib/ structure
├── core/
├── data/
├── features/
└── ...

docs/                              # this folder
├── architecture.md
├── design.md
├── context.md
├── progress-tracker.md
└── agents.md

assets/
├── fonts/                         # Arabic-optimized typefaces
├── audio/                         # bundled ambience loops (church, nature)
├── icons/                         # app icon variants
└── data/                          # seed data (daily verses, reading schedule)
```

### Feature module contract

```
features/<feature>/
├── data/
│   ├── <feature>_repository_impl.dart
│   ├── <feature>_local_source.dart   # Drift/secure-storage/file access
│   └── <feature>_dtos.dart           # data ↔ domain mapping boundary
├── domain/
│   ├── entities/                     # plain Dart domain models
│   ├── <feature>_repository.dart     # abstract interface (the "port")
│   └── <feature>_service.dart        # pure business logic, no I/O deps
└── presentation/
    ├── providers/                    # Riverpod providers (state/notifier)
    ├── pages/                        # full screens
    ├── widgets/                      # feature-specific widgets
    └── controllers/                  # (only if complex local UI logic)
```

**Hard rule:** a feature may depend on `core/`, `data/`, `shared/`, and its own
`domain` port. A feature **must not** import another feature's `data` or `domain`.
Cross-feature coordination happens through:
- the app shell (GoRouter / the home screen aggregator), or
- a small `core/ports` interface implemented by whichever feature owns the data.

---

## 4. Flutter Architecture (layered)

```
┌────────────────────────────────────────────────────────────┐
│  PRESENTATION  (Widgets + Riverpod providers/notifiers)    │
│         depends only on domain interfaces (ports)          │
└───────────────────────────▲────────────────────────────────┘
                            │   reads/writes via Riverpod
┌───────────────────────────┴────────────────────────────────┐
│  DOMAIN  (entities, repository interfaces, pure services)   │
│               zero Flutter / Drift / I/O imports            │
└───────────────────────────▲────────────────────────────────┘
                            │   implemented by
┌───────────────────────────┴────────────────────────────────┐
│  DATA  (Drift DAOs, secure storage, prefs, file sources)   │
│        + platform channel wrappers under lib/native/        │
└────────────────────────────────────────────────────────────┘
```

**Dependency direction is strictly downward.** `domain` is the innermost, most
stable layer and must be importable with zero plugin dependencies — this is what
makes it unit-testable in isolation and what keeps features swappable.

### The `Result<T>` pattern

All async operations that can fail return `Result<T>` (a sealed class: `Success`
/ `Failure`) instead of throwing across layers. UI renders an explicit empty /
error state from `Failure`. This keeps the "peaceful, never crashes" promise.

```dart
sealed class Result<T> { const Result(); }
class Success<T> extends Result<T> { final T data; const Success(this.data); }
class Failure<T> extends Result<T> { final AppFailure failure; const Failure(this.failure); }
```

---

## 5. State Management Decisions

### Single model: Riverpod 2.x with code generation

| Provider type | Use for |
|---------------|---------|
| `@riverpod` (autoDispose by default) | most state — screens, view-models |
| `@Riverpod(keepAlive: true)` | app-singletons: database, audio handler, secure storage |
| `StreamProvider` | Drift reactive queries (reading list, journal entries, favorites) |
| `FutureProvider` | one-shot loads (today's reading journey, app-intent availability) |
| `NotifierProvider` / `AsyncNotifier` | mutating state (focus timer, audio queue, detox state) |

**Conventions**
- Every screen exposes a `*ViewController` (an `AsyncNotifier`) that is the single
  source of truth for that screen's state. Widgets never call repositories directly.
- State classes are immutable (`freezed` or hand-written `copyWith`). `freezed` is
  permitted; do not let it sprawl — prefer plain classes for trivial state.
- `autoDispose` is the default. Promote to `keepAlive` only with a written reason.

### Why Riverpod (and the conditions to switch — ADR-002)

Riverpod gives us compile-time safety, no `BuildContext` dependency (testable in
pure Dart), built-in disposal (memory), and DI in one model. We switch to
`flutter_bloc` *only if* a future feature has >5 distinct state transitions with
complex event-ordering that Riverpod expresses awkwardly. That feature may then
use Bloc locally while the rest stays Riverpod — but this has not happened yet.

---

## 6. Platform Channel Architecture

The boundary between Dart and Android. **Minimal, typed, and versioned.**

### Design rules
1. **One channel per capability**, registered centrally in `PlatformChannelRegistry`
   (Dart) and its Kotlin mirror (so there is one place to audit native surface).
2. **Typed on both sides.** Dart wrapper classes expose typed methods; internally
   they serialize to `MethodCall`/`Map`. Use `pigeon` when a channel grows past
   ~3 methods or non-trivial nested types — codegen prevents arg mismatches.
3. **Fail gracefully.** A channel returning `null`/error must never crash the app;
   the wrapper returns `Result.failure(...)` and the UI shows an empty/calm state.
4. **No business logic in Kotlin.** Handlers only bridge to Android APIs and
   return primitives/Maps. All decisions live in Dart.

### Declared channels (scope of this project)

| Channel | Direction | Purpose |
|---------|-----------|---------|
| `app/native/mediastore` | method | Scan configured folders via `MediaStore.Audio`, return `{title, artist, album, durationMs, artworkUri, dataUri}` list. Scoped-storage safe. |
| `app/native/intent` | method | Detect installation + launch Catena Bible, Coptic Reader, Orthodox Katamaras via explicit `Intent`. Optionally offer Play Store install. |
| `app/native/launcher` | method/event | Home-launcher registration status; set wallpaper/home hints. |
| `app/native/usage_stats` | method/event | Query `UsageStatsManager` for last-app-launched (opt-in, Focus redirect). Requires user-granted `PACKAGE_USAGE_STATS`. |
| `app/native/overlay` | method | Show/destroy a calm full-screen overlay (`SYSTEM_ALERT_WINDOW`) used by Focus redirect. Opt-in only. |
| `app/native/audio_meta` | (covered by mediastore) | — |
| `app/native/haptics` | method | Tactile cues for breathing exercises (optional). |

### Audio playback path (on-device, offline, backgrounded)

```
 User opens Hymns feature
        │
        ▼
 MediaStore channel ──► Kotlin queries MediaStore.Audio for configured folders
        │                       (title, chanter, duration, artwork, content/file URI)
        ▼
 HymnsRepository caches + persists favorites/playlists in Drift
        │
        ▼
 AudioHandler (audio_service) ──► just_audio player
        │                              • plays local file:// or content URI  (offline ✓)
        │                              • queue / shuffle / repeat / speed
        │                              • sleep timer (Dart-side, cancels at deadline)
        ▼
 Media notification + lock screen + background playback (audio_service media session)
```

- **Airplane-mode safe:** playback uses only local URIs; no network calls.
- **Battery:** ExoPlayer uses hardware decode; we avoid polling timers (use
  `player.positionStream` and `player.processingStateStream` instead).

---

## 7. Dependency Graph

```
                          ┌──────────────┐
                          │   app shell  │  (GoRouter, MaterialApp, bootstrap)
                          └──────┬───────┘
                                 │
        ┌────────────────────────┼─────────────────────────┐
        ▼                        ▼                         ▼
   features/*              shared/widgets             core/theme,l10n
   (home, hymns, …)        (design components)        (tokens, locale, RTL)
        │
        ▼
   domain/<feature>  ── pure, no Flutter/plugin imports
        │  (repository interface, entities, services)
        ▼
   data/<feature> ──┬── Drift (AppDatabase)  ── data/database
                   ├── SecureStorage + AES-256-GCM  ── data/secure
                   └── lib/native/* channel wrappers ── Android Kotlin
```

**Invariants**
- `app` → `features` + `shared` + `core` only.
- `features` → `core` + `shared` + own `domain`. Never another feature's `data`.
- `domain` → nothing below it. No `flutter`, no `drift`, no `just_audio`.
- `data` → `domain` (implements interfaces) + infra (Drift, secure, native).
- `lib/native` → `core/platform` + DTOs only.

---

## 8. Database Architecture (Drift)

### Why Drift (final)
Reactive streams (a `watch()` on any query returns a `Stream` that re-emits on
related writes) plug directly into Riverpod `StreamProvider` — so a favorites
change anywhere in the app instantly reflects in the Hymns list with **zero
manual invalidation**. SQLite ships with Android, is rock-solid, and Drift's
`MigrationStrategy` gives us a safe path to evolve the schema for years. For our
data sizes, query latency is dominated by I/O, not engine choice.

### Schema overview (initial; refined per feature in later milestones)

| Table | Feature | Key columns |
|-------|---------|-------------|
| `reading_journey_days` | Reading Journey | `date`, `slot` (prophet/ot/psalm/nt), `ref_book`, `ref_chapter`, `ref_verse_from`, `ref_verse_to`, `source_app` |
| `continue_reading` | Continue Reading | `id`, `book`, `chapter`, `verse`, `app_used`, `updated_at` |
| `hymn_tracks` | Hymns | `id`, `title`, `artist`, `album`, `duration_ms`, `uri`, `folder_id`, `artwork_uri`, `added_at` |
| `hymn_folders` | Hymns | `id`, `path/tree_uri`, `label`, `scan_enabled` |
| `playlists` / `playlist_items` | Hymns | playlist + ordered track refs |
| `favorites` | Hymns | `track_id`, `added_at` |
| `journal_entries` | Journal | `id`, `created_at`, `title_iv`, `title_ct`, `body_iv`, `body_ct`, `tag` (AES-GCM ciphertext + IV) |
| `focus_sessions` | Focus Retreat | `id`, `started_at`, `duration_min`, `ended_at`, `apps_blocked_count` |
| `detox_reflections` | Phone Detox | `id`, `date`, `prompt`, `response_ciphertext`, `mood` |
| `emergency_contacts` | Emergency | `id`, `lookup_key`, `display_name`, `phone` |
| `settings_kv` (optional) | Settings | typed overlay over prefs where reactive watch is needed |

### Migrations
- `schemaVersion` increments on every change. Each step is a named, tested function
  in `migrations/`. We ship `MigrationStrategy` with `onCreate` + `onUpgrade`.
- Migrations are covered by golden schema tests (Drift's
  `verifyIntegrity` + `validateDatabaseSchema`).
- **Journal rows are never auto-migrated in a way that could lose plaintext** —
  they are ciphertext; a migration that touches columns must re-key safely.

### Concurrency
- Single `AppDatabase` instance (`keepAlive` provider). Drift handles its own
  isolate-internal connection by default; we isolate-heavy scans (MediaStore) on
  the Dart side via `compute`/`Isolate.run` so the UI thread never blocks.

---

## 9. Navigation Architecture

**GoRouter**, declarative. All routes in one typed config so deep links and
redirects are centralized and testable.

- `ShellRoute` wraps the main tab/navigation so retreat mode can swap the shell.
- **Redirect guards:**
  - first-run → `/onboarding` until completed.
  - if a Focus Retreat is active and the route is not in the allowlist → redirect
    to `/retreat/active` (the calm screen).
- Named routes only (no magic strings in widgets): `context.goNamed('home')`.
- Bottom navigation is *shallow* by design (max ~5 destinations) to discourage
  wandering — see `design.md`.

---

## 10. Dependency Injection

**Riverpod is the DI container.** No service locator.

```dart
// keepAlive singletons, created once
@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) => AppDatabase.shared();

@Riverpod(keepAlive: true)
AudioHandler audioHandler(AudioHandlerRef ref) => /* init just_audio + audio_service */;

// repositories get their deps from the container
@riverpod
JournalRepository journalRepository(JournalRepositoryRef ref) =>
  JournalRepositoryImpl(db: ref.watch(appDatabaseProvider), crypto: ref.watch(journalCryptoProvider));
```

**Testing** swaps providers via `ProviderContainer(overrides: [...])`. No global
state, no `Get.instance`.

---

## 11. Offline Strategy

Everything is offline-first by construction:

- **No remote backend in v1.** No sync, no accounts, no cloud.
- **Daily content** (verse of the day, reading-journey schedule) is **bundled as
  assets / generated locally**. Generation uses a deterministic seed from the
  date + a local history table so it never repeats recent picks — no server call.
- **Audio** is the user's own local files, played from `file://`/content URIs.
- **Bible integration** launches *installed* apps via intents; if none installed,
  we offer Play Store (the only network touch, user-initiated).
- **Future-proofing for optional sync:** repositories are abstracted behind
  domain ports; a future cloud-sync layer can be added behind the same interface
  without touching presentation code. Out of scope for v1.

---

## 12. Scalability Plan

| Axis | Approach |
|------|----------|
| **More features** | Each new feature = a new `features/<x>` folder following the contract. No core changes needed. |
| **More languages** | Add ARB files; `intl` already wired. Default stays Arabic RTL. |
| **iOS** | Shared Flutter code unchanged; add iOS-specific channel impls (AVAudioPlayer via just_audio handles audio natively; intents become URL schemes / universal links). |
| **Bigger datasets** | Drift paginates trivially; Isolate for scans. No architectural change needed. |
| **Optional cloud** | Add a `data/remote` layer behind existing repository ports. Presentation untouched. |
| **Plugin independence** | Every third-party package is wrapped behind our own interface (`AudioEngine`, `SecureStore`, `PermissionService`) so a package swap is localized. |

---

## 13. Testing Strategy

| Level | Tool | Target | Goal |
|-------|------|--------|------|
| Unit | `flutter_test` + `mocktail` | `domain` services, repositories (with in-memory/fake Drift), mappers | 100% of domain logic |
| Widget | `flutter_test` | screens, shared components, empty/error states | all key screens + golden snapshots |
| Integration | `patrol` | critical flows: open retreat, scan hymns, play track, add journal entry, launch a Bible app intent | one per feature |
| Golden | `flutter_test` matchesGoldenFile | home, focus, journal — RTL + LTR + dark | catches visual regressions |
| Migration | Drift schema tests | each `onUpgrade` step | never lose user data |
| Performance | Flutter DevTools / `benchmark` | app startup, scroll, audio seek | startup < 1.5s on mid-range device; 60fps scroll |

**Testing principles**
- Domain layer has **zero** Flutter imports → tests run as plain Dart, fast.
- Riverpod providers tested via `ProviderContainer` with overrides (no widget tree).
- No real Android calls in tests — every channel has a fake.

---

## 14. CI/CD Recommendations

- **GitHub Actions** matrix (free for OSS): `analyze` → `test` → `build` → (release on tag).
  - `flutter pub get` → `dart run build_runner build` → `flutter analyze` → `flutter test`.
  - Build `app-release.apk` and `.aab` on tagged commits; upload as artifacts.
- **Pre-commit / PR gate:** `flutter analyze` must be clean; new code must have tests.
- **Codegen:** run `dart run build_runner build --delete-conflicting-outputs` in CI
  and fail if generated files are stale.
- **Localization check:** CI fails if ARB keys are missing between `ar` and `en`.
- **Release:** signed builds; `fastlane` (optional) for Play Store upload once a
  keystore + Play service account are configured.
- **No telemetry in CI artifacts.** Confirm no analytics SDK is introduced by a
  dependency scan (`flutter pub deps` review on version bumps).

---

## 15. Security Considerations

| Asset | Threat | Mitigation |
|-------|--------|-----------|
| Journal plaintext | Device theft / backup leakage | AES-256-GCM at rest; key in **Android Keystore** (hardware-backed where available); ciphertext only in DB; **never** exported unless user explicitly decrypts-and-exports to a chosen file. |
| Master key | Extraction | Stored via `flutter_secure_storage`; never logged; never serialized to prefs. |
| Hymns / user files | Unintended access | Read via scoped permissions only; never copy file contents we don't need. |
| Inter-app launch | Spoofed intents | Launch by explicit package/component for Catena/Coptic Reader/Katamaras; validate `resolveActivity` before start. |
| Logs | PII leakage | Local-only; redact URIs/titles in logs by default; `kReleaseMode` disables verbose logs. |
| Overlay (Focus redirect) | Abuse surface | `SYSTEM_ALERT_WINDOW` is **opt-in** and clearly explained; overlay is passive ("return?"), never blocks. |
| Dependencies | Supply chain | Minimal deps; pin versions; review on bump; prefer well-maintained, audited packages. |
| Storage perms | Over-broad access | Request the narrowest scope (media-audio) per Android version; prefer SAF for arbitrary folders. |

**Honest capability statement (Focus Mode):** Android does not allow a third-party
app to truly *hide or force-stop* another app without OEM/system privileges. Our
Focus Retreat achieves its goal through **legitimate, Play-Store-safe** levers:
(1) optional **launcher** mode so the retreat shell simply doesn't surface other
apps, and (2) an **opt-in gentle redirect overlay** (intentional friction) when a
blocked app is opened. We never claim to "block" apps in the OS sense — we make
returning to the retreat the easy, calm choice. This is consistent with the detox
philosophy and with Google Play policy.
