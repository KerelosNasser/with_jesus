import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:with_jesus/core/result/result.dart';
import 'package:with_jesus/data/detox/detox_reflection_repository.dart';
import 'package:with_jesus/data/journal/journal_providers.dart';
import 'package:with_jesus/data/reading_journey/continue_reading_repository.dart';
import 'package:with_jesus/domain/detox/detox_reflection.dart';

/// Provides the singleton [DetoxReflectionRepository] wired to the database
/// and crypto.
final detoxReflectionRepositoryProvider =
    Provider<DetoxReflectionRepository>((ref) {
  return DetoxReflectionRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(journalCryptoProvider),
  );
});

/// Internal stream provider that watches for DB changes on the
/// `detoxReflections` table and emits a signal each time.
///
/// Consumers should use [detoxReflectionsProvider] instead.
final _detoxReflectionsStreamProvider =
    StreamProvider.autoDispose<void>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.streamForReflections().map((_) {});
});

/// Provides the list of all detox reflections (decrypted), re-fetched
/// whenever the database table changes.
///
/// Consumers see an empty list when there are no reflections or when all
/// entries fail to decrypt.
final detoxReflectionsProvider =
    FutureProvider.autoDispose<Result<List<DetoxReflection>>>((ref) {
  // Watch the stream to trigger refetch on every DB change.
  ref.watch(_detoxReflectionsStreamProvider);
  final repo = ref.watch(detoxReflectionRepositoryProvider);
  return repo.getAll();
});
