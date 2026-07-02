import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the calm (prayer) timer.
class CalmTimerState {
  /// Creates a [CalmTimerState] with the given values.
  const CalmTimerState({
    this.isActive = false,
    this.remainingTime = Duration.zero,
    this.totalDuration = Duration.zero,
    this.chimeEnabled = true,
    this.closingText = '',
  });

  /// Whether a timer session is currently running.
  final bool isActive;

  /// Time remaining in the current session.
  final Duration remainingTime;

  /// Total configured duration of the current session.
  final Duration totalDuration;

  /// Whether to play a chime when the timer completes.
  final bool chimeEnabled;

  /// Optional closing text to display when the timer completes.
  final String closingText;

  /// Returns a copy of this state with the given fields replaced.
  CalmTimerState copyWith({
    bool? isActive,
    Duration? remainingTime,
    Duration? totalDuration,
    bool? chimeEnabled,
    String? closingText,
  }) {
    return CalmTimerState(
      isActive: isActive ?? this.isActive,
      remainingTime: remainingTime ?? this.remainingTime,
      totalDuration: totalDuration ?? this.totalDuration,
      chimeEnabled: chimeEnabled ?? this.chimeEnabled,
      closingText: closingText ?? this.closingText,
    );
  }
}

/// Notifier that manages the calm/prayer timer lifecycle.
///
/// Call [start] to begin a session; the timer decrements
/// [CalmTimerState.remainingTime] every second. Call [end] to
/// stop early. When the timer reaches zero the session ends automatically.
class CalmTimerNotifier extends Notifier<CalmTimerState> {
  Timer? _timer;

  @override
  CalmTimerState build() {
    ref.onDispose(() {
      _timer?.cancel();
      _timer = null;
    });
    return const CalmTimerState();
  }

  /// Starts a timer session with the given [duration].
  ///
  /// [chimeEnabled] controls whether a chime plays on completion.
  /// [closingText] is shown when the timer completes.
  void start(Duration duration, {bool chimeEnabled = true, String closingText = ''}) {
    _timer?.cancel();

    state = CalmTimerState(
      isActive: true,
      remainingTime: duration,
      totalDuration: duration,
      chimeEnabled: chimeEnabled,
      closingText: closingText,
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

  /// Ends the current timer session immediately.
  ///
  /// Keeps [state.isActive] as `true` so the UI can display a completion
  /// state (with [CalmTimerState.closingText]) rather than resetting.
  void end() {
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(remainingTime: Duration.zero);
  }

  /// Fully resets the timer to its inactive default state.
  ///
  /// Call this when the user dismisses the completion screen.
  void reset() {
    _timer?.cancel();
    _timer = null;
    state = const CalmTimerState();
  }
}

/// Provider for the [CalmTimerNotifier].
///
/// Exposes the [CalmTimerState] rebuilding on every tick. Widgets should watch
/// this provider to react to timer changes.
final calmTimerProvider =
    NotifierProvider<CalmTimerNotifier, CalmTimerState>(
  CalmTimerNotifier.new,
);
