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

@DriftDatabase(tables: [ReadingHistory, ContinueReading, JournalEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

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
