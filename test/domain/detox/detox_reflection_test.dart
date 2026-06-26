import 'package:flutter_test/flutter_test.dart';
import 'package:with_jesus/domain/detox/detox_reflection.dart';

void main() {
  test('copies with overrides, equals by value', () {
    final now = DateTime(2026, 6, 26);
    final r = DetoxReflection(
      id: 1,
      promptKey: 'detox.prompt.whyNow',
      answer: 'feeling anxious',
      createdAt: now,
    );
    final updated = r.copyWith(answer: 'calmer now');
    expect(updated.answer, 'calmer now');
    expect(updated.id, 1);
    expect(updated.promptKey, 'detox.prompt.whyNow');
  });

  test('skipped reflection has null answer', () {
    final r = DetoxReflection(
      promptKey: 'detox.prompt.justBreathe',
      answer: null,
      createdAt: DateTime(2026, 6, 26),
    );
    expect(r.answer, isNull);
  });
}
