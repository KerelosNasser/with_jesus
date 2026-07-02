import 'package:flutter/material.dart';
import 'package:with_jesus/core/l10n/app_localizations.dart';
import 'package:with_jesus/core/theme/app_spacing.dart';
import 'package:with_jesus/domain/stress_relief/breathing_pattern.dart';

/// A calm, pulsing orb that guides slow breathing during calm/stress-relief
/// and detox sessions.
///
/// When a [BreathingPattern] is provided, animates through
/// inhale / hold / exhale / hold-after-exhale phases and displays the current
/// phase label below the orb.
///
/// When [pattern] is `null`, uses a default 4 s inhale / 6 s exhale rhythm
/// without phase labels.
///
/// Honors [MediaQuery.disableAnimationsOf] — when disabled, draws a static
/// orb at scale 1.0 and shows "—" as the phase label.
class BreathingOrb extends StatefulWidget {
  /// Diameter of the orb in logical pixels.
  final double size;

  /// Fill color of the orb. Defaults to candlelight amber from the design
  /// tokens.
  final Color color;

  /// Optional breathing pattern. `null` uses the default 4 s‑in / 6 s‑out
  /// rhythm with no labels.
  final BreathingPattern? pattern;

  /// Called each time a full breathing cycle completes.
  ///
  /// Only meaningful when [pattern] is non‑null; when [pattern] is `null`
  /// cycles still complete but this callback is skipped.
  final VoidCallback? onCycleComplete;

  /// Creates a [BreathingOrb].
  const BreathingOrb({
    super.key,
    this.size = 200.0,
    this.color = const Color(0xFFFFD180),
    this.pattern,
    this.onCycleComplete,
  });

  @override
  State<BreathingOrb> createState() => _BreathingOrbState();
}

class _BreathingOrbState extends State<BreathingOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _lastTotalSeconds = 0;

  // ── Default fallback (no pattern) ───────────────────────────────────
  static const int _defaultInhale = 4;
  static const int _defaultExhale = 6;

  int get _inhaleSeconds =>
      widget.pattern?.inhaleSeconds ?? _defaultInhale;

  int get _holdSeconds => widget.pattern?.holdSeconds ?? 0;

  int get _exhaleSeconds =>
      widget.pattern?.exhaleSeconds ?? _defaultExhale;

  int get _holdAfterExhaleSeconds =>
      widget.pattern?.holdAfterExhaleSeconds ?? 0;

  int get _totalSeconds =>
      _inhaleSeconds +
      _holdSeconds +
      _exhaleSeconds +
      _holdAfterExhaleSeconds;

  // ── Lifecycle ───────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _lastTotalSeconds = _totalSeconds;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _totalSeconds),
    );
    _controller.addListener(_onTick);
    _controller.addStatusListener(_onStatusChange);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimationState();
  }

  @override
  void didUpdateWidget(BreathingOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newTotal = _totalSeconds;
    if (newTotal != _lastTotalSeconds) {
      _lastTotalSeconds = newTotal;
      _controller.duration = Duration(seconds: newTotal);
      _controller.reset();
      _syncAnimationState();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTick);
    _controller.removeStatusListener(_onStatusChange);
    _controller.dispose();
    super.dispose();
  }

  // ── Animation helpers ───────────────────────────────────────────────

  void _syncAnimationState() {
    final disable = MediaQuery.disableAnimationsOf(context);
    if (disable) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  void _onTick() {
    setState(() {});
  }

  void _onStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onCycleComplete?.call();
    }
  }

  /// Scale value at normalized animation progress [t] (0.0 – 1.0).
  double _scaleAt(double t) {
    final total = _totalSeconds;
    if (total <= 0) return 1.0;

    final inhaleEnd = _inhaleSeconds / total;
    final holdEnd = (_inhaleSeconds + _holdSeconds) / total;
    final exhaleEnd =
        (_inhaleSeconds + _holdSeconds + _exhaleSeconds) / total;

    if (t < inhaleEnd) {
      final localT =
          inhaleEnd > 0 ? Curves.easeInOut.transform(t / inhaleEnd) : 0.0;
      return 0.6 + 0.4 * localT;
    } else if (t < holdEnd) {
      return 1.0;
    } else if (t < exhaleEnd) {
      final segment = exhaleEnd - holdEnd;
      final localT =
          segment > 0
              ? Curves.easeInOut.transform((t - holdEnd) / segment)
              : 0.0;
      return 1.0 - 0.4 * localT;
    } else {
      return 0.6;
    }
  }

  /// Localized phase label for the current progress [t].
  String _phaseLabel(AppLocalizations l, double t) {
    // No labels when using the default (no pattern).
    if (widget.pattern == null) return '';

    final total = _totalSeconds;
    if (total <= 0) return '';

    final inhaleEnd = _inhaleSeconds / total;
    final holdEnd = (_inhaleSeconds + _holdSeconds) / total;
    final exhaleEnd =
        (_inhaleSeconds + _holdSeconds + _exhaleSeconds) / total;

    if (t < inhaleEnd) return l.calmPhaseInhale;
    if (t < holdEnd) return l.calmPhaseHold;
    if (t < exhaleEnd) return l.calmPhaseExhale;
    return l.calmPhaseHoldAfterExhale;
  }

  // ── Build ───────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final l = AppLocalizations.of(context)!;

    // Show phase label when a pattern is provided OR when animations are
    // disabled (shows "—" in the disabled case).
    final showLabel = widget.pattern != null || disableAnimations;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Breathing orb ─────────────────────────────────────────
          ListenableBuilder(
            listenable: _controller,
            builder: (context, child) {
              final scale =
                  disableAnimations ? 1.0 : _scaleAt(_controller.value);
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.4),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          ),

          // ── Phase label ───────────────────────────────────────────
          if (showLabel) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              disableAnimations
                  ? '\u2014' // em dash
                  : _phaseLabel(l, _controller.value),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: widget.color.withValues(alpha: 0.7),
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
