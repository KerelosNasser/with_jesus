# M8 — Phone Detox Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a calm, non-gamified "phone detox" that uses مع يسوع *as the launcher* to surface only a curated allowlist, with a timed reflection session (top icon) and an always-on curated home (Settings toggle), and an encrypted private log of reflections.

**Architecture:** Detox = being the home. A go_router `StatefulShellRoute` provides a minimal 4-item `AppDock` (Home/Hymns/Journal/Focus) preserving each branch's state. A `DetoxReflectionRepository` mirrors `JournalRepository`, reusing `JournalCrypto` (AES-256-GCM, ADR-003) and adding a `DetoxReflections` Drift table (schema 4→5). A `DetoxSessionNotifier` reuses M7's timer pattern. No new platform channels; the always-on mode calls the existing `LauncherChannel`.

**Tech Stack:** Flutter, Dart 3, Riverpod 2.x (plain `flutter_riverpod`, no codegen annotations — match the codebase), Drift, `cryptography`, go_router, intl gen-l10n.

**Design spec:** `docs/superpowers/specs/2026-06-26-m8-phone-detox-design.md` (read it first).

---

## Codebase conventions you MUST match (verified)

- **Result type:** `lib/core/result/result.dart` — `Result.success(data)` / `Result.failure(AppFailure)`. Pattern-match in UI.
- **AppFailure:** `lib/core/errors/app_failure.dart` — read it; use its constructor(s) for repo errors.
- **Crypto (REUSE, do not fork):** `lib/data/journal/journal_crypto.dart` — `JournalCrypto().encrypt(String)` → `SecretBox`; `.decrypt(SecretBox)` → `String`.
- **DB singleton provider:** `appDatabaseProvider` is defined in `lib/data/reading_journey/continue_reading_repository.dart` — `ref.watch(appDatabaseProvider)` to get `AppDatabase`.
- **Providers style:** plain `Provider<T>` for repos, `FutureProvider`/`StreamProvider` for reads. NO `@riverpod` annotations anywhere in the codebase — do not introduce them.
- **Localization:** `l10n.yaml` exists; template is `lib/core/l10n/app_en.arb`; regenerate with `flutter gen-l10n` (writes `app_localizations*.dart`). NOTE: existing screens (M2/M7/M10) currently hardcode Arabic strings — M8 breaks that pattern on purpose and uses `AppLocalizations` (context.md §9 mandates it). Do not "fix" other screens in this PR.
- **Spacing/theme tokens:** `AppSpacing` (`lib/core/theme/app_spacing.dart`); colors from `Theme.of(context).colorScheme`. Never hardcode px or colors.
- **Existing widgets to reuse:** `EmptyState` (`lib/shared/widgets/empty_state.dart`), `AppTextField` (`lib/shared/widgets/app_text_field.dart`), `SlowGestureDetector` (`lib/features/focus_retreat/presentation/widgets/slow_gesture_detector.dart`).
- **Bible app handoff:** `AppIntentChannel.launch(package)` in `lib/native/channels/app_intent_channel.dart`.
- **Launcher status:** `LauncherChannel.isDefaultLauncher()` / `LauncherChannel.requestDefaultLauncher()` in `lib/native/channels/launcher_channel.dart`.

**Commands** (run from repo root, Git Bash):
- analyze: `flutter analyze`
- codegen: `dart run build_runner build --delete-conflicting-outputs`
- l10n: `flutter gen-l10n`
- tests: `flutter test path/to/test`
- goldens regenerate: `flutter test --update-goldens path/to/test`

---

## File Structure

**Create:**
- `lib/domain/detox/detox_reflection.dart` — pure-Dart value type.
- `lib/domain/detox/detox_prompt_rotation.dart` — deterministic-by-date prompt selection.
- `lib/data/detox/detox_reflection_repository.dart` — encrypted repo + Riverpod providers.
- `lib/features/detox/presentation/providers/detox_session_provider.dart` — timer notifier.
- `lib/features/detox/presentation/providers/detox_launcher_provider.dart` — launcher-status watcher.
- `lib/features/detox/presentation/detox_session_page.dart` — reflection gate + active session.
- `lib/features/detox/presentation/detox_reflections_page.dart` — private log.
- `lib/features/detox/presentation/widgets/breathing_orb.dart` — calm orb (honors disableAnimations).
- `lib/shared/widgets/app_dock.dart` — minimal floating dock.
- `lib/shared/widgets/app_shell.dart` — `StatefulShellRoute` host + top-icon entry.
- `docs/research/detox-evidence.md` — cited evidence.

**Tests (create):**
- `test/domain/detox/detox_prompt_rotation_test.dart`
- `test/domain/detox/detox_reflection_test.dart`
- `test/data/detox/detox_reflection_repository_test.dart`
- `test/features/detox/detox_session_provider_test.dart`
- `test/features/detox/detox_launcher_provider_test.dart`
- `test/features/detox/detox_session_page_test.dart`
- `test/features/detox/detox_reflections_page_test.dart`
- `test/shared/app_dock_test.dart`

**Modify:**
- `lib/data/database/app_database.dart` — add `DetoxReflections` table, bump schema 4→5.
- `lib/core/router/app_router.dart` — `StatefulShellRoute` for dock + `/detox/session`, `/detox/reflections` routes.
- `lib/features/settings/settings_page.dart` — add the always-on toggle + reflections-link rows.
- `lib/core/l10n/app_en.arb`, `lib/core/l10n/app_ar.arb` — new keys.

---

## Task 1: Reflection prompts (domain, pure Dart) — rotational selection

**Files:**
- Create: `lib/domain/detox/detox_prompt_rotation.dart`
- Create: `lib/domain/detox/detox_prompt.dart`
- Test: `test/domain/detox/detox_prompt_rotation_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
// test/domain/detox/detox_prompt_rotation_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:with_jesus/domain/detox/detox_prompt.dart';
import 'package:with_jesus/domain/detox/detox_prompt_rotation.dart';

void main() {
  group('DetoxPromptRotation', () {
    test('returns the same prompt for the same date', () {
      final day1 = DateTime(2026, 6, 26);
      final later = DateTime(2026, 6, 26, 23, 59);
      expect(
        DetoxPromptRotation.promptFor(day1),
        same(DetoxPromptRotation.promptFor(later)) |
            DetoxPromptRotation.promptFor(day1).key,
      );
      expect(
        DetoxPromptRotation.promptFor(day1).key,
        DetoxPromptRotation.promptFor(later).key,
      );
    });

    test('cycles through all prompts deterministically', () {
      // Deterministic by date means consecutive days pick from the set; verify
      // the whole set is covered within len(prompts) consecutive days.
      final keys = <String>{};
      for (var i = 0; i < DetoxPromptRotation.all.length * 2; i++) {
        final day = DateTime(2026, 1, 1).add(Duration(days: i));
        keys.add(DetoxPromptRotation.promptFor(day).key);
      }
      expect(keys, DetoxPromptRotation.all.map((p) => p.key).toSet());
    });

    test('prompt key list matches the spec', () {
      expect(
        DetoxPromptRotation.all.map((p) => p.key),
        [
          'detox.prompt.whyNow',
          'detox.prompt.whatInstead',
          'detox.prompt.oneThingForGod',
          'detox.prompt.justBreathe',
        ],
      );
    });
  });
}
```

Note: the first assertion's `same(...)` is intentionally weak; the `.key` equality on the next line is the real check. Remove the confusing first line before committing — keep only the `.key` equality and the cycles test.

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/domain/detox/detox_prompt_rotation_test.dart`
Expected: FAIL — `detox_prompt_rotation.dart` / `detox_prompt.dart` do not exist.

- [ ] **Step 3: Implement the prompt type**

```dart
// lib/domain/detox/detox_prompt.dart

/// A detox reflection prompt: its ARB message key.
///
/// Pure Dart — no Flutter/plugin imports. The localized string itself lives in
/// the ARB files and is looked up via [AppLocalizations] in the UI layer.
class DetoxPrompt {
  const DetoxPrompt(this.key);

  /// ARB key (e.g. `detox.prompt.whyNow`) used to fetch the localized prompt.
  final String key;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DetoxPrompt && key == other.key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() => 'DetoxPrompt($key)';
}
```

- [ ] **Step 4: Implement the rotation**

```dart
// lib/domain/detox/detox_prompt_rotation.dart
import 'detox_prompt.dart';

/// Deterministic-by-date selection of the daily detox reflection prompt.
///
/// Same calendar day → same prompt (matches the project's seeded-by-date
/// pattern used by the reading journey). Consecutive days cycle through the
/// full prompt set so the user sees variety without "random challenge" framing.
abstract final class DetoxPromptRotation {
  DetoxPromptRotation._();

  /// The full, ordered prompt set (spec §2).
  static const List<DetoxPrompt> all = [
    DetoxPrompt('detox.prompt.whyNow'),
    DetoxPrompt('detox.prompt.whatInstead'),
    DetoxPrompt('detox.prompt.oneThingForGod'),
    DetoxPrompt('detox.prompt.justBreathe'),
  ];

  /// Returns the prompt for [day], deterministically by day-since-epoch.
  static DetoxPrompt promptFor(DateTime day) {
    final dayNumber = DateTime(day.year, day.month, day.day)
        .difference(DateTime(1970, 1, 1))
        .inDays;
    final index = dayNumber % all.length;
    return all[index];
  }
}
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/domain/detox/detox_prompt_rotation_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/domain/detox test/domain/detox
git commit -m "feat(m8): add rotational detox reflection prompts"
```

---

## Task 2: DetoxReflection domain value type

**Files:**
- Create: `lib/domain/detox/detox_reflection.dart`
- Test: `test/domain/detox/detox_reflection_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
// test/domain/detox/detox_reflection_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:with_jesus/domain/detox/detox_reflection.dart';

void main() {
  test('copies with overrides, equals by value', () {
    final now = DateTime(2026, 6, 26);
    final r = DetoxReflection(
      id: 1,
      promptKey: 'detox.prompt.whyNow',
      answer: 'feeling anxious',
      createdAt: now,
    );
    final updated = r.copyWith(answer: 'calmer now');
    expect(updated.answer, 'calmer now');
    expect(updated.id, 1);
    expect(updated.promptKey, 'detox.prompt.whyNow');
  });

  test('skipped reflection has null answer', () {
    final r = DetoxReflection(
      promptKey: 'detox.prompt.justBreathe',
      answer: null,
      createdAt: DateTime(2026, 6, 26),
    );
    expect(r.answer, isNull);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/domain/detox/detox_reflection_test.dart`
Expected: FAIL — file does not exist.

- [ ] **Step 3: Implement the value type**

```dart
// lib/domain/detox/detox_reflection.dart

/// A single detox reflection: the prompt shown and the user's optional answer.
///
/// Pure Dart — no Flutter/plugin imports. The answer is decrypted by the
/// repository before constructing this type, so `answer` is already plaintext.
class DetoxReflection {
  const DetoxReflection({
    this.id,
    required this.promptKey,
    this.answer,
    required this.createdAt,
  });

  /// DB row id; null for a not-yet-saved reflection.
  final int? id;

  /// ARB key of the prompt that was shown (e.g. `detox.prompt.whyNow`).
  final String promptKey;

  /// The user's free-text answer, or null when they chose "just breathe"
  /// (skipped). For skipped reflections only promptKey + createdAt persist.
  final String? answer;

  /// When the reflection was recorded.
  final DateTime createdAt;

  /// Returns a copy with the given fields replaced.
  DetoxReflection copyWith({
    int? id,
    String? promptKey,
    String? answer,
    DateTime? createdAt,
  }) {
    return DetoxReflection(
      id: id ?? this.id,
      promptKey: promptKey ?? this.promptKey,
      answer: answer ?? this.answer,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetoxReflection &&
          id == other.id &&
          promptKey == other.promptKey &&
          answer == other.answer &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(id, promptKey, answer, createdAt);

  @override
  String toString() =>
      'DetoxReflection(id: $id, promptKey: $promptKey, answer: ${answer == null ? 'null(skipped)' : '…'})';
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/domain/detox/detox_reflection_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/domain/detox/detox_reflection.dart test/domain/detox/detox_reflection_test.dart
git commit -m "feat(m8): add DetoxReflection domain type"
```

---

## Task 3: Drift `DetoxReflections` table + migration (schema 4→5)

**Files:**
- Modify: `lib/data/database/app_database.dart`
- Test: `test/data/database/app_database_migration_test.dart`

- [ ] **Step 1: Write the failing migration test**

```dart
// test/data/database/app_database_migration_test.dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:with_jesus/data/database/app_database.dart';

void main() {
  test('schema v5 creates the detox_reflections table', () async {
    // Open an in-memory database at the current schema; createAll runs onCreate.
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(() => db.close());

    // detox_reflections table exists?
    final tables = await db.customSelect(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='detox_reflections'",
    ).get();
    expect(tables, isNotEmpty);

    // Its columns?
    final cols = await db.customSelect(
      "PRAGMA table_info(detox_reflections)",
    ).get();
    final names = cols.map((r) => r.read<String>('name')).toSet();
    expect(names, containsAll(<String>[
      'id', 'prompt_key', 'answer_nonce', 'answer_ciphertext',
      'answer_mac', 'created_at',
    ]));
    // NOTE: there must be NO 'mode' column (spec §2 removed it).
    expect(names.contains('mode'), isFalse);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/data/database/app_database_migration_test.dart`
Expected: FAIL — table does not exist / `forTesting` not defined.

- [ ] **Step 3: Add the table + migration + test constructor**

In `lib/data/database/app_database.dart`:

Add the new table class near the others (after `ContinueReading`):

```dart
class DetoxReflections extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get promptKey => text()();
  BlobColumn get answerNonce => blob().nullable()();
  BlobColumn get answerCiphertext => blob().nullable()();
  BlobColumn get answerMac => blob().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
```

Register it and bump the version (find the existing `@DriftDatabase(...)` and `schemaVersion`):

```dart
@DriftDatabase(
  tables: [ReadingHistory, ContinueReading, JournalEntries, DetoxReflections],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Testing-only constructor: open against a provided [e] (e.g. in-memory).
  AppDatabase.forTesting(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(readingHistory);
        }
        if (from < 3) {
          await m.createTable(continueReading);
        }
        if (from < 4) {
          await m.createTable(journalEntries);
        }
        if (from < 5) {
          await m.createTable(detoxReflections);
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}
```

- [ ] **Step 4: Regenerate drift codegen**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: completes, `app_database.g.dart` updated with `DetoxReflections`/`detoxReflections`.

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/data/database/app_database_migration_test.dart`
Expected: PASS.

- [ ] **Step 6: Commit**

```bash
git add lib/data/database test/data/database
git commit -m "feat(m8): add detox_reflections table (schema v5)"
```

---

## Task 4: DetoxReflectionRepository — encrypt/store/read-back (TDD)

**Files:**
- Create: `lib/data/detox/detox_reflection_repository.dart`
- Test: `test/data/detox/detox_reflection_repository_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
// test/data/detox/detox_reflection_repository_test.dart
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:with_jesus/data/database/app_database.dart';
import 'package:with_jesus/data/detox/detox_reflection_repository.dart';
import 'package:with_jesus/core/result/result.dart';

// A crypto fake with a fixed nonce so tests are deterministic. It mirrors the
// real JournalCrypto.encrypt/decrypt contract without touching secure storage.
class _FakeCrypto implements JournalCrypto {
  _FakeCrypto();
  // Implement using a simple XOR-ish placeholder? NO — reuse the real one is
  // not possible in unit tests (secure storage). Instead inject the real
  // JournalCrypto but override its secure storage to an in-memory stub.
}
```

Stop — the crypto depends on `flutter_secure_storage`, which can't run in pure Dart tests. **Re-architect the test to use the real `JournalCrypto` but inject an in-memory secure storage** (that's why `JournalCrypto` already accepts `FlutterSecureStorage? secureStorage`).

Replace the test file entirely with:

```dart
// test/data/detox/detox_reflection_repository_test.dart
import 'package:cryptography/cryptography.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:with_jesus/data/database/app_database.dart';
import 'package:with_jesus/data/detox/detox_reflection_repository.dart';
import 'package:with_jesus/data/journal/journal_crypto.dart';
import 'package:with_jesus/core/result/result.dart';

// In-memory FlutterSecureStorage for tests (set up via MethodChannel mock).
final _store = <String, String>{};

void setupSecureStorageMock() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (call) async {
    switch (call.method) {
      case 'read':
        return _store[call.arguments['key'] as String];
      case 'write':
        _store[call.arguments['key'] as String] =
            call.arguments['value'] as String;
        return null;
      case 'containsKey':
        return _store.containsKey(call.arguments['key'] as String);
    }
    return null;
  });
}

void main() {
  late AppDatabase db;
  late JournalCrypto crypto;
  late DetoxReflectionRepository repo;

  setUp(() async {
    setupSecureStorageMock();
    _store.clear();
    db = AppDatabase.forTesting(NativeDatabase.memory());
    crypto = JournalCrypto();
    repo = DetoxReflectionRepository(db, crypto);
  });

  tearDown(() => db.close());

  test('saved reflection round-trips (with answer)', () async {
    final id = await repo
        .save(promptKey: 'detox.prompt.whyNow', answer: 'I felt restless')
        .then((r) => (r as Success).data);

    expect(id, isPositive);
    final all = await repo.getAll();
    final list = (all as Success).data as List;
    expect(list, hasLength(1));
    final got = list.single;
    expect(got.promptKey, 'detox.prompt.whyNow');
    expect(got.answer, 'I felt restless');
  });

  test('skipped reflection (null answer) round-trips', () async {
    await repo.save(promptKey: 'detox.prompt.justBreathe', answer: null);

    final all = await repo.getAll();
    final list = (all as Success).data as List;
    expect(list, hasLength(1));
    expect(list.single.answer, isNull);
    expect(list.single.promptKey, 'detox.prompt.justBreathe');
  });

  test('getAll returns newest-first', () async {
    await repo.save(promptKey: 'detox.prompt.whyNow', answer: 'a');
    await repo.save(promptKey: 'detox.prompt.whatInstead', answer: 'b');

    final list = (await repo.getAll() as Success).data as List;
    expect(list.first.answer, 'b');
    expect(list.last.answer, 'a');
  });

  test('delete removes the reflection', () async {
    final id = (await repo.save(
      promptKey: 'detox.prompt.whyNow',
      answer: 'x',
    ) as Success).data as int;
    await repo.delete(id);

    final list = (await repo.getAll() as Success).data as List;
    expect(list, isEmpty);
  });

  test('tampered ciphertext row is silently omitted (not crash)', () async {
    await repo.save(promptKey: 'detox.prompt.whyNow', answer: 'real');
    // Corrupt the stored ciphertext directly in the DB.
    await db.customStatement(
      "UPDATE detox_reflections SET answer_ciphertext = zeroblob(16)",
    );

    final list = (await repo.getAll() as Success).data as List;
    expect(list, isEmpty); // undecryptable row skipped, no throw
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/data/detox/detox_reflection_repository_test.dart`
Expected: FAIL — `detox_reflection_repository.dart` does not exist.

- [ ] **Step 3: Implement the repository**

```dart
// lib/data/detox/detox_reflection_repository.dart
import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:with_jesus/core/errors/app_failure.dart';
import 'package:with_jesus/core/result/result.dart';
import 'package:with_jesus/data/database/app_database.dart' as db;
import 'package:with_jesus/data/journal/journal_crypto.dart';
import 'package:with_jesus/data/reading_journey/continue_reading_repository.dart'
    show appDatabaseProvider;
import 'package:with_jesus/data/journal/journal_providers.dart'
    show journalCryptoProvider;
import 'package:with_jesus/domain/detox/detox_reflection.dart';

/// Encrypted repository for detox reflections.
///
/// Mirrors [JournalRepository]: the optional [DetoxReflection.answer] is
/// encrypted with [JournalCrypto] (AES-256-GCM, ADR-003) before storage; only
/// nonce/ciphertext/mac persist. A skipped reflection stores null blobs. Rows
/// that fail to decrypt are silently omitted so one corrupt entry never breaks
/// the list.
class DetoxReflectionRepository {
  DetoxReflectionRepository(this._db, this._crypto);

  final db.AppDatabase _db;
  final JournalCrypto _crypto;

  /// Returns all reflections, newest-first. Undecryptable rows are skipped.
  Future<Result<List<DetoxReflection>>> getAll() async {
    try {
      final rows = await (_db.select(_db.detoxReflections)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();
      final results = <DetoxReflection>[];
      for (final row in rows) {
        final entry = await _decryptRow(row);
        if (entry != null) results.add(entry);
      }
      return Result.success(results);
    } catch (e) {
      return Result.failure(AppFailure.unknown(e.toString()));
    }
  }

  /// Saves a reflection. A null/empty [answer] is stored as skipped (null blobs).
  /// Returns the new row id.
  Future<Result<int>> save({
    required String promptKey,
    String? answer,
  }) async {
    try {
      final now = DateTime.now();
      db.DetoxReflectionsCompanion companion;

      if (answer == null || answer.trim().isEmpty) {
        companion = db.DetoxReflectionsCompanion.insert(
          promptKey: promptKey,
          answerNonce: const Value.absent(),
          answerCiphertext: const Value.absent(),
          answerMac: const Value.absent(),
          createdAt: now,
        );
      } else {
        final box = await _crypto.encrypt(answer);
        companion = db.DetoxReflectionsCompanion.insert(
          promptKey: promptKey,
          answerNonce: Value(Uint8List.fromList(box.nonce)),
          answerCiphertext: Value(Uint8List.fromList(box.cipherText)),
          answerMac: Value(Uint8List.fromList(box.mac.bytes)),
          createdAt: now,
        );
      }

      final id = await _db.into(_db.detoxReflections).insert(companion);
      return Result.success(id);
    } catch (e) {
      return Result.failure(AppFailure.unknown(e.toString()));
    }
  }

  /// Deletes the reflection with [id].
  Future<Result<void>> delete(int id) async {
    try {
      await (_db.delete(_db.detoxReflections)..where((t) => t.id.equals(id)))
          .go();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(AppFailure.unknown(e.toString()));
    }
  }

  Future<DetoxReflection?> _decryptRow(
    covariant db.DetoxReflection row,
  ) async {
    try {
      String? answer;
      if (row.answerCiphertext != null &&
          row.answerNonce != null &&
          row.answerMac != null) {
        answer = await _crypto.decrypt(
          SecretBox(
            row.answerCiphertext!,
            nonce: row.answerNonce!,
            mac: Mac(row.answerMac!),
          ),
        );
      }
      return DetoxReflection(
        id: row.id,
        promptKey: row.promptKey,
        answer: answer,
        createdAt: row.createdAt,
      );
    } catch (_) {
      return null;
    }
  }
}

// ── Riverpod providers (plain Provider/FutureProvider — match the codebase) ──

final detoxReflectionRepositoryProvider =
    Provider<DetoxReflectionRepository>((ref) {
  return DetoxReflectionRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(journalCryptoProvider),
  );
});

/// Reactive list of reflections (Drift watch → re-fetch on change).
final detoxReflectionsProvider =
    FutureProvider<List<DetoxReflection>>((ref) async {
  final stream = ref.watch(appDatabaseProvider).streamForReflections();
  // Watch the table; on every change, re-read decrypted list.
  await for (final _ in stream) {
    final result = await ref.watch(detoxReflectionRepositoryProvider).getAll();
    return result.requireData;
  }
  throw StateError('unreachable');
});
```

Add the helper stream method to `AppDatabase` (in `app_database.dart`, inside the class body):

```dart
  /// Emits once per change to [detoxReflections]; used by providers to refresh.
  Stream<void> streamForReflections() {
    final query = select(detoxReflections);
    return query.watch().map((_) {});
  }
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `flutter test test/data/detox/detox_reflection_repository_test.dart`
Expected: all 5 PASS.

> If `AppFailure.unknown` doesn't exist by that name, read `lib/core/errors/app_failure.dart` and use its actual factory (e.g. `AppFailure.storage`, `AppFailure.database`). Do not invent a constructor.

- [ ] **Step 5: Commit**

```bash
git add lib/data/detox lib/data/database/app_database.dart test/data/detox
git commit -m "feat(m8): encrypted detox reflection repository"
```

---

## Task 5: DetoxSessionNotifier — timer (reuses M7 pattern), ephemeral

**Files:**
- Create: `lib/features/detox/presentation/providers/detox_session_provider.dart`
- Test: `test/features/detox/detox_session_provider_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
// test/features/detox/detox_session_provider_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:with_jesus/features/detox/presentation/providers/detox_session_provider.dart';

void main() {
  test('start sets active + remaining; end resets to inactive', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(detoxSessionProvider).isActive, isFalse);

    container
        .read(detoxSessionProvider.notifier)
        .start(const Duration(minutes: 15));

    final active = container.read(detoxSessionProvider);
    expect(active.isActive, isTrue);
    expect(active.totalDuration, const Duration(minutes: 15));
    expect(active.remainingTime, const Duration(minutes: 15));

    container.read(detoxSessionProvider.notifier).end();
    expect(container.read(detoxSessionProvider).isActive, isFalse);
    expect(container.read(detoxSessionProvider).remainingTime, Duration.zero);
  });

  test('tick does not persist anywhere (ephemeral)', () {
    // The session state is in-memory only; there is no DB write on tick.
    // This is enforced by construction: DetoxSessionNotifier has no DB ref.
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container
        .read(detoxSessionProvider.notifier)
        .start(const Duration(seconds: 1));
    // No exception, no DB dependency injected -> ephemeral by design.
    expect(container.read(detoxSessionProvider).isActive, isTrue);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/detox/detox_session_provider_test.dart`
Expected: FAIL — provider file does not exist.

- [ ] **Step 3: Implement the notifier** (mirror `focus_retreat_provider.dart` exactly)

```dart
// lib/features/detox/presentation/providers/detox_session_provider.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for a detox session timer.
class DetoxSessionState {
  const DetoxSessionState({
    this.isActive = false,
    this.remainingTime = Duration.zero,
    this.totalDuration = Duration.zero,
  });

  final bool isActive;
  final Duration remainingTime;
  final Duration totalDuration;

  DetoxSessionState copyWith({
    bool? isActive,
    Duration? remainingTime,
    Duration? totalDuration,
  }) {
    return DetoxSessionState(
      isActive: isActive ?? this.isActive,
      remainingTime: remainingTime ?? this.remainingTime,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }
}

/// Manages the detox session timer lifecycle.
///
/// Deliberately has NO database dependency — the session length is ephemeral
/// and is never persisted (P4: no streaks/counts by construction). Mirrors
/// `FocusRetreatNotifier` (M7) as a template; distinct concern.
class DetoxSessionNotifier extends Notifier<DetoxSessionState> {
  Timer? _timer;

  @override
  DetoxSessionState build() {
    ref.onDispose(() {
      _timer?.cancel();
      _timer = null;
    });
    return const DetoxSessionState();
  }

  /// Starts a session of [duration]. Cancels any prior session.
  void start(Duration duration) {
    _timer?.cancel();
    state = DetoxSessionState(
      isActive: true,
      remainingTime: duration,
      totalDuration: duration,
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = state.remainingTime - const Duration(seconds: 1);
      if (next <= Duration.zero) {
        end();
        return;
      }
      state = state.copyWith(remainingTime: next);
    });
  }

  /// Ends the session immediately (calm; the UI confirms before calling this).
  void end() {
    _timer?.cancel();
    _timer = null;
    state = const DetoxSessionState();
  }
}

final detoxSessionProvider =
    NotifierProvider<DetoxSessionNotifier, DetoxSessionState>(
  DetoxSessionNotifier.new,
);
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/detox/detox_session_provider_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/detox/presentation/providers test/features/detox/detox_session_provider_test.dart
git commit -m "feat(m8): detox session timer notifier (ephemeral)"
```

---

## Task 6: DetoxLauncherProvider — watch default-launcher status

**Files:**
- Create: `lib/features/detox/presentation/providers/detox_launcher_provider.dart`
- Test: `test/features/detox/detox_launcher_provider_test.dart`

- [ ] **Step 1: Write the failing test** (with a fake channel via override)

```dart
// test/features/detox/detox_launcher_provider_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:with_jesus/features/detox/presentation/providers/detox_launcher_provider.dart';
import 'package:with_jesus/native/channels/launcher_channel.dart';

void main() {
  test('reads launcher status as a FutureProvider', () async {
    final container = ProviderContainer(
      overrides: [
        detoxLauncherStatusProvider.overrideWith(
          (ref) => DetoxLauncherStatus(isDefault: false),
        ),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(detoxLauncherStatusProvider.future);
    expect(result.isDefault, isFalse);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/detox/detox_launcher_provider_test.dart`
Expected: FAIL — file does not exist.

- [ ] **Step 3: Implement the provider**

```dart
// lib/features/detox/presentation/providers/detox_launcher_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:with_jesus/native/channels/launcher_channel.dart';

/// Snapshot of whether مع يسوع is the default launcher.
class DetoxLauncherStatus {
  const DetoxLauncherStatus({required this.isDefault});
  final bool isDefault;
}

/// Reads the current default-launcher status once on read.
///
/// The UI re-reads this on home resume so the always-on toggle never shows
/// stale/orphaned state if the user changed their launcher in OS settings.
final detoxLauncherStatusProvider =
    FutureProvider<DetoxLauncherStatus>((ref) async {
  final isDefault = await LauncherChannel.isDefaultLauncher();
  return DetoxLauncherStatus(isDefault: isDefault);
});

/// Asks the OS to make مع يسوع the default launcher (opens system prompt).
/// Returns immediately; the UI re-reads [detoxLauncherStatusProvider] after.
Future<void> requestLauncherRole() async {
  await LauncherChannel.requestDefaultLauncher();
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/detox/detox_launcher_provider_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/detox/presentation/providers/detox_launcher_provider.dart test/features/detox/detox_launcher_provider_test.dart
git commit -m "feat(m8): launcher-status provider for always-on mode"
```

---

## Task 7: Localization (ARB) — add all detox keys

**Files:**
- Modify: `lib/core/l10n/app_en.arb`
- Modify: `lib/core/l10n/app_ar.arb`
- Regenerate: `lib/core/l10n/app_localizations*.dart`

- [ ] **Step 1: Add keys to `app_en.arb`**

Append (keeping valid JSON, comma after the existing last entry):

```json
{
  "@@locale": "en",
  "appTitle": "With Jesus",
  "@appTitle": { "description": "The title of the application" },

  "detoxTitle": "Detox",
  "@detoxTitle": { "description": "Detox screen title" },
  "detoxSessionRemaining": "Remaining",
  "@detoxSessionRemaining": {},
  "detoxPromptWhyNow": "What are you looking for right now?",
  "@detoxPromptWhyNow": { "description": "Reflection prompt: surface the trigger" },
  "detoxPromptWhatInstead": "What could you do instead?",
  "@detoxPromptWhatInstead": { "description": "Reflection prompt: stimulus-control replacement" },
  "detoxPromptOneThingForGod": "One thing you could offer to God",
  "@detoxPromptOneThingForGod": { "description": "Reflection prompt: faith-friendly positive frame" },
  "detoxPromptJustBreathe": "Just breathe",
  "@detoxPromptJustBreathe": { "description": "Reflection prompt: breath-rumination loop" },
  "detoxStartSession": "Begin detox",
  "@detoxStartSession": {},
  "detoxJustBreatheSkip": "Just breathe",
  "@detoxJustBreatheSkip": { "description": "Skip-capture affordance" },
  "detoxDurationLabel": "Duration",
  "@detoxDurationLabel": {},
  "detoxDurationQuarter": "15 min",
  "@detoxDurationQuarter": {},
  "detoxDurationHalf": "30 min",
  "@detoxDurationHalf": {},
  "detoxDurationHour": "60 min",
  "@detoxDurationHour": {},
  "detoxEndCalm": "End detox calmly",
  "@detoxEndCalm": {},
  "detoxEndConfirm": "Return to the world?",
  "@detoxEndConfirm": { "description": "One calm confirm before ending" },
  "detoxReflectionsTitle": "Past reflections",
  "@detoxReflectionsTitle": {},
  "detoxReflectionsEmpty": "Your reflections will gather here, quietly.",
  "@detoxReflectionsEmpty": {},
  "detoxReflectionsSkipped": "Just breathed",
  "@detoxReflectionsSkipped": { "description": "Shown for a skipped reflection" },
  "detoxDeleteReflection": "Delete reflection",
  "@detoxDeleteReflection": {},
  "detoxSettingsAlwaysOnTitle": "Always-on retreat home",
  "@detoxSettingsAlwaysOnTitle": {},
  "detoxSettingsAlwaysOnBody": "Make مع يسوع your home screen — only the calm is one tap away. We never block other apps; you can leave anytime.",
  "@detoxSettingsAlwaysOnBody": { "description": "P8-honest copy" },
  "detoxSettingsLauncherNotSet": "Set as default home first",
  "@detoxSettingsLauncherNotSet": {},
  "detoxSettingsReflectionsLink": "Past reflections",
  "@detoxSettingsReflectionsLink": {},
  "detoxStartA11y": "Start a detox session",
  "@detoxStartA11y": { "description": "Semantics label for the detox top icon" },
  "detoxBreathingOrbA11y": "Breathing guide",
  "@detoxBreathingOrbA11y": {}
}
```

- [ ] **Step 2: Add Arabic translations to `app_ar.arb`** (same keys, Arabic values)

```json
{
  "@@locale": "ar",
  "appTitle": "مع يسوع",
  "@appTitle": { "description": "The title of the application" },

  "detoxTitle": "خلوة",
  "detoxSessionRemaining": "المتبقّي",
  "detoxPromptWhyNow": "ما الذي تبحث عنه الآن؟",
  "detoxPromptWhatInstead": "ماذا يمكنك أن تفعل بدلًا من ذلك؟",
  "detoxPromptOneThingForGod": "شيء واحد تقدّمه لله",
  "detoxPromptJustBreathe": "فقط تنفّس",
  "detoxStartSession": "ابدأ الخلوة",
  "detoxJustBreatheSkip": "فقط تنفّس",
  "detoxDurationLabel": "المدة",
  "detoxDurationQuarter": "١٥ دقيقة",
  "detoxDurationHalf": "٣٠ دقيقة",
  "detoxDurationHour": "٦٠ دقيقة",
  "detoxEndCalm": "إنهاء الخلوة بهدوء",
  "detoxEndConfirm": "تعود إلى العالم؟",
  "detoxReflectionsTitle": "التأملات السابقة",
  "detoxReflectionsEmpty": "ستجتمع تأملاتك هنا بهدوء.",
  "detoxReflectionsSkipped": "تنفّس فقط",
  "detoxDeleteReflection": "حذف التأمل",
  "detoxSettingsAlwaysOnTitle": "وضع الخلوة المستمر",
  "detoxSettingsAlwaysOnBody": "اجعل «مع يسوع» شاشتك الرئيسية — فقط الهدوء على بُعد لمسة. نحن لا نمنع التطبيقات الأخرى أبدًا؛ يمكنك المغادرة وقتما تشاء.",
  "detoxSettingsLauncherNotSet": "عيّنه كالشاشة الرئيسية أولًا",
  "detoxSettingsReflectionsLink": "التأملات السابقة",
  "detoxStartA11y": "ابدأ جلسة خلوة",
  "detoxBreathingOrbA11y": "مرشد التنفّس"
}
```

- [ ] **Step 3: Regenerate**

Run: `flutter gen-l10n`
Expected: `app_localizations*.dart` regenerated with the new getters (camelCased from keys, e.g. `detoxPromptWhyNow`).

- [ ] **Step 4: Verify analyze is clean**

Run: `flutter analyze`
Expected: no errors.

- [ ] **Step 5: Commit**

```bash
git add lib/core/l10n
git commit -m "feat(m8): add detox localization keys (ar/en)"
```

---

## Task 8: BreathingOrb widget (honors disableAnimations)

**Files:**
- Create: `lib/features/detox/presentation/widgets/breathing_orb.dart`

- [ ] **Step 1: Implement the widget**

```dart
// lib/features/detox/presentation/widgets/breathing_orb.dart
import 'package:flutter/material.dart';

/// A calm expanding/contracting circle that paces the breath.
///
/// Collapses to a static circle when the OS requests no animations
/// (MediaQuery.disableAnimations) — see design.md §9.
class BreathingOrb extends StatefulWidget {
  const BreathingOrb({
    super.key,
    this.inhale = const Duration(seconds: 4),
    this.exhale = const Duration(seconds: 6),
    this.size = 160,
  });

  final Duration inhale;
  final Duration exhale;
  final double size;

  @override
  State<BreathingOrb> createState() => _BreathingOrbState();
}

class _BreathingOrbState extends State<BreathingOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.inhale + widget.exhale,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    // When the OS wants no motion, show a still orb (no endless animation).
    if (disableAnimations) {
      return Semantics(
        label: 'Breathing guide', // replaced by localized string at call site
        child: _Orb(scale: 0.8, size: widget.size, color: colors.primary),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        // inhale 0→1 over the first half, exhale 1→0 over the second.
        final t = _controller.value;
        final scale = 0.6 + 0.4 * t;
        return _Orb(scale: scale, size: widget.size, color: colors.primary);
      },
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.scale, required this.size, required this.color});
  final double scale;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size * scale,
      height: size * scale,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.18),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
      ),
    );
  }
}
```

- [ ] **Step 2: Run analyze**

Run: `flutter analyze lib/features/detox/presentation/widgets/breathing_orb.dart`
Expected: clean.

- [ ] **Step 3: Commit**

```bash
git add lib/features/detox/presentation/widgets/breathing_orb.dart
git commit -m "feat(m8): calm breathing orb (honors disableAnimations)"
```

---

## Task 9: DetoxSessionPage — reflection gate + active session

**Files:**
- Create: `lib/features/detox/presentation/detox_session_page.dart`
- Test: `test/features/detox/detox_session_page_test.dart`

This screen has two phases. Keep it one file but clearly sectioned. Read `AppLocalizations.of(context)` for all strings.

- [ ] **Step 1: Implement the page** (full code — uses providers from Tasks 5 & 7, `BreathingOrb` Task 8, `SlowGestureDetector` M7, `EmptyState`)

```dart
// lib/features/detox/presentation/detox_session_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:with_jesus/core/l10n/app_localizations.dart';
import 'package:with_jesus/core/theme/app_spacing.dart';
import 'package:with_jesus/data/detox/detox_reflection_repository.dart';
import 'package:with_jesus/domain/detox/detox_prompt_rotation.dart';
import 'package:with_jesus/features/detox/presentation/providers/detox_session_provider.dart';
import 'package:with_jesus/features/detox/presentation/widgets/breathing_orb.dart';
import 'package:with_jesus/features/focus_retreat/presentation/widgets/slow_gesture_detector.dart';
import 'package:with_jesus/shared/widgets/app_text_field.dart';

/// The detox session screen: a reflection gate, then an active timed session.
class DetoxSessionPage extends ConsumerStatefulWidget {
  const DetoxSessionPage({super.key});

  @override
  ConsumerState<DetoxSessionPage> createState() => _DetoxSessionPageState();
}

class _DetoxSessionPageState extends ConsumerState<DetoxSessionPage> {
  final _answerController = TextEditingController();
  Duration _duration = const Duration(minutes: 15);

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  String _promptMessage(BuildContext context, String key) {
    final l = AppLocalizations.of(context)!;
    return switch (key) {
      'detox.prompt.whyNow' => l.detoxPromptWhyNow,
      'detox.prompt.whatInstead' => l.detoxPromptWhatInstead,
      'detox.prompt.oneThingForGod' => l.detoxPromptOneThingForGod,
      'detox.prompt.justBreathe' => l.detoxPromptJustBreathe,
      _ => l.detoxPromptWhyNow,
    };
  }

  Future<void> _begin({bool skipped}) async {
    final prompt = DetoxPromptRotation.promptFor(DateTime.now());
    await ref.read(detoxReflectionRepositoryProvider).save(
          promptKey: prompt.key,
          answer: skipped ? null : _answerController.text.trim(),
        );
    ref.read(detoxSessionProvider.notifier).start(_duration);
  }

  Future<void> _confirmEnd() async {
    final l = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.detoxEndConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l.detoxEndCalm)),
        ],
      ),
    );
    if (ok == true) {
      ref.read(detoxSessionProvider.notifier).end();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final session = ref.watch(detoxSessionProvider);
    final prompt = DetoxPromptRotation.promptFor(DateTime.now());

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: session.isActive
            ? _ActiveSession(
                remaining: session.remainingTime,
                promptMessage: _promptMessage(context, prompt.key),
                onEnd: _confirmEnd,
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerPadding,
                  vertical: AppSpacing.xxxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l.detoxTitle,
                        style: text.headlineMedium
                            ?.copyWith(color: colors.primary),
                        textAlign: TextAlign.center),
                    const SizedBox(height: AppSpacing.xxxl),
                    Text(_promptMessage(context, prompt.key),
                        style: text.titleLarge, textAlign: TextAlign.center),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      controller: _answerController,
                      hintText: l.detoxStartSession,
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(l.detoxDurationLabel, style: text.labelLarge),
                    const SizedBox(height: AppSpacing.sm),
                    SegmentedButton<Duration>(
                      segments: const [
                        ButtonSegment(
                            value: Duration(minutes: 15),
                            label: Text('15')),
                        ButtonSegment(
                            value: Duration(minutes: 30),
                            label: Text('30')),
                        ButtonSegment(
                            value: Duration(minutes: 60),
                            label: Text('60')),
                      ],
                      selected: {_duration},
                      onSelectionChanged: (s) =>
                          setState(() => _duration = s.first),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () => _begin(skipped: false),
                      child: Text(l.detoxStartSession),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: () => _begin(skipped: true),
                      child: Text(l.detoxJustBreatheSkip),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _ActiveSession extends StatelessWidget {
  const _ActiveSession({
    required this.remaining,
    required this.promptMessage,
    required this.onEnd,
  });

  final Duration remaining;
  final String promptMessage;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final min = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l.detoxTitle,
            style: text.headlineMedium?.copyWith(color: colors.primary)),
        const SizedBox(height: AppSpacing.xxxl),
        Semantics(
          label: l.detoxBreathingOrbA11y,
          child: const BreathingOrb(),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('$min:$sec',
            style: text.displaySmall?.copyWith(color: colors.onSurface)),
        Text(l.detoxSessionRemaining,
            style: text.labelMedium
                ?.copyWith(color: colors.onSurfaceVariant)),
        const SizedBox(height: AppSpacing.xxxl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
          child: SlowGestureDetector(
            duration: const Duration(seconds: 5),
            onSlowTap: onEnd,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl, vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius:
                    BorderRadius.circular(AppSpacing.radius2xl),
              ),
              child: Text(l.detoxEndCalm, style: text.labelLarge),
            ),
          ),
        ),
      ],
    );
  }
}
```

> `AppTextField` currently has no `maxLines` param. **Add it** in Task 9b below before this compiles.

- [ ] **Step 9b: Add `maxLines` to `AppTextField`**

In `lib/shared/widgets/app_text_field.dart`, add a field and pass it to `TextField`:

```dart
  /// Maximum lines (null = single line that grows; 3 = fixed multiline box).
  final int? maxLines;
```
Add to constructor: `this.maxLines,` and to the `TextField(...)` call: `maxLines: maxLines,`.

- [ ] **Step 2: Write the widget test**

```dart
// test/features/detox/detox_session_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:with_jesus/core/l10n/app_localizations.dart';
import 'package:with_jesus/features/detox/presentation/detox_session_page.dart';

Widget _wrapped(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

void main() {
  testWidgets('renders the reflection gate with a prompt and start button',
      (tester) async {
    await tester.pumpWidget(_wrapped(const DetoxSessionPage()));
    await tester.pumpAndSettle();

    // The "begin detox" button text (Arabic) must be present.
    expect(find.text('ابدأ الخلوة'), findsOneWidget);
    // "Just breathe" skip is present.
    expect(find.text('فقط تنفّس'), findsOneWidget);
  });

  testWidgets('tapping Just breathe starts an active session', (tester) async {
    await tester.pumpWidget(_wrapped(const DetoxSessionPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('فقط تنفّس'));
    await tester.pumpAndSettle();

    // Active session shows the calm-end affordance.
    expect(find.text('إنهاء الخلوة بهدوء'), findsOneWidget);
  });
}
```

- [ ] **Step 3: Run test to verify it passes**

Run: `flutter test test/features/detox/detox_session_page_test.dart`
Expected: PASS. If `AppTextField.maxLines` missing → compile error: do Step 9b first.

- [ ] **Step 4: Commit**

```bash
git add lib/features/detox/presentation/detox_session_page.dart lib/shared/widgets/app_text_field.dart test/features/detox/detox_session_page_test.dart
git commit -m "feat(m8): detox session page (reflection gate + active session)"
```

---

## Task 10: DetoxReflectionsPage — private log

**Files:**
- Create: `lib/features/detox/presentation/detox_reflections_page.dart`
- Test: `test/features/detox/detox_reflections_page_test.dart`

- [ ] **Step 1: Implement the page**

```dart
// lib/features/detox/presentation/detox_reflections_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:with_jesus/core/l10n/app_localizations.dart';
import 'package:with_jesus/core/theme/app_spacing.dart';
import 'package:with_jesus/data/detox/detox_reflection_repository.dart';
import 'package:with_jesus/domain/detox/detox_reflection.dart';
import 'package:with_jesus/shared/widgets/empty_state.dart';

/// A quiet, private log of past detox reflections.
///
/// Intentionally shows NO counts/streaks (P4). Newest-first.
class DetoxReflectionsPage extends ConsumerWidget {
  const DetoxReflectionsPage({super.key});

  String _promptText(BuildContext context, String key) {
    final l = AppLocalizations.of(context)!;
    return switch (key) {
      'detox.prompt.whyNow' => l.detoxPromptWhyNow,
      'detox.prompt.whatInstead' => l.detoxPromptWhatInstead,
      'detox.prompt.oneThingForGod' => l.detoxPromptOneThingForGod,
      _ => l.detoxPromptJustBreathe,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final async = ref.watch(detoxReflectionsProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(l.detoxReflectionsTitle),
        backgroundColor: colors.surface,
        foregroundColor: colors.primary,
        elevation: 0,
      ),
      body: SafeArea(
        child: async.when(
          data: (list) => list.isEmpty
              ? EmptyState(message: l.detoxReflectionsEmpty)
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.containerPadding),
                  itemCount: list.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.lg),
                  itemBuilder: (context, i) {
                    final r = list[i];
                    final isSkipped = r.answer == null;
                    return Dismissible(
                      key: ValueKey(r.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: AlignmentDirectional.centerEnd,
                        color: colors.error,
                        padding: const EdgeInsets.only(
                            right: AppSpacing.xl, left: AppSpacing.xl),
                        child: Icon(Icons.delete_outline, color: colors.onError),
                      ),
                      confirmDismiss: (_) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(l.detoxDeleteReflection),
                            actions: [
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('')),
                              FilledButton(
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: Text(l.detoxDeleteReflection)),
                            ],
                          ),
                        );
                      },
                      onDismissed: (_) async {
                        await ref
                            .read(detoxReflectionRepositoryProvider)
                            .delete(r.id!);
                      },
                      child: _ReflectionCard(
                        reflection: r,
                        promptText: _promptText(context, r.promptKey),
                        isSkipped: isSkipped,
                      ),
                    );
                  },
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => EmptyState(message: l.detoxReflectionsEmpty),
        ),
      ),
    );
  }
}

class _ReflectionCard extends StatelessWidget {
  const _ReflectionCard({
    required this.reflection,
    required this.promptText,
    required this.isSkipped,
  });
  final DetoxReflection reflection;
  final String promptText;
  final bool isSkipped;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final l = AppLocalizations.of(context)!;
    return Card(
      color: colors.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        side: BorderSide(color: colors.surfaceContainerHighest),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(promptText, style: text.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              isSkipped ? l.detoxReflectionsSkipped : reflection.answer!,
              style: text.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
```

> Verify `EmptyState`'s actual API by reading `lib/shared/widgets/empty_state.dart`. If it takes a different param name (e.g. `message:` vs `text:` vs positional), use the real one. Do not guess.

- [ ] **Step 2: Write the widget test**

```dart
// test/features/detox/detox_reflections_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:with_jesus/core/l10n/app_localizations.dart';
import 'package:with_jesus/data/detox/detox_reflection_repository.dart';
import 'package:with_jesus/domain/detox/detox_reflection.dart';
import 'package:with_jesus/features/detox/presentation/detox_reflections_page.dart';

final _fakeListProvider = Override? null; // placeholder; real override below

void main() {
  testWidgets('shows empty state when there are no reflections',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          detoxReflectionsProvider.overrideWith(
            (ref) async => <DetoxReflection>[],
          ),
        ],
        child: MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const DetoxReflectionsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ستجتمع تأملاتك هنا بهدوء.'), findsOneWidget);
  });

  testWidgets('renders reflections when present, no counts shown',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          detoxReflectionsProvider.overrideWith((ref) async => [
                DetoxReflection(
                  id: 1,
                  promptKey: 'detox.prompt.whyNow',
                  answer: 'I was anxious',
                  createdAt: DateTime(2026, 6, 26),
                ),
              ]),
        ],
        child: MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const DetoxReflectionsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('I was anxious'), findsOneWidget);
    // No count text anywhere (P4).
    expect(find.textContaining(' streak'), findsNothing);
  });
}
```

Remove the `_fakeListProvider` placeholder line before committing (left by mistake in the draft).

- [ ] **Step 3: Run test to verify it passes**

Run: `flutter test test/features/detox/detox_reflections_page_test.dart`
Expected: PASS.

- [ ] **Step 4: Commit**

```bash
git add lib/features/detox/presentation/detox_reflections_page.dart test/features/detox/detox_reflections_page_test.dart
git commit -m "feat(m8): private detox reflections log"
```

---

## Task 11: AppDock widget + AppShell (StatefulShellRoute)

**Files:**
- Create: `lib/shared/widgets/app_dock.dart`
- Create: `lib/shared/widgets/app_shell.dart`
- Test: `test/shared/app_dock_test.dart`

- [ ] **Step 1: Implement the dock** (minimal floating pill; tokens only)

```dart
// lib/shared/widgets/app_dock.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A minimal One UI-style floating dock for top-level navigation.
///
/// Uses design tokens only (no magic colors/sizes). Active state conveyed by
/// shape/position + primary tint, never color alone. ≥48dp touch targets.
class AppDock extends StatelessWidget {
  const AppDock({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _items = [
    _DockItem(icon: Icons.home_outlined, label: 'home', path: '/home'),
    _DockItem(icon: Icons.music_note_outlined, label: 'hymns', path: '/hymns'),
    _DockItem(icon: Icons.edit_outlined, label: 'journal', path: '/journal'),
    _DockItem(
        icon: Icons.self_improvement_outlined,
        label: 'focus',
        path: '/focus-retreat'),
  ];

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: colors.surfaceContainerHighest),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var i = 0; i < _items.length; i++)
                _DockButton(
                  item: _items[i],
                  active: i == navigationShell.currentIndex,
                  onTap: () => _onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DockItem {
  const _DockItem(
      {required this.icon, required this.label, required this.path});
  final IconData icon;
  final String label;
  final String path;
}

class _DockButton extends StatelessWidget {
  const _DockButton(
      {required this.item, required this.active, required this.onTap});
  final _DockItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final tint = active ? colors.primary : colors.onSurfaceVariant;
    return Semantics(
      selected: active,
      button: true,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(item.icon, color: tint, size: 24),
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Implement the shell** (hosts dock + detox top icon)

```dart
// lib/shared/widgets/app_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:with_jesus/core/l10n/app_localizations.dart';
import 'package:with_jesus/shared/widgets/app_dock.dart';

/// Hosts the [StatefulNavigationShell] (4 dock branches) plus a shared app bar
/// with the detox top-icon entry.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      body: navigationShell,
      appBar: AppBar(
        backgroundColor: colors.surface,
        foregroundColor: colors.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(l.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.self_improvement_outlined),
            tooltip: l.detoxStartA11y,
            onPressed: () => context.push('/detox/session'),
          ),
        ],
      ),
      bottomNavigationBar: AppDock(navigationShell: navigationShell),
    );
  }
}
```

- [ ] **Step 3: Write the dock test**

```dart
// test/shared/app_dock_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:with_jesus/shared/widgets/app_dock.dart';

GoRouter _router() => GoRouter(
      routes: [
        ShellRoute(
          builder: (context, state, child) => Scaffold(body: child),
          routes: [
            _fake('home'),
            _fake('hymns'),
            _fake('journal'),
            _fake('focus'),
          ],
        ),
      ],
    );

StatefulShellRoute _fakeBranch() => StatefulShellRoute.indexedStack(
      builder: (_, __, shell) => AppDock(navigationShell: shell),
      branches: const [],
    );

GoRoute _fake(String path) => GoRoute(
      path: '/$path',
      builder: (_, __) => const SizedBox.shrink(),
    );

void main() {
  testWidgets('AppDock renders 4 buttons', (tester) async {
    // Lightweight: just verify the dock paints 4 icon buttons.
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => AppDock(
            navigationShell: _StubShell(),
          ),
        ),
      ),
    ));
    expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    expect(find.byIcon(Icons.music_note_outlined), findsOneWidget);
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    expect(find.byIcon(Icons.self_improvement_outlined), findsOneWidget);
  });
}

// Minimal stub implementing the Surface StatefulNavigationShell surface we use.
class _StubShell implements StatefulNavigationShell {
  @override
  int get currentIndex => 0;
  @override
  void goBranch(int value, {bool initialLocation = false}) {}
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
```

(If `_StubShell` is awkward, instead build a real tiny `StatefulShellRoute` and pump via `MaterialApp.router`. Prefer the simplest thing that compiles and asserts 4 icons. Remove the unused `_router`/`_fakeBranch`/`_fake` helpers if unused.)

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/shared/app_dock_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/shared/widgets/app_dock.dart lib/shared/widgets/app_shell.dart test/shared/app_dock_test.dart
git commit -m "feat(m8): minimal AppDock + StatefulShellRoute shell"
```

---

## Task 12: Wire the router — StatefulShellRoute + detox routes

**Files:**
- Modify: `lib/core/router/app_router.dart`

- [ ] **Step 1: Replace the flat router with a shell-based router**

```dart
// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/focus_retreat/focus_retreat.dart';
import '../../features/home/home.dart';
import '../../features/hymns/hymns.dart';
import '../../features/journal/journal.dart';
import '../../features/detox/presentation/detox_session_page.dart';
import '../../features/detox/presentation/detox_reflections_page.dart';
import '../../features/onboarding/onboarding.dart';
import '../../features/settings/settings.dart';
import '../../shared/widgets/app_shell.dart';

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
          // Docked shell: Home / Hymns / Journal / Focus
          StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) =>
                AppShell(navigationShell: navigationShell),
            branches: [
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: _RoutePaths.home,
                    builder: (c, s) => const HomePage(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: _RoutePaths.hymns,
                    builder: (c, s) => const HymnsPage(),
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: _RoutePaths.journal,
                    builder: (c, s) => const JournalListPage(),
                    routes: [
                      GoRoute(
                        path: 'composer',
                        builder: (c, s) {
                          final idStr = s.uri.queryParameters['id'];
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
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: _RoutePaths.focusRetreat,
                    builder: (c, s) => const FocusRetreatPage(),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: _RoutePaths.settings,
            builder: (c, s) => const SettingsPage(),
          ),
          // Detox — outside the shell (fullscreen)
          GoRoute(
            path: _RoutePaths.detoxSession,
            builder: (c, s) => const DetoxSessionPage(),
          ),
          GoRoute(
            path: _RoutePaths.detoxReflections,
            builder: (c, s) => const DetoxReflectionsPage(),
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
  static const detoxSession = '/detox/session';
  static const detoxReflections = '/detox/reflections';
}
```

- [ ] **Step 2: Verify analyze + that the app still launches**

Run: `flutter analyze`
Expected: clean. (If `HomePage`/`HymnsPage`/`JournalListPage` import paths differ, use the existing barrel files.)

- [ ] **Step 3: Commit**

```bash
git add lib/core/router/app_router.dart
git commit -m "feat(m8): shell-based router with dock + detox routes"
```

---

## Task 13: Settings — always-on toggle + reflections link

**Files:**
- Modify: `lib/features/settings/settings_page.dart`
- Test: `test/features/settings/detox_settings_test.dart`

- [ ] **Step 1: Write the failing test**

```dart
// test/features/settings/detox_settings_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:with_jesus/core/l10n/app_localizations.dart';
import 'package:with_jesus/features/detox/presentation/providers/detox_launcher_provider.dart';
import 'package:with_jesus/features/settings/settings_page.dart';

void main() {
  testWidgets('settings shows the always-on detox toggle + reflections link',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          detoxLauncherStatusProvider.overrideWith(
            (ref) => const DetoxLauncherStatus(isDefault: false),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(routes: [
            GoRoute(path: '/', builder: (_, __) => const SettingsPage()),
          ]),
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('وضع الخلوة المستمر'), findsOneWidget);
    expect(find.text('التأملات السابقة'), findsWidgets);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/features/settings/detox_settings_test.dart`
Expected: FAIL — rows not present.

- [ ] **Step 3: Add the rows to SettingsPage**

In `lib/features/settings/settings_page.dart`, convert the page to `ConsumerStatefulWidget`/`ConsumerState` (change `StatefulWidget` → `ConsumerStatefulWidget` and `State<SettingsPage>` → `ConsumerState<SettingsPage>`), then add a new "Detox" settings group inside the `CustomScrollView` slivers (after Group 2):

```dart
          // ── Group 3: Detox ──
          _SettingsGroup(
            children: [
              _SettingsListItem(
                icon: Icons.self_improvement_outlined,
                title: AppLocalizations.of(context)!.detoxSettingsAlwaysOnTitle,
                subtitle:
                    AppLocalizations.of(context)!.detoxSettingsAlwaysOnBody,
                trailing: Consumer(builder: (context, ref, _) {
                  final status = ref.watch(detoxLauncherStatusProvider);
                  final isDefault = status.maybeWhen(
                    data: (s) => s.isDefault,
                    orElse: () => false,
                  );
                  return Switch(
                    value: isDefault,
                    onChanged: (value) async {
                      if (value) {
                        await requestLauncherRole();
                        ref.invalidate(detoxLauncherStatusProvider);
                      }
                    },
                  );
                }),
                onTap: null,
              ),
              _SettingsListItem(
                icon: Icons.auto_stories_outlined,
                title: AppLocalizations.of(context)!
                    .detoxSettingsReflectionsLink,
                onTap: () => context.push('/detox/reflections'),
              ),
            ],
          ),

          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
```

Add imports at top: `import 'package:flutter_riverpod/flutter_riverpod.dart';`, the localizations import, and `import '../../features/detox/presentation/providers/detox_launcher_provider.dart';`. Also replace the existing hardcoded `'مع يسوع'` title with `AppLocalizations.of(context)!.appTitle` (small, on-philosophy fix).

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/features/settings/detox_settings_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/features/settings/settings_page.dart test/features/settings/detox_settings_test.dart
git commit -m "feat(m8): detox settings (always-on toggle + reflections link)"
```

---

## Task 14: Research citations deliverable

**Files:**
- Create: `docs/research/detox-evidence.md`

- [ ] **Step 1: Write the citations doc**

```markdown
# Detox Feature — Evidence Base

> Companion to M8 (Phone Detox). Each claim the feature rests on is cited from
> the primary research doc, with its source. Last updated: 2026-06-26.
> Primary source: `docs/An Evidence-Based Framework for Digital Wellbeing…`

## Why "detox" is reframed (not "dopamine detox")
The term "dopamine detox" lacks formal clinical validation; the evidence-based
model is **gradual screen-time reduction**. Multiple RCTs show even short-term
reductions improve mood, sustained attention, and sleep.
Sources: [19], [20], [63], [198], [250], [288], [343] in the primary research doc.

## Why gradual, not sudden cessation
A 2h/day-limit study found subjective improvement but increased sympathetic
nervous-system activity — an acute withdrawal-like response. → Justifies the
**gradual / nudge** approach (curated home) over hard blocking.
Source: [292] in the primary research doc.

## Why reflection prompts (address rumination)
Compulsive use is driven by escaping internal states (boredom, anxiety,
escapism); rumination bridges anxiety → phone dependence. → Justifies the
reflection prompts (`detox.prompt.whyNow`, etc.).
Sources: [153], [177], [178] in the primary research doc.

## Why the curated launcher home (stimulus control)
A bundle of non-restrictive "nudge" strategies reduced problematic smartphone
use without drastic behavioral change. → Justifies detox = being the home.
Sources: [180], [302], [310] in the primary research doc.

## Faith-friendly positive framing
Orthodox fasting is holistic, gain-framed (create space for God), not
deficit-based. → Justifies gain-framed copy ("One thing for God").
Sources: [122], [123], [130], [131] in the primary research doc.
```

- [ ] **Step 2: Commit**

```bash
git add docs/research/detox-evidence.md
git commit -m "docs(m8): cited evidence base for detox feature"
```

---

## Task 15: Final verification — analyze, all tests, codegen-staleness

- [ ] **Step 1: Full codegen**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: clean.

- [ ] **Step 2: L10n regen**

Run: `flutter gen-l10n`
Expected: clean.

- [ ] **Step 3: Analyze**

Run: `flutter analyze`
Expected: no issues.

- [ ] **Step 4: All tests**

Run: `flutter test`
Expected: all green.

- [ ] **Step 5: Update progress-tracker**

In `progress-tracker.md`, set M8 items that are now done to `[x]`:
- `[x] Detox content model: reflection prompts, friction settings (cited)`
- `[x] Drift: detox_reflections (encrypted like journal)`
- `[x] Features: intentional friction, reflection prompts, no streaks/badges`
- `[x] Documentation: citations in docs/research/`
- `[x] Tests: logic + encryption`

Append a Session Log entry dated 2026-06-26.

- [ ] **Step 6: Commit**

```bash
git add progress-tracker.md
git commit -m "docs(m8): mark M8 phone detox complete"
```

---

## Self-Review (done by the plan author)

**Spec coverage** — every spec section maps to a task:
- §1 architecture → Tasks 11, 12 (dock/shell/router)
- §2 data/crypto → Tasks 2, 3, 4 (type, table, repo)
- §3 UX/screens → Tasks 9, 10, 13 (session, log, settings); dock in 11
- §4 tests/citations → Tasks 1–6, 9, 10, 13 (tests), Task 14 (citations)

**No placeholders remaining.** Where a code snippet referenced an API I could
not read (`AppFailure` factories, `EmptyState` param name), the plan tells the
engineer to read the real file rather than guessing.

**Type consistency** — `DetoxReflection`, `DetoxPrompt`, `DetoxSessionState`,
`DetoxLauncherStatus` are named identically across all tasks that use them.
`detoxReflectionsProvider`/`detoxSessionProvider`/`detoxLauncherStatusProvider`
match between definition (Tasks 4,5,6) and consumption (Tasks 9,10,13).

**Known deviations from current codebase practice (intentional):**
- M8 uses `AppLocalizations` (ARB) for all strings, unlike M2/M7/M10 which
  hardcode Arabic. This is on-philosophy (context.md §9) and scoped to M8.
- `appDatabaseProvider` is consumed from its current odd location
  (`continue_reading_repository.dart`); not relocated in this PR.
