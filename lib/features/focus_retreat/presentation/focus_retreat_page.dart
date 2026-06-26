import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import 'providers/focus_retreat_provider.dart';
import 'widgets/slow_gesture_detector.dart';

/// The focus retreat page — a minimalist, distraction-free shell.
///
/// When no retreat is active the user picks a duration (15/30/60 min) and
/// starts. During the retreat only a countdown, two calm action cards
/// (Hymns / Journal), and a subtle "End Retreat" button are visible.
class FocusRetreatPage extends ConsumerWidget {
  /// Creates a [FocusRetreatPage].
  const FocusRetreatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(focusRetreatProvider);
    final colors = Theme.of(context).colorScheme;

    if (!state.isActive) {
      return _SetupView(colors: colors);
    }

    return _ActiveRetreatView(
      state: state,
      colors: colors,
    );
  }
}

// ─── Setup view ──────────────────────────────────────────────────────────────

/// The pre-retreat setup screen where the user chooses a duration and starts.
class _SetupView extends ConsumerStatefulWidget {
  const _SetupView({required this.colors});

  final ColorScheme colors;

  @override
  ConsumerState<_SetupView> createState() => _SetupViewState();
}

class _SetupViewState extends ConsumerState<_SetupView> {
  int? _selectedMinutes;

  static const _durations = [15, 30, 60];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: widget.colors.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.containerPadding,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Title ──
                Text(
                  'فترة تأمل',
                  style: textTheme.headlineSmall?.copyWith(
                    color: widget.colors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'اختر مدة التأمل',
                  style: textTheme.bodyLarge?.copyWith(
                    color: widget.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // ── Duration options ──
                ..._durations.map((minutes) {
                  final selected = _selectedMinutes == minutes;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: selected
                              ? widget.colors.primaryContainer
                              : widget.colors.surfaceContainerLow,
                          foregroundColor: selected
                              ? widget.colors.onPrimaryContainer
                              : widget.colors.onSurface,
                          side: BorderSide(
                            color: selected
                                ? widget.colors.primary
                                : widget.colors.surfaceContainerHighest,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.lg,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusXl,
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() => _selectedMinutes = minutes);
                        },
                        child: Text(
                          '$minutes دقيقة',
                          style: textTheme.titleMedium,
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: AppSpacing.xl),

                // ── Start button ──
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _selectedMinutes != null
                        ? () {
                            ref
                                .read(focusRetreatProvider.notifier)
                                .startRetreat(
                                  Duration(minutes: _selectedMinutes!),
                                );
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.lg,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusXl,
                        ),
                      ),
                    ),
                    child: Text(
                      'ابدأ التأمل',
                      style: textTheme.titleMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Active retreat view ─────────────────────────────────────────────────────

/// The minimal shell shown during an active retreat.
///
/// Displays the countdown, two slow-tap action cards (Hymns / Journal), and
/// a subtle "End Retreat" button at the bottom.
class _ActiveRetreatView extends ConsumerWidget {
  const _ActiveRetreatView({
    required this.state,
    required this.colors,
  });

  final FocusRetreatState state;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.containerPadding,
          ),
          child: Column(
            children: [
              const Spacer(),

              // ── Countdown timer ──
              Text(
                _formatDuration(state.remainingTime),
                style: textTheme.displayLarge?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w200,
                ),
              ),
              const Spacer(flex: 2),

              // ── Action cards ──
              _ActionCard(
                label: 'الألحان',
                subtitle: 'ترانيم وتسابيح',
                icon: Icons.music_note_outlined,
                onSlowTap: () => context.push('/hymns'),
              ),
              const SizedBox(height: AppSpacing.md),
              _ActionCard(
                label: 'المذكرات',
                subtitle: 'اكتب تأملك',
                icon: Icons.edit_note_outlined,
                onSlowTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('المذكرات قريباً'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: colors.surfaceContainerHigh,
                    ),
                  );
                },
              ),

              const Spacer(),

              // ── End Retreat (subtle, 5s hold) ──
              SlowGestureDetector(
                duration: const Duration(seconds: 5),
                onSlowTap: () {
                  ref.read(focusRetreatProvider.notifier).endRetreat();
                },
                child: Text(
                  'إنهاء',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  /// Formats a [Duration] to `MM:SS` (or `H:MM:SS` when ≥60 min remaining).
  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');

    if (hours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}

/// A large card action that requires a slow tap (2.5 s hold).
class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onSlowTap,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onSlowTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SlowGestureDetector(
      onSlowTap: onSlowTap,
      child: Card(
        color: colors.surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          side: BorderSide(color: colors.surfaceContainerHighest),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xxl,
            horizontal: AppSpacing.lg,
          ),
          child: Row(
            children: [
              Icon(icon, color: colors.primary, size: 28),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: textTheme.titleLarge?.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_left, color: colors.outline),
            ],
          ),
        ),
      ),
    );
  }
}
