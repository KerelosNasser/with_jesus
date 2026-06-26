import 'package:drift/drift.dart';
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
