import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/app_text_field.dart';
import 'providers/calm_timer_provider.dart';

/// A prayer timer page with duration selection, chime option, optional closing
/// text, and a countdown display.
///
/// Three states:
/// - **Setup**: user configures duration, chime, and closing text.
/// - **Active**: countdown with progress and an end button.
/// - **Completed**: closing text and "Amen" with a dismiss button.
class PrayerTimerPage extends ConsumerStatefulWidget {
  /// Creates a [PrayerTimerPage].
  const PrayerTimerPage({super.key});

  @override
  ConsumerState<PrayerTimerPage> createState() => _PrayerTimerPageState();
}

class _PrayerTimerPageState extends ConsumerState<PrayerTimerPage> {
  Duration _selectedDuration = const Duration(minutes: 5);
  bool _chimeEnabled = true;
  final _closingTextController = TextEditingController();

  static const _durations = [
    Duration(minutes: 5),
    Duration(minutes: 10),
    Duration(minutes: 15),
  ];

  @override
  void dispose() {
    _closingTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(calmTimerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.calmPrayerTimer)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.containerPadding),
          child: _buildBody(l, state),
        ),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l, CalmTimerState state) {
    // Completed state
    if (state.isActive && state.remainingTime == Duration.zero) {
      return _CompletedView(
        state: state,
        onDismiss: () => ref.read(calmTimerProvider.notifier).reset(),
      );
    }

    // Active state
    if (state.isActive) {
      return _ActiveView(
        state: state,
        onEnd: () => ref.read(calmTimerProvider.notifier).end(),
      );
    }

    // Setup state
    return _SetupView(
      selectedDuration: _selectedDuration,
      onDurationChanged: (d) => setState(() => _selectedDuration = d),
      chimeEnabled: _chimeEnabled,
      onChimeChanged: (v) => setState(() => _chimeEnabled = v),
      closingTextController: _closingTextController,
      onStart: () {
        ref.read(calmTimerProvider.notifier).start(
          _selectedDuration,
          chimeEnabled: _chimeEnabled,
          closingText: _closingTextController.text.trim(),
        );
      },
    );
  }
}

/// Formats a [Duration] into `MM:SS` countdown format.
String _formatDuration(Duration d) {
  final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

/// Setup view: duration selector, chime toggle, closing text, start button.
class _SetupView extends StatelessWidget {
  const _SetupView({
    required this.selectedDuration,
    required this.onDurationChanged,
    required this.chimeEnabled,
    required this.onChimeChanged,
    required this.closingTextController,
    required this.onStart,
  });

  final Duration selectedDuration;
  final ValueChanged<Duration> onDurationChanged;
  final bool chimeEnabled;
  final ValueChanged<bool> onChimeChanged;
  final TextEditingController closingTextController;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return ListView(
      children: [
        // Section label
        Text(
          l.calmSelectDuration,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Duration chips
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _PrayerTimerPageState._durations.map((duration) {
            final isSelected = duration == selectedDuration;
            return FilterChip(
              selected: isSelected,
              label: Text(_durationLabel(l, duration)),
              onSelected: (_) => onDurationChanged(duration),
            );
          }).toList(),
        ),

        const SizedBox(height: AppSpacing.xl),

        // Chime toggle
        SwitchListTile(
          value: chimeEnabled,
          onChanged: onChimeChanged,
          title: Text(l.calmPrayerChime),
          contentPadding: EdgeInsets.zero,
        ),

        const SizedBox(height: AppSpacing.lg),

        // Closing text
        AppTextField(
          controller: closingTextController,
          labelText: l.calmPrayerClosingText,
          maxLines: 2,
        ),

        const SizedBox(height: AppSpacing.xxl),

        // Start button
        FilledButton(
          onPressed: onStart,
          child: Text(l.calmPrayerStart),
        ),
      ],
    );
  }

  String _durationLabel(AppLocalizations l, Duration duration) {
    final minutes = duration.inMinutes;
    return '$minutes ${l.calmSelectDuration}';
  }
}

/// Active view: countdown display, progress bar, end button.
class _ActiveView extends StatelessWidget {
  const _ActiveView({required this.state, required this.onEnd});

  final CalmTimerState state;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final progress = state.totalDuration.inSeconds > 0
        ? state.remainingTime.inSeconds / state.totalDuration.inSeconds
        : 0.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),

        // Countdown
        Text(
          _formatDuration(state.remainingTime),
          style: theme.textTheme.displayLarge?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        // Progress indicator
        LinearProgressIndicator(
          value: progress,
          minHeight: 6,
          borderRadius: const BorderRadius.all(Radius.circular(AppSpacing.radiusSm)),
        ),

        const Spacer(),

        // End button
        FilledButton.tonal(
          onPressed: onEnd,
          child: Text(l.calmPrayerEnd),
        ),

        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

/// Completed view: closing text, "Amen", dismiss button.
class _CompletedView extends StatelessWidget {
  const _CompletedView({required this.state, required this.onDismiss});

  final CalmTimerState state;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),

        // "Amen" / completion text
        Text(
          l.calmPrayerComplete,
          style: theme.textTheme.displayLarge?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),

        if (state.closingText.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.cardPadding),
              child: Text(
                state.closingText,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],

        const Spacer(),

        // Dismiss button
        FilledButton(
          onPressed: onDismiss,
          child: const Text('OK'),
        ),

        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
