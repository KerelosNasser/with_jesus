import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the detox session timer.
class DetoxSessionState {
  /// Creates a [DetoxSessionState] with the given values.
  const DetoxSessionState({
    this.isActive = false,
    this.remainingTime = Duration.zero,
    this.totalDuration = Duration.zero,
  });

  /// Whether a detox session is currently running.
  final bool isActive;

  /// Time remaining in the current detox session.
  final Duration remainingTime;

  /// Total configured duration of the current detox session.
  final Duration totalDuration;

  /// Returns a copy of this state with the given fields replaced by [isActive],
  /// [remainingTime], and/or [totalDuration].
  DetoxSessionState copyWith({
    bool? isActive,
    Duration? remainingTime,
    Duration? totalDuration,
  }) {
    return DetoxSessionState(
      isActive: isActive ?? this.isActive,
      remainingTime: remainingTime ?? this.remainingTime,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }
}

/// Notifier that manages the detox session timer lifecycle.
///
/// Call [start] to begin a session; the timer decrements
/// [DetoxSessionState.remainingTime] every second. Call [end] to stop early.
/// When the timer reaches zero the session ends automatically.
class DetoxSessionNotifier extends Notifier<DetoxSessionState> {
  Timer? _timer;

  @override
  DetoxSessionState build() {
    ref.onDispose(() {
      _timer?.cancel();
      _timer = null;
    });
    return const DetoxSessionState();
  }

  /// Starts a detox session with the given [duration].
  ///
  /// Any previously running session is cancelled. The timer ticks every
  /// second until [remainingTime] reaches zero, at which point [end] is
  /// called automatically.
  void start(Duration duration) {
    _timer?.cancel();

    state = DetoxSessionState(
      isActive: true,
      remainingTime: duration,
      totalDuration: duration,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final newRemaining = state.remainingTime - const Duration(seconds: 1);

      if (newRemaining <= Duration.zero) {
        end();
        return;
      }

      state = state.copyWith(remainingTime: newRemaining);
    });
  }

  /// Ends the current detox session immediately.
  ///
  /// Cancels the underlying [Timer] and resets [DetoxSessionState] to its
  /// default (inactive) values.
  void end() {
    _timer?.cancel();
    _timer = null;
    state = const DetoxSessionState();
  }
}

/// Provider for the [DetoxSessionNotifier].
///
/// Exposes the [DetoxSessionState] rebuild on every tick. Widgets should
/// watch this provider to react to timer changes.
final detoxSessionProvider =
    NotifierProvider<DetoxSessionNotifier, DetoxSessionState>(
  DetoxSessionNotifier.new,
);
