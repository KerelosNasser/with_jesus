import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:with_jesus/core/errors/app_failure.dart';
import 'package:with_jesus/core/result/result.dart';
import 'package:with_jesus/data/database/app_database.dart' as db;
import 'package:with_jesus/data/journal/journal_crypto.dart';
import 'package:with_jesus/domain/detox/detox_reflection.dart';

/// Repository for encrypted detox reflections.
///
/// Encrypts the free-text `answer` with [JournalCrypto] before writing to the
/// database, and decrypts it on read.  Rows that fail to decrypt are silently
/// skipped so a single corrupt entry never breaks the full list.
class DetoxReflectionRepository {
  final db.AppDatabase _db;
  final JournalCrypto _crypto;

  /// Creates a repository backed by [db] and [crypto].
  DetoxReflectionRepository(this._db, this._crypto);

  /// Returns every detox reflection with decrypted `answer`.
  ///
  /// Entries whose ciphertext cannot be decrypted are quietly omitted.
  Future<Result<List<DetoxReflection>>> getAll() async {
    try {
      final rows = await _db.getAllReflections();
      final reflections = <DetoxReflection>[];
      for (final row in rows) {
        final reflection = await _decryptRow(row);
        if (reflection != null) reflections.add(reflection);
      }
      return Result.success(reflections);
    } on Object catch (e) {
      return Result.failure(LocalFailure(e.toString()));
    }
  }

  /// Saves a detox reflection.
  ///
  /// When [answer] is non-empty it is encrypted before storage.  Pass
  /// `null` or an empty string to record a "skipped" reflection (no answer).
  Future<Result<void>> save({
    required String promptKey,
    String? answer,
  }) async {
    try {
      if (answer != null && answer.isNotEmpty) {
        final secretBox = await _crypto.encrypt(answer);
        await _db.insertReflection(
          promptKey: promptKey,
          answerNonce: Uint8List.fromList(secretBox.nonce),
          answerCiphertext: Uint8List.fromList(secretBox.cipherText),
          answerMac: Uint8List.fromList(secretBox.mac.bytes),
        );
      } else {
        await _db.insertReflection(promptKey: promptKey);
      }
      return Result.success(null);
    } on Object catch (e) {
      return Result.failure(LocalFailure(e.toString()));
    }
  }

  /// Deletes the reflection with [id].
  Future<Result<void>> delete(int id) async {
    try {
      await _db.deleteReflection(id);
      return Result.success(null);
    } on Object catch (e) {
      return Result.failure(LocalFailure(e.toString()));
    }
  }

  /// Decrypts a database [row] into a domain [DetoxReflection].
  ///
  /// Returns `null` when decryption fails.
  Future<DetoxReflection?> _decryptRow(db.DetoxReflection row) async {
    try {
      String? answer;
      if (row.answerCiphertext != null && row.answerNonce != null) {
        final secretBox = SecretBox(
          row.answerCiphertext!,
          nonce: row.answerNonce!,
          mac: row.answerMac != null ? Mac(row.answerMac!) : Mac.empty,
        );
        answer = await _crypto.decrypt(secretBox);
      }
      return DetoxReflection(
        id: row.id,
        promptKey: row.promptKey,
        answer: answer,
        createdAt: row.createdAt,
      );
    } on Object {
      return null; // Skip undecryptable rows
    }
  }
}
