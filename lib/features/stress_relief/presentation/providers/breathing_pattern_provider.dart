import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:with_jesus/domain/stress_relief/breathing_pattern.dart';

/// Predefined breathing patterns available in the app.
const kBreathingPatterns = [
  BreathingPattern(
    name: 'calmBreathing478',
    inhaleSeconds: 4,
    holdSeconds: 7,
    exhaleSeconds: 8,
  ),
  BreathingPattern(
    name: 'calmBreathingBox',
    inhaleSeconds: 4,
    holdSeconds: 4,
    exhaleSeconds: 4,
    holdAfterExhaleSeconds: 4,
  ),
  BreathingPattern(
    name: 'calmBreathingCoherent',
    inhaleSeconds: 5,
    exhaleSeconds: 5,
  ),
  BreathingPattern(
    name: 'calmBreathingDefault',
    inhaleSeconds: 4,
    exhaleSeconds: 6,
  ),
];

/// Currently selected breathing pattern. Defaults to 4-7-8.
final breathingPatternProvider = StateProvider<BreathingPattern>(
  (ref) => kBreathingPatterns.first,
);
