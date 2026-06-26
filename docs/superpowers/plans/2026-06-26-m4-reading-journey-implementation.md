# M4 — Reading Journey Implementation Plan

> **For agentic workers:** Tasks are tightly coupled (each depends on the previous). Execute sequentially.

**Goal:** Track accepted chapter suggestions so they don't reappear. No server, no daily plan, no history UI.

**Architecture:** Add Drift `ReadingHistory` table (schema v2), create `ReadingJourneyRepository`, update `BibleRandomizerService` to exclude already-read chapters, wire saving into JourneyGrid's "موافق" dialog.

**Tech Stack:** Drift, Riverpod, Flutter

---

### Task 1: Add `ReadingHistory` Drift Table

**Files:**
- Modify: `lib/data/database/app_database.dart`
- Run: `dart run build_runner build --delete-conflicting-outputs`

1. Add a `ReadingHistory` table class at the top of `app_database.dart` (before the database class):

```dart
class ReadingHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get book => text()();
  IntColumn get chapter => integer()();
  TextColumn get category => text()();
  TextColumn get readAt => text()(); // ISO-8601

  @override
  Set<Column> get primaryKey => {book, chapter};
}
```

2. Add `ReadingHistory` to the `@DriftDatabase` annotation:
```dart
@DriftDatabase(tables: [ReadingHistory])
```

3. Bump `schemaVersion` from `1` to `2`:
```dart
@override
int get schemaVersion => 2;
```

4. Add `onUpgrade` migration:
```dart
onUpgrade: (Migrator m, int from, int to) async {
  if (from < 2) {
    await m.createTable(const ReadingHistory());
  }
},
```

5. Run build_runner and verify no errors.

---

### Task 2: Create `ReadingJourneyRepository`

**Files:**
- Create: `lib/data/reading_journey/reading_journey_repository.dart`
- Create: `lib/data/reading_journey/reading_journey.dart` (barrel)

1. Create `reading_journey_repository.dart` with a simple repository that wraps the Drift DAO:

```dart
import 'package:with_jesus/data/database/app_database.dart';

class ReadingJourneyRepository {
  final AppDatabase _db;

  ReadingJourneyRepository(this._db);

  Future<void> addReadEntry(String book, int chapter, String category) async {
    await _db.into(_db.readingHistory).insertOnConflictUpdate(
          ReadingHistoryCompanion(
            book: Value(book),
            chapter: Value(chapter),
            category: Value(category),
            readAt: Value(DateTime.now().toIso8601String()),
          ),
        );
  }

  Future<Set<String>> getReadKeys() async {
    final rows = await _db.select(_db.readingHistory).get();
    return rows.map((r) => '${r.book}:${r.chapter}').toSet();
  }
}
```

2. Create barrel file `reading_journey.dart` that exports the repository.

3. Verify `flutter analyze` passes.

---

### Task 3: Update `BibleRandomizerService` with Exclusion

**Files:**
- Modify: `lib/domain/bible/bible_randomizer_service.dart`

1. Add `Set<String>? exclude` parameter to `randomForCategory`:

```dart
({String book, int chapter}) randomForCategory(
  String category, {
  Set<String>? exclude,
}) {
  final books = _booksByCategory[category];
  if (books == null || books.isEmpty) {
    throw ArgumentError('Unknown category: $category');
  }

  final entry = books[_random.nextInt(books.length)];
  final book = entry.book;
  final chapter = _random.nextInt(entry.chapters) + 1;

  // If excluded and matches a previous reading, reroll
  final key = '$book:$chapter';
  if (exclude != null && exclude.contains(key)) {
    // Simple recursion — unlikely to stack since most chapters are unread
    return randomForCategory(category, exclude: exclude);
  }

  return (book: book, chapter: chapter);
}
```

2. Verify `flutter analyze` passes.

---

### Task 4: Wire Up JourneyGrid with History

**Files:**
- Modify: `lib/features/home/presentation/widgets/journey_grid.dart`

1. In `_RandomizerDialogState`, add:
   - `Set<String> _readHistory = {};`
   - `final _journeyRepo = ReadingJourneyRepository(AppDatabase());` (or inject via constructor — but for now direct instantiation is fine since AppDatabase is a singleton)

2. In `initState`, load the read history before the first reroll:
```dart
@override
void initState() {
  super.initState();
  _loadHistory();
}

Future<void> _loadHistory() async {
  final history = await _journeyRepo.getReadKeys();
  if (!mounted) return;
  setState(() => _readHistory = history);
  _reroll();
}
```

3. Update `_reroll` to pass `_readHistory` as exclude:
```dart
void _reroll() {
  setState(() {
    _suggestion = _randomizer.randomForCategory(
      widget.category,
      exclude: _readHistory,
    );
  });
}
```

4. In `_onRead`, save the entry after launching the app (or if no app installed, just save anyway):
```dart
Future<void> _onRead() async {
  // Save to reading history
  await _journeyRepo.addReadEntry(
    _suggestion.book,
    _suggestion.chapter,
    widget.category,
  );

  final apps = await _repository.getInstalledApps();
  if (apps.isEmpty) {
    await _repository.openStore(_repository.getSupportedApps().first);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('يرجى تثبيت تطبيق للكتاب المقدس من المتجر')),
    );
    return;
  }

  final ref = 'https://www.bible.com/bible/${_suggestion.book}/${_suggestion.chapter}';
  final launched = await _repository.launchApp(apps.first, deepRef: ref);
  if (!launched) {
    await _repository.launchApp(apps.first);
  }

  if (mounted) Navigator.pop(context);
}
```

5. Verify `flutter analyze` passes.

---

### Task 5: Run Build Runner + Analyze + Commit

1. `dart run build_runner build --delete-conflicting-outputs`
2. `flutter analyze`
3. Commit:
```bash
git add -A && git commit -m "feat(reading): add reading history tracking with Drift and exclusion-based randomizer"
```
