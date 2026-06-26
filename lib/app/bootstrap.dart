import 'package:audio_service/audio_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/hymns/hymns_audio_handler.dart';

/// Manages async initialization before the app runs.
///
/// Calls [WidgetsFlutterBinding.ensureInitialized] and returns a [ProviderContainer]
/// pre-configured with overrides for initialized singletons (Drift, secure storage,
/// shared preferences, audio handler).
class Bootstrap {
  /// Initialize all async dependencies and return a [ProviderContainer].
  ///
  /// Wires up the [AudioService] and initializes the [HymnsAudioHandler] as a
  /// singleton provider. Future: add Drift, secure storage, shared prefs.
  static Future<ProviderContainer> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Init audio_service for background hymn playback.
    final audioHandler = await AudioService.init(
      builder: () => HymnsAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.with_jesus.hymns',
        androidNotificationChannelName: 'Hymns',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ),
    );

    return ProviderContainer(
      overrides: [
        audioHandlerProvider.overrideWithValue(audioHandler),
      ],
    );
  }
}
