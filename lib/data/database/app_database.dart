import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'app_database.g.dart';

class ReadingHistory extends Table {
  TextColumn get book => text()();
  IntColumn get chapter => integer()();
  TextColumn get category => text()();
  TextColumn get readAt => text()();

  @override
  Set<Column> get primaryKey => {book, chapter};
}

class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text()();
  BlobColumn get titleNonce => blob()();
  BlobColumn get titleCiphertext => blob()();
  BlobColumn get titleMac => blob()();
  BlobColumn get bodyNonce => blob()();
  BlobColumn get bodyCiphertext => blob()();
  BlobColumn get bodyMac => blob()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class ContinueReading extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get book => text()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer().nullable()();
  TextColumn get appUsed => text()();
  TextColumn get updatedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class DetoxReflections extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get promptKey => text()();
  BlobColumn get answerNonce => blob().nullable()();
  BlobColumn get answerCiphertext => blob().nullable()();
  BlobColumn get answerMac => blob().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [ReadingHistory, ContinueReading, JournalEntries, DetoxReflections])
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

  // ---------------------------------------------------------------------------
  // DetoxReflections helpers
  // ---------------------------------------------------------------------------

  /// Returns a reactive stream of all detox reflections, newest first.
  Stream<List<DetoxReflection>> streamForReflections() {
    return (select(detoxReflections)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// Returns all detox reflections from the database, newest first.
  Future<List<DetoxReflection>> getAllReflections() {
    return (select(detoxReflections)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Inserts a new detox reflection row.
  Future<void> insertReflection({
    required String promptKey,
    Uint8List? answerNonce,
    Uint8List? answerCiphertext,
    Uint8List? answerMac,
  }) {
    return into(detoxReflections).insert(
      DetoxReflectionsCompanion.insert(
        promptKey: promptKey,
        answerNonce:
            answerNonce != null ? Value(answerNonce) : Value.absent(),
        answerCiphertext:
            answerCiphertext != null ? Value(answerCiphertext) : Value.absent(),
        answerMac: answerMac != null ? Value(answerMac) : Value.absent(),
        createdAt: DateTime.now(),
      ),
    );
  }

  /// Deletes a detox reflection by [id].
  Future<void> deleteReflection(int id) {
    return (delete(detoxReflections)..where((t) => t.id.equals(id))).go();
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
