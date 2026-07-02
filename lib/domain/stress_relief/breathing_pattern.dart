/// A breathing pattern with configurable phase durations.
///
/// Each pattern defines inhale, hold, exhale, and optional post-exhale hold
/// durations in seconds. The [name] is an ARB localization key.
class BreathingPattern {
  /// ARB localization key for this pattern's display name.
  final String name;

  /// Inhale duration in seconds.
  final int inhaleSeconds;

  /// Hold-after-inhale duration in seconds. 0 means no hold.
  final int holdSeconds;

  /// Exhale duration in seconds.
  final int exhaleSeconds;

  /// Hold-after-exhale duration in seconds. 0 means no hold.
  final int holdAfterExhaleSeconds;

  /// Creates a breathing pattern with the given phase durations.
  const BreathingPattern({
    required this.name,
    required this.inhaleSeconds,
    this.holdSeconds = 0,
    required this.exhaleSeconds,
    this.holdAfterExhaleSeconds = 0,
  });

  /// Total cycle duration.
  Duration get totalDuration => Duration(
    seconds: inhaleSeconds + holdSeconds + exhaleSeconds + holdAfterExhaleSeconds,
  );
}
