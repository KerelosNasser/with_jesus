import 'package:cryptography/cryptography.dart';
import 'package:drift/drift.dart';
import 'package:with_jesus/data/database/app_database.dart' as db;
import 'package:with_jesus/data/journal/journal_crypto.dart';
import 'package:with_jesus/domain/journal/journal_entry.dart';

/// Repository for encrypted journal entries.
///
/// Encrypts `title` and `body` with [JournalCrypto] before writing to the
/// database, and decrypts them on read.  Rows that fail to decrypt are
/// silently skipped so a single corrupt entry never breaks the full list.
class JournalRepository {
  final db.AppDatabase _db;
  final JournalCrypto _crypto;

  /// Creates a repository backed by [db] and [crypto].
  JournalRepository(this._db, this._crypto);

  /// Returns every journal entry with decrypted `title` and `body`.
  ///
  /// Entries whose ciphertext cannot be decrypted are quietly omitted.
  Future<List<JournalEntry>> getAllEntries() async {
    final rows = await _db.select(_db.journalEntries).get();
    final results = <JournalEntry>[];
    for (final row in rows) {
      final entry = await _decryptRow(row);
      if (entry != null) results.add(entry);
    }
    return results;
  }

  /// Returns a single entry by [id], or `null` if it doesn't exist or
  /// decryption fails.
  Future<JournalEntry?> getEntry(int id) async {
    final query = _db.select(_db.journalEntries)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    return _decryptRow(row);
  }

  /// Saves (inserts or updates) a journal entry.
  ///
  /// * If [id] is `null` a new row is inserted, and [createdAt] is set to now.
  /// * If [id] is provided the existing row is updated.
  /// * [updatedAt] is always set to now.
  ///
  /// Returns the `id` of the affected row.
  Future<int> saveEntry({
    int? id,
    required String category,
    required String title,
    required String body,
  }) async {
    final titleBox = await _crypto.encrypt(title);
    final bodyBox = await _crypto.encrypt(body);
    final now = DateTime.now();

    if (id != null) {
      await (_db.update(
        _db.journalEntries,
      )..where((t) => t.id.equals(id))).write(
        db.JournalEntriesCompanion(
          category: Value(category),
          titleNonce: Value(Uint8List.fromList(titleBox.nonce)),
          titleCiphertext: Value(Uint8List.fromList(titleBox.cipherText)),
          titleMac: Value(Uint8List.fromList(titleBox.mac.bytes)),
          bodyNonce: Value(Uint8List.fromList(bodyBox.nonce)),
          bodyCiphertext: Value(Uint8List.fromList(bodyBox.cipherText)),
          bodyMac: Value(Uint8List.fromList(bodyBox.mac.bytes)),
          updatedAt: Value(now),
        ),
      );
      return id;
    } else {
      return _db
          .into(_db.journalEntries)
          .insert(
            db.JournalEntriesCompanion.insert(
              category: category,
              titleNonce: Uint8List.fromList(titleBox.nonce),
              titleCiphertext: Uint8List.fromList(titleBox.cipherText),
              titleMac: Uint8List.fromList(titleBox.mac.bytes),
              bodyNonce: Uint8List.fromList(bodyBox.nonce),
              bodyCiphertext: Uint8List.fromList(bodyBox.cipherText),
              bodyMac: Uint8List.fromList(bodyBox.mac.bytes),
              createdAt: now,
              updatedAt: now,
            ),
          );
    }
  }

  /// Deletes the journal entry with [id].
  Future<void> deleteEntry(int id) async {
    await (_db.delete(_db.journalEntries)..where((t) => t.id.equals(id))).go();
  }

  /// Decrypts a database [row] into a domain [JournalEntry].
  ///
  /// Returns `null` when decryption fails for either the title or the body.
  Future<JournalEntry?> _decryptRow(covariant db.JournalEntry row) async {
    try {
      final title = await _crypto.decrypt(
        SecretBox(
          row.titleCiphertext,
          nonce: row.titleNonce,
          mac: Mac(row.titleMac),
        ),
      );
      final body = await _crypto.decrypt(
        SecretBox(
          row.bodyCiphertext,
          nonce: row.bodyNonce,
          mac: Mac(row.bodyMac),
        ),
      );
      return JournalEntry(
        id: row.id,
        category: row.category,
        title: title,
        body: body,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
      );
    } catch (_) {
      return null;
    }
  }
}
