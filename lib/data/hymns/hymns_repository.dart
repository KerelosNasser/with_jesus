import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/core.dart';
import '../../domain/hymns/hymn.dart';
import '../../native/channels/media_store_channel.dart';

/// Scans the device's audio library for Coptic / Christian hymns via the
/// [MediaStoreChannel] and maps the raw platform result into [Hymn] domain
/// models.
class HymnsRepository {
  /// Scans the device for Coptic/Christian audio content.
  ///
  /// Returns a [Result] containing either a list of [Hymn]s or an
  /// [AppFailure] describing what went wrong.
  Future<Result<List<Hymn>>> getHymns() async {
    try {
      final results = await MediaStoreChannel.scanCopticAudio();
      final hymns = results.map(_mapToHymn).toList();
      return Result.success(hymns);
    } catch (e) {
      return const Result<List<Hymn>>.failure(
        PlatformFailure('errors.hymns.scan_failed'),
      );
    }
  }

  Hymn _mapToHymn(Map<String, dynamic> map) {
    final durationMs = map['duration'] as int?;
    return Hymn(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      artist: map['artist'] as String? ?? '',
      album: map['album'] as String? ?? '',
      duration:
          durationMs != null ? Duration(milliseconds: durationMs) : null,
      uri: map['uri'] as String? ?? '',
    );
  }
}

/// Provider for [HymnsRepository].
final hymnsRepositoryProvider = Provider<HymnsRepository>((ref) {
  return HymnsRepository();
});

/// Fetches the list of hymns from the device's audio library.
///
/// Exposes [AsyncValue] so the UI can react to loading/error/data states.
final hymnsProvider = FutureProvider<List<Hymn>>((ref) async {
  final repository = ref.watch(hymnsRepositoryProvider);
  final result = await repository.getHymns();
  return switch (result) {
    Success(data: final hymns) => hymns,
    Failure(failure: final error) => throw error,
  };
});
