import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:with_jesus/data/database/app_database.dart';

/// Repository for the single-row [ContinueReading] table that tracks the
/// user's last-read Bible passage so they can resume from where they left off.
class ContinueReadingRepository {
  final AppDatabase _db;

  ContinueReadingRepository(this._db);

  /// Returns the current [ContinueReadingData] row, or `null` if no reading
  /// has ever been saved.
  Future<ContinueReadingData?> get() async {
    final rows = await _db.select(_db.continueReading).get();
    return rows.isNotEmpty ? rows.first : null;
  }

  /// Upserts the continue-reading record (always row id=1) with the given
  /// [book], [chapter], optional [verse], and [appUsed] identifier.
  Future<void> upsert({
    required String book,
    required int chapter,
    int? verse,
    required String appUsed,
  }) async {
    await _db.into(_db.continueReading).insertOnConflictUpdate(
          ContinueReadingCompanion(
            id: const Value(1),
            book: Value(book),
            chapter: Value(chapter),
            verse: Value(verse),
            appUsed: Value(appUsed),
            updatedAt: Value(DateTime.now().toIso8601String()),
          ),
        );
  }
}

// ---------------------------------------------------------------------------
// Riverpod providers
// ---------------------------------------------------------------------------

/// Provides the singleton [AppDatabase] instance.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// Provides the [ContinueReadingRepository] wired to the database.
final continueReadingRepositoryProvider =
    Provider<ContinueReadingRepository>((ref) {
  return ContinueReadingRepository(ref.watch(appDatabaseProvider));
});

/// Provides the current [ContinueReadingData] (nullable) so UI can reactively
/// display the "continue reading" banner or an empty state.
final continueReadingProvider =
    FutureProvider<ContinueReadingData?>((ref) {
  return ref.watch(continueReadingRepositoryProvider).get();
});
