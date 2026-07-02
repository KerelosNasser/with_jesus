import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

/// Available ambience sounds.
enum AmbienceSound {
  /// Gentle rain.
  rain('assets/ambience/rain.mp3', 'calmAmbienceRain'),

  /// Church bells in the distance.
  churchBells('assets/ambience/church_bells.mp3', 'calmAmbienceChurchBells'),

  /// Soft wind.
  wind('assets/ambience/wind.mp3', 'calmAmbienceWind'),

  /// Chant echo.
  chantEcho('assets/ambience/chant_echo.mp3', 'calmAmbienceChantEcho');

  const AmbienceSound(this.assetPath, this.nameKey);

  /// Path to the bundled audio asset.
  final String assetPath;

  /// ARB localization key for the display name.
  final String nameKey;
}

/// State for the ambience player.
class AmbiencePlayerState {
  /// Creates an [AmbiencePlayerState] with the given values.
  const AmbiencePlayerState({
    this.currentSound,
    this.isPlaying = false,
    this.volume = 1.0,
  });

  /// Currently selected ambience sound, or null if none.
  final AmbienceSound? currentSound;

  /// Whether the ambience is currently playing.
  final bool isPlaying;

  /// Volume level (0.0 to 1.0).
  final double volume;

  /// Creates a copy with the given fields replaced.
  AmbiencePlayerState copyWith({
    AmbienceSound? currentSound,
    bool? isPlaying,
    double? volume,
  }) {
    return AmbiencePlayerState(
      currentSound: currentSound ?? this.currentSound,
      isPlaying: isPlaying ?? this.isPlaying,
      volume: volume ?? this.volume,
    );
  }
}

/// Notifier that manages ambience audio playback.
///
/// Uses a single [AudioPlayer] instance for looping ambient sounds.
/// Does NOT use audio_service — ambience is background-only and
/// doesn't need media notifications.
class AmbiencePlayerNotifier extends Notifier<AmbiencePlayerState> {
  AudioPlayer? _player;

  @override
  AmbiencePlayerState build() {
    ref.onDispose(() {
      _player?.dispose();
      _player = null;
    });
    return const AmbiencePlayerState();
  }

  /// Plays the given [sound], looping indefinitely.
  ///
  /// If another sound is already playing, it is stopped first.
  Future<void> play(AmbienceSound sound) async {
    await stop();

    _player ??= AudioPlayer();

    try {
      await _player!.setAsset(sound.assetPath);
      await _player!.setLoopMode(LoopMode.all);
      await _player!.setVolume(state.volume);
      await _player!.play();
      state = state.copyWith(currentSound: sound, isPlaying: true);
    } catch (_) {
      // If asset fails to load, stay stopped
      state = state.copyWith(isPlaying: false);
    }
  }

  /// Pauses the current ambience.
  Future<void> pause() async {
    await _player?.pause();
    state = state.copyWith(isPlaying: false);
  }

  /// Resumes playing the current ambience.
  Future<void> resume() async {
    if (state.currentSound != null && _player != null) {
      await _player!.play();
      state = state.copyWith(isPlaying: true);
    }
  }

  /// Stops and releases the current ambience.
  Future<void> stop() async {
    await _player?.stop();
    await _player?.seek(Duration.zero);
    state = state.copyWith(isPlaying: false);
  }

  /// Sets the playback volume (0.0 to 1.0).
  Future<void> setVolume(double volume) async {
    final clamped = volume.clamp(0.0, 1.0);
    await _player?.setVolume(clamped);
    state = state.copyWith(volume: clamped);
  }
}

/// Provider for the [AmbiencePlayerNotifier].
final ambiencePlayerProvider =
    NotifierProvider<AmbiencePlayerNotifier, AmbiencePlayerState>(
  AmbiencePlayerNotifier.new,
);
