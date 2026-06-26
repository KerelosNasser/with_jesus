import 'package:flutter/material.dart';

/// A gesture detector that requires an intentional hold delay before
/// triggering [onSlowTap].
///
/// The user must press and hold for [duration] (default 2.5 s) before the
/// action fires. Releasing or cancelling the gesture before completion resets
/// the progress.
///
/// Visual feedback is shown via a [CircularProgressIndicator] overlay that
/// fills as the hold progresses, giving a calm indication of remaining time.
class SlowGestureDetector extends StatefulWidget {
  /// The child widget to wrap with the slow-tap gesture.
  final Widget child;

  /// Called when the user holds for the full [duration].
  final VoidCallback onSlowTap;

  /// How long the user must hold before [onSlowTap] fires.
  ///
  /// Defaults to 2.5 seconds.
  final Duration duration;

  /// Creates a [SlowGestureDetector].
  const SlowGestureDetector({
    super.key,
    required this.child,
    required this.onSlowTap,
    this.duration = const Duration(milliseconds: 2500),
  });

  @override
  State<SlowGestureDetector> createState() => _SlowGestureDetectorState();
}

class _SlowGestureDetectorState extends State<SlowGestureDetector>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.addListener(_onProgress);
  }

  @override
  void dispose() {
    _controller.removeListener(_onProgress);
    _controller.dispose();
    super.dispose();
  }

  void _onProgress() {
    if (_controller.isCompleted) {
      widget.onSlowTap();
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final progress = _controller.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              child!,
              if (progress > 0)
                CircularProgressIndicator(
                  value: progress,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          );
        },
        child: widget.child,
      ),
    );
  }
}
