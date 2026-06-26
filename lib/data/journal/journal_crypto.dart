import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// AES-256-GCM encryption service for journal entries.
///
/// A single 32-byte master key is generated on first use and persisted via
/// [FlutterSecureStorage] (backed by the Android Keystore on supported
/// hardware). All plaintext is encrypted with this key before entering the
/// database; only ciphertext, nonce (IV), and MAC are ever stored.
///
/// This class throws on error. Callers (repositories / use-cases) are
/// expected to catch and convert to [Result.failure] for the UI layer.
///
/// ## Usage
///
/// ```dart
/// final crypto = JournalCrypto();
///
/// // Encrypt
/// final box = await crypto.encrypt('My private journal entry');
/// // Store box.cipherText, box.nonce, box.mac.bytes in the DB.
///
/// // Decrypt
/// final plaintext = await crypto.decrypt(
///   SecretBox(cipherText, nonce: nonce, mac: Mac(macBytes)),
/// );
/// ```
final class JournalCrypto {
  static const _masterKeyKey = 'journal_master_key';

  final FlutterSecureStorage _secureStorage;

  /// Cached master key; loaded once, reused for all operations in the
  /// application lifetime.
  SecretKey? _masterKey;

  /// Creates a [JournalCrypto] backed by [secureStorage].
  ///
  /// If [secureStorage] is omitted, a default [FlutterSecureStorage] is used.
  JournalCrypto({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// The AES-256-GCM cipher instance.
  AesGcm get _cipher => AesGcm.with256bits();

  /// Returns the master [SecretKey], loading it from secure storage or
  /// generating a fresh 32-byte key and persisting it.
  Future<SecretKey> _getMasterKey() async {
    if (_masterKey != null) return _masterKey!;

    final stored = await _secureStorage.read(key: _masterKeyKey);
    if (stored != null) {
      _masterKey = SecretKey(base64Decode(stored));
    } else {
      final random = Random.secure();
      final bytes = List<int>.generate(32, (_) => random.nextInt(256));
      _masterKey = SecretKey(bytes);
      await _secureStorage.write(
        key: _masterKeyKey,
        value: base64Encode(bytes),
      );
    }
    return _masterKey!;
  }

  /// Encrypts [plaintext] using AES-256-GCM with a random nonce (IV).
  ///
  /// Returns a [SecretBox] containing:
  /// - [cipherText] — the encrypted payload
  /// - [nonce] — the 12-byte random IV used for this encryption
  /// - [mac] — the 16-byte authentication tag (MAC)
  ///
  /// All three fields must be stored together and provided back in the same
  /// combination for successful decryption.
  Future<SecretBox> encrypt(String plaintext) async {
    final key = await _getMasterKey();
    final plaintextBytes = utf8.encode(plaintext);
    return _cipher.encrypt(plaintextBytes, secretKey: key);
  }

  /// Decrypts [secretBox] using the master key and returns the original
  /// plaintext string.
  ///
  /// Throws if the key is wrong, the [nonce] doesn't match, or the [mac]
  /// indicates tampering (authenticated encryption guarantees integrity).
  Future<String> decrypt(SecretBox secretBox) async {
    final key = await _getMasterKey();
    final plaintextBytes = await _cipher.decrypt(secretBox, secretKey: key);
    return utf8.decode(plaintextBytes);
  }
}
