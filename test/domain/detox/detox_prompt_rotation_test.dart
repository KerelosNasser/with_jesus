import 'package:flutter_test/flutter_test.dart';
import 'package:with_jesus/domain/detox/detox_prompt.dart';
import 'package:with_jesus/domain/detox/detox_prompt_rotation.dart';

void main() {
  group('DetoxPromptRotation', () {
    test('returns the same prompt for the same date', () {
      final day1 = DateTime(2026, 6, 26);
      final later = DateTime(2026, 6, 26, 23, 59);
      expect(
        DetoxPromptRotation.promptFor(day1).key,
        DetoxPromptRotation.promptFor(later).key,
      );
    });

    test('cycles through all prompts deterministically', () {
      final keys = <String>{};
      for (var i = 0; i < DetoxPromptRotation.all.length * 2; i++) {
        final day = DateTime(2026, 1, 1).add(Duration(days: i));
        keys.add(DetoxPromptRotation.promptFor(day).key);
      }
      expect(keys, DetoxPromptRotation.all.map((p) => p.key).toSet());
    });

    test('prompt key list matches the spec', () {
      expect(
        DetoxPromptRotation.all.map((p) => p.key),
        [
          'detox.prompt.whyNow',
          'detox.prompt.whatInstead',
          'detox.prompt.oneThingForGod',
          'detox.prompt.justBreathe',
        ],
      );
    });
  });
}
