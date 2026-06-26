import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for the focus retreat timer.
class FocusRetreatState {
  /// Creates a [FocusRetreatState] with the given values.
  const FocusRetreatState({
    this.isActive = false,
    this.remainingTime = Duration.zero,
    this.totalDuration = Duration.zero,
  });

  /// Whether a retreat session is currently running.
  final bool isActive;

  /// Time remaining in the current retreat session.
  final Duration remainingTime;

  /// Total configured duration of the current retreat session.
  final Duration totalDuration;

  /// Returns a copy of this state with the given fields replaced by [isActive],
  /// [remainingTime], and/or [totalDuration].
  FocusRetreatState copyWith({
    bool? isActive,
    Duration? remainingTime,
    Duration? totalDuration,
  }) {
    return FocusRetreatState(
      isActive: isActive ?? this.isActive,
      remainingTime: remainingTime ?? this.remainingTime,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }
}

/// Notifier that manages the focus retreat timer lifecycle.
///
/// Call [startRetreat] to begin a session; the timer decrements
/// [FocusRetreatState.remainingTime] every second. Call [endRetreat] to
/// stop early. When the timer reaches zero the session ends automatically.
class FocusRetreatNotifier extends Notifier<FocusRetreatState> {
  Timer? _timer;

  @override
  FocusRetreatState build() {
    ref.onDispose(() {
      _timer?.cancel();
      _timer = null;
    });
    return const FocusRetreatState();
  }

  /// Starts a retreat session with the given [duration].
  ///
  /// Any previously running session is cancelled. The timer ticks every
  /// second until [remainingTime] reaches zero, at which point [endRetreat]
  /// is called automatically.
  void startRetreat(Duration duration) {
    _timer?.cancel();

    state = FocusRetreatState(
      isActive: true,
      remainingTime: duration,
      totalDuration: duration,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final newRemaining = state.remainingTime - const Duration(seconds: 1);

      if (newRemaining <= Duration.zero) {
        endRetreat();
        // TODO: trigger completion notification / vibration
        return;
      }

      state = state.copyWith(remainingTime: newRemaining);
    });
  }

  /// Ends the current retreat session immediately.
  ///
  /// Cancels the underlying [Timer] and resets [FocusRetreatState] to its
  /// default (inactive) values.
  void endRetreat() {
    _timer?.cancel();
    _timer = null;
    state = const FocusRetreatState();
  }
}

/// Provider for the [FocusRetreatNotifier].
///
/// Exposes the [FocusRetreatState] rebuild on every tick. Widgets should watch
/// this provider to react to timer changes.
final focusRetreatProvider =
    NotifierProvider<FocusRetreatNotifier, FocusRetreatState>(
  FocusRetreatNotifier.new,
);
