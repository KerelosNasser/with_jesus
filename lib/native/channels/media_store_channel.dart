import 'platform_channel_registry.dart' as registry;

class MediaStoreChannel {
  static const _channel = registry.PlatformChannelRegistry.mediaStoreChannel;

  /// Scans the device's audio library for Coptic / Christian media
  /// matching the defined search keywords (title, artist, or album).
  ///
  /// Returns a list of result maps, each containing:
  ///   `id` (String), `title` (String), `artist` (String),
  ///   `album` (String), `duration` (int), `uri` (String).
  static Future<List<Map<String, dynamic>>> scanCopticAudio() async {
    try {
      final result =
          await _channel.invokeMethod<List<dynamic>>('scanCopticAudio');
      if (result == null) return [];
      return result.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }
}
