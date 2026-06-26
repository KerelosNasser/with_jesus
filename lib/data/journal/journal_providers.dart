import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:with_jesus/data/journal/journal_crypto.dart';
import 'package:with_jesus/data/journal/journal_repository.dart';
import 'package:with_jesus/data/reading_journey/continue_reading_repository.dart';
import 'package:with_jesus/domain/journal/journal_entry.dart';

/// Provides the singleton [JournalCrypto] instance.
final journalCryptoProvider = Provider<JournalCrypto>((ref) {
  return JournalCrypto();
});

/// Provides the [JournalRepository] wired to the database and crypto.
final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(journalCryptoProvider),
  );
});

/// Provides the list of all journal entries (decrypted).
///
/// Consumers see an empty list when there are no entries or when all entries
/// fail to decrypt.
final journalEntriesProvider = FutureProvider<List<JournalEntry>>((ref) {
  return ref.watch(journalRepositoryProvider).getAllEntries();
});
