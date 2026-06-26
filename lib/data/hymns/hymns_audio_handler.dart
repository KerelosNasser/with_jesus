import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/hymns/hymn.dart';

/// Current playback position, buffered position, and total duration.
class PositionData {
  /// Creates a [PositionData] snapshot.
  const PositionData({
    required this.position,
    required this.bufferedPosition,
    required this.duration,
  });

  /// Current playback position.
  final Duration position;

  /// Amount of audio buffered so far.
  final Duration bufferedPosition;

  /// Total duration of the current track.
  final Duration duration;
}

/// Audio handler for hymn playback using `just_audio` + `audio_service`.
///
/// Manages a play queue of [Hymn] items, handles play/pause/seek/skip, and
/// syncs the [AudioPlayer] state to `audio_service`'s [PlaybackState] stream
/// so that Android media notifications and lock-screen controls work correctly.
class HymnsAudioHandler extends BaseAudioHandler {
  final AudioPlayer _player;
  final List<Hymn> _currentHymns = [];

  /// Creates the handler and immediately starts listening to player events.
  HymnsAudioHandler() : _player = AudioPlayer() {
    _player.playbackEventStream.listen(_onPlaybackEvent);
  }

  /// Maps a `just_audio` [ProcessingState] to an `audio_service`
  /// [AudioProcessingState].
  static AudioProcessingState _mapProcessingState(ProcessingState state) {
    return switch (state) {
      ProcessingState.idle => AudioProcessingState.idle,
      ProcessingState.loading => AudioProcessingState.loading,
      ProcessingState.buffering => AudioProcessingState.buffering,
      ProcessingState.ready => AudioProcessingState.ready,
      ProcessingState.completed => AudioProcessingState.completed,
    };
  }

  /// Converts a [Hymn] into an `audio_service` [MediaItem] for the
  /// notification and lock screen.
  static MediaItem _hymnToMediaItem(Hymn hymn) => MediaItem(
        id: hymn.id,
        title: hymn.title,
        artist: hymn.artist,
        album: hymn.album,
        duration: hymn.duration,
      );

  /// Reacts to every [PlaybackEvent] from the [AudioPlayer] and broadcasts
  /// the corresponding [PlaybackState] + [MediaItem] to `audio_service`.
  void _onPlaybackEvent(PlaybackEvent event) {
    // Update the current media item when the track index changes.
    if (event.currentIndex != null &&
        event.currentIndex! < _currentHymns.length) {
      mediaItem.add(_hymnToMediaItem(_currentHymns[event.currentIndex!]));
    }

    playbackState.add(PlaybackState(
      processingState: _mapProcessingState(event.processingState),
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: event.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
        MediaControl.stop,
      ],
      androidCompactActionIndices: const [0, 1, 2],
      systemActions: <MediaAction>{
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
    ));
  }

  /// Loads a list of hymns into the player as a concatenated playlist.
  ///
  /// [hymns] replaces any previously loaded playlist. Optionally starts
  /// playback at [initialIndex].
  Future<void> loadPlaylist(
    List<Hymn> hymns, {
    int initialIndex = 0,
  }) async {
    _currentHymns
      ..clear()
      ..addAll(hymns);

    final mediaItems = hymns.map(_hymnToMediaItem).toList();
    final audioSources = hymns
        .map((h) => AudioSource.uri(Uri.parse(h.uri)))
        .toList();

    queue.add(mediaItems);
    if (mediaItems.isNotEmpty) {
      final clampedIndex = initialIndex.clamp(0, mediaItems.length - 1);
      mediaItem.add(mediaItems[clampedIndex]);
    }

    await _player.setAudioSource(
      ConcatenatingAudioSource(children: audioSources),
      initialIndex: initialIndex,
    );
  }

  /// Plays a specific hymn by [hymnId].
  ///
  /// The hymn must already be in the currently loaded playlist.
  Future<void> playHymn(String hymnId) async {
    final index = _currentHymns.indexWhere((h) => h.id == hymnId);
    if (index >= 0) {
      mediaItem.add(_hymnToMediaItem(_currentHymns[index]));
      await _player.seek(Duration.zero, index: index);
      await _player.play();
    }
  }

  // ---------------------------------------------------------------------------
  // BaseAudioHandler overrides
  // ---------------------------------------------------------------------------

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> stop() async {
    await _player.stop();
    await _player.seek(Duration.zero);
  }

  @override
  Future<void> playFromMediaId(String mediaId, [Map<String, dynamic>? extras]) {
    return playHymn(mediaId);
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index >= 0 && index < _currentHymns.length) {
      mediaItem.add(_hymnToMediaItem(_currentHymns[index]));
      await _player.seek(Duration.zero, index: index);
    }
  }

  @override
  Future<void> onTaskRemoved() async {
    await stop();
  }

  /// Releases the underlying [AudioPlayer].
  Future<void> dispose() => _player.dispose();

  /// Combines the underlying player's position, buffered position, and
  /// duration streams into a single [PositionData] stream.
  ///
  /// This is the preferred way to consume all three values because it uses
  /// `just_audio`'s native stream sources (which are more accurate than
  /// reconstructing from `AudioService`'s aggregated state).
  Stream<PositionData> get positionDataStream => Rx.combineLatest3<
      Duration,
      Duration,
      Duration?,
      PositionData>(
    _player.positionStream,
    _player.bufferedPositionStream,
    _player.durationStream,
    (position, bufferedPosition, duration) => PositionData(
      position: position,
      bufferedPosition: bufferedPosition,
      duration: duration ?? Duration.zero,
    ),
  );
}

/// Provider for the [HymnsAudioHandler] singleton.
///
/// Must be overridden in [Bootstrap.init] after `AudioService.init(...)`
/// has completed.
final audioHandlerProvider = Provider<HymnsAudioHandler>((ref) {
  throw UnimplementedError('Override audioHandlerProvider in Bootstrap.init()');
});
