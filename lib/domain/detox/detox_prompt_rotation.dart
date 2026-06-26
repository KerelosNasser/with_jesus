import 'detox_prompt.dart';

/// Deterministic-by-date selection of the daily detox reflection prompt.
///
/// Same calendar day → same prompt (matches the project's seeded-by-date
/// pattern used by the reading journey). Consecutive days cycle through the
/// full prompt set so the user sees variety without "random challenge" framing.
abstract final class DetoxPromptRotation {
  DetoxPromptRotation._();

  /// The full, ordered prompt set (spec §2).
  static const List<DetoxPrompt> all = [
    DetoxPrompt('detox.prompt.whyNow'),
    DetoxPrompt('detox.prompt.whatInstead'),
    DetoxPrompt('detox.prompt.oneThingForGod'),
    DetoxPrompt('detox.prompt.justBreathe'),
  ];

  /// Returns the prompt for [day], deterministically by day-since-epoch.
  static DetoxPrompt promptFor(DateTime day) {
    final dayNumber = DateTime(day.year, day.month, day.day)
        .difference(DateTime(1970, 1, 1))
        .inDays;
    final index = dayNumber % all.length;
    return all[index];
  }
}
