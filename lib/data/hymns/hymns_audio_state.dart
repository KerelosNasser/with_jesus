import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/hymns/hymn.dart';
import 'hymns_audio_handler.dart';

/// Exposes the raw [PlaybackState] from [HymnsAudioHandler].
///
/// Use this provider to react to play/pause, buffering, and error state
/// transitions in the UI (e.g., showing a spinner during buffering,
/// swapping the play/pause icon).
final playbackStateProvider = StreamProvider<PlaybackState>((ref) {
  final handler = ref.watch(audioHandlerProvider);
  return handler.playbackState;
});

/// Exposes the currently playing [Hymn], or `null` when nothing is loaded.
///
/// Listens to [BaseAudioHandler.mediaItem] and converts the [MediaItem] back
/// to a [Hymn] domain model so that the presentation layer never depends on
/// `audio_service` types.
final currentHymnProvider = StreamProvider<Hymn?>((ref) {
  final handler = ref.watch(audioHandlerProvider);
  return handler.mediaItem.map(_mediaItemToHymn);
});

/// Converts an `audio_service` [MediaItem?] back into a domain [Hymn?].
///
/// Fields that cannot be preserved (e.g. artwork uri) are omitted; the core
/// metadata (id, title, artist, album, duration) is round-tripped from the
/// [HymnsAudioHandler._hymnToMediaItem] mapping.
Hymn? _mediaItemToHymn(MediaItem? item) {
  if (item == null) return null;
  return Hymn(
    id: item.id,
    title: item.title,
    artist: item.artist ?? '',
    album: item.album ?? '',
    duration: item.duration,
    uri: '', // Not needed in the UI layer; playback is handled by the handler.
  );
}

/// Exposes the current [PositionData] (position, buffered position, duration).
///
/// This is the most accurate source for a seek bar or progress indicator
/// because it reads directly from the `just_audio` player streams via
/// [HymnsAudioHandler.positionDataStream].
final audioPositionProvider = StreamProvider<PositionData>((ref) {
  final handler = ref.watch(audioHandlerProvider);
  return handler.positionDataStream;
});
