import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/stress_relief/breathing_pattern.dart';
import '../../../shared/widgets/breathing_orb.dart';
import 'providers/breathing_pattern_provider.dart';

/// A guided breathing exercise page with pattern selection and the extended
/// [BreathingOrb].
///
/// Shows a pattern picker when idle and a start/stop toggle to control the
/// exercise session.
class BreathingExercisePage extends ConsumerWidget {
  /// Creates a [BreathingExercisePage].
  const BreathingExercisePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final selectedPattern = ref.watch(breathingPatternProvider);
    final isRunning = ref.watch(_breathingRunningProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.calmBreathe)),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pattern picker
            if (!isRunning) ...[
              Text(
                l.calmSelectPattern,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              _PatternChips(selectedPattern: selectedPattern),
              const SizedBox(height: AppSpacing.xl),
            ],

            // Breathing orb
            Expanded(
              child: Center(
                child: BreathingOrb(
                  pattern: selectedPattern,
                  size: 240,
                  onCycleComplete: isRunning ? () {} : null,
                ),
              ),
            ),

            // Start/Stop button
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: FilledButton(
                onPressed: () =>
                    ref.read(_breathingRunningProvider.notifier).state =
                        !isRunning,
                child: Text(isRunning ? 'Stop' : l.calmBreathe),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple state provider to track if breathing exercise is active.
final _breathingRunningProvider = StateProvider<bool>((ref) => false);

/// Horizontal row of [FilterChip]s for selecting a breathing pattern.
class _PatternChips extends ConsumerWidget {
  const _PatternChips({required this.selectedPattern});

  final BreathingPattern selectedPattern;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerPadding,
      ),
      child: Row(
        children: kBreathingPatterns.map((pattern) {
          final isSelected = pattern == selectedPattern;
          final label = _patternLabel(l, pattern.name);
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
            child: FilterChip(
              selected: isSelected,
              label: Text(label),
              onSelected: (_) {
                ref.read(breathingPatternProvider.notifier).state = pattern;
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Maps an ARB localization key to the localized display string.
  String _patternLabel(AppLocalizations l, String nameKey) {
    return switch (nameKey) {
      'calmBreathing478' => l.calmBreathing478,
      'calmBreathingBox' => l.calmBreathingBox,
      'calmBreathingCoherent' => l.calmBreathingCoherent,
      'calmBreathingDefault' => l.calmBreathingDefault,
      _ => nameKey,
    };
  }
}
