import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:with_jesus/core/l10n/app_localizations.dart';
import 'package:with_jesus/data/detox/detox_providers.dart';
import 'package:with_jesus/domain/detox/detox_prompt_rotation.dart';
import 'package:with_jesus/features/detox/presentation/providers/detox_session_provider.dart';
import 'package:with_jesus/shared/widgets/breathing_orb.dart';
import 'package:with_jesus/features/focus_retreat/presentation/widgets/slow_gesture_detector.dart';
import 'package:with_jesus/shared/widgets/app_text_field.dart';

/// The main detox session page with two phases:
///
/// 1. **Reflection gate** — shows today's prompt, optional answer field,
///    and skip/continue buttons.
/// 2. **Active session** — breathing orb, timer, and end-session button.
class DetoxSessionPage extends ConsumerStatefulWidget {
  /// Creates a [DetoxSessionPage].
  const DetoxSessionPage({super.key});

  @override
  ConsumerState<DetoxSessionPage> createState() => _DetoxSessionPageState();
}

class _DetoxSessionPageState extends ConsumerState<DetoxSessionPage> {
  final _answerController = TextEditingController();
  bool _showReflection = true;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(detoxSessionProvider);

    // Active session always takes precedence.
    if (session.isActive) {
      return _ActiveSession(
        state: session,
        onEnd: () => _endSession(),
      );
    }

    // Reflection gate (daily prompt + optional answer).
    if (_showReflection) {
      return _ReflectionGate(
        answerController: _answerController,
        onContinue: () => _startSession(),
        onSkip: () {
          setState(() => _showReflection = false);
          _startSession();
        },
      );
    }

    // Reflection skipped — show the minimal start screen.
    return _StartScreen(onStart: () => _startSession());
  }

  void _startSession() {
    final answer = _answerController.text.trim();
    final prompt = DetoxPromptRotation.promptFor(DateTime.now());

    if (answer.isNotEmpty) {
      ref.read(detoxReflectionRepositoryProvider).save(
            promptKey: prompt.key,
            answer: answer,
          );
    } else {
      ref.read(detoxReflectionRepositoryProvider).save(
            promptKey: prompt.key,
          );
    }

    ref.read(detoxSessionProvider.notifier).start(
          const Duration(minutes: 15),
        );
  }

  void _endSession() {
    ref.read(detoxSessionProvider.notifier).end();
    setState(() => _showReflection = true);
    _answerController.clear();
  }
}

/// Reflection gate shown before the detox session begins.
///
/// Displays today's deterministic prompt, an optional multi-line answer
/// field, and two actions: Continue (save answer + start) and Skip.
class _ReflectionGate extends StatelessWidget {
  const _ReflectionGate({
    required this.answerController,
    required this.onContinue,
    required this.onSkip,
  });

  final TextEditingController answerController;
  final VoidCallback onContinue;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final prompt = DetoxPromptRotation.promptFor(DateTime.now());
    final promptText = _lookupPromptText(l, prompt.key);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.detoxReflectionPrompt,
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            promptText,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          AppTextField(
            controller: answerController,
            labelText: l.detoxReflectionAnswer,
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: onContinue,
            child: Text(l.detoxReflectionContinue),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onSkip,
            child: Text(l.detoxReflectionSkip),
          ),
        ],
      ),
    );
  }

  /// Maps a [DetoxPrompt] logical key to its localized [AppLocalizations]
  /// getter.  Falls back to the raw [key] string when no match is found.
  String _lookupPromptText(AppLocalizations l, String key) {
    switch (key) {
      case 'detox.prompt.whyNow':
        return l.detoxPromptWhyNow;
      case 'detox.prompt.whatInstead':
        return l.detoxPromptWhatInstead;
      case 'detox.prompt.oneThingForGod':
        return l.detoxPromptOneThingForGod;
      case 'detox.prompt.justBreathe':
        return l.detoxPromptJustBreathe;
      default:
        return key;
    }
  }
}

/// Minimal start screen shown when the user has skipped the reflection gate.
///
/// Displays the breathing orb, title, subtitle, and a start button.
class _StartScreen extends StatelessWidget {
  const _StartScreen({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const BreathingOrb(size: 160),
          const SizedBox(height: 32),
          Text(l.detoxTitle, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(l.detoxSubtitle, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: onStart,
            child: Text(l.detoxStartSession),
          ),
        ],
      ),
    );
  }
}

/// Active detox session with breathing orb, countdown timer,
/// and slow-gesture end button.
class _ActiveSession extends StatelessWidget {
  const _ActiveSession({
    required this.state,
    required this.onEnd,
  });

  final DetoxSessionState state;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final minutes = state.remainingTime.inMinutes;
    final seconds = state.remainingTime.inSeconds % 60;
    final timeStr =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const BreathingOrb(size: 200),
          const SizedBox(height: 32),
          Text(l.detoxActiveSession, style: theme.textTheme.titleMedium),
          const SizedBox(height: 16),
          Text(
            timeStr,
            style: theme.textTheme.displayLarge?.copyWith(
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 8),
          Text(l.detoxTimeRemaining, style: theme.textTheme.bodySmall),
          const SizedBox(height: 48),
          SlowGestureDetector(
            onSlowTap: onEnd,
            child: FilledButton.tonal(
              onPressed: null, // Must use slow gesture to end
              child: Text(l.detoxEndSession),
            ),
          ),
        ],
      ),
    );
  }
}


