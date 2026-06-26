/// A hymn or liturgical track scanned from the device's local storage.
///
/// Each [Hymn] represents a single audio file with metadata (title, artist,
/// album) and a local URI for playback. Duration is optional since not all
/// audio sources provide accurate duration metadata.
class Hymn {
  /// Creates a hymn with the given metadata.
  const Hymn({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    this.duration,
    required this.uri,
  });

  /// Unique identifier for the track (e.g. `MediaStore.Audio` ID).
  final String id;

  /// Display title of the hymn.
  final String title;

  /// Artist or chanter name.
  final String artist;

  /// Album or collection name.
  final String album;

  /// Playback duration, if available from metadata.
  final Duration? duration;

  /// Local file or content URI suitable for `just_audio` playback.
  ///
  /// Supported schemes: `file://`, `content://`, `asset:///`.
  final String uri;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Hymn &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          artist == other.artist &&
          album == other.album &&
          duration == other.duration &&
          uri == other.uri;

  @override
  int get hashCode => Object.hash(id, title, artist, album, duration, uri);

  @override
  String toString() => 'Hymn(id: $id, title: $title, artist: $artist)';
}
