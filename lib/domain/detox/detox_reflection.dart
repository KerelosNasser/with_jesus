/// A single detox reflection: the prompt shown and the user's optional answer.
///
/// Pure Dart — no Flutter/plugin imports. The answer is decrypted by the
/// repository before constructing this type, so [answer] is already plaintext.
class DetoxReflection {
  const DetoxReflection({
    this.id,
    required this.promptKey,
    this.answer,
    required this.createdAt,
  });

  /// DB row id; null for a not-yet-saved reflection.
  final int? id;

  /// ARB key of the prompt that was shown (e.g. `detox.prompt.whyNow`).
  final String promptKey;

  /// The user's free-text answer, or null when they chose "just breathe"
  /// (skipped). For skipped reflections only promptKey + createdAt persist.
  final String? answer;

  /// When the reflection was recorded.
  final DateTime createdAt;

  /// Returns a copy with the given fields replaced.
  DetoxReflection copyWith({
    int? id,
    String? promptKey,
    String? answer,
    DateTime? createdAt,
  }) {
    return DetoxReflection(
      id: id ?? this.id,
      promptKey: promptKey ?? this.promptKey,
      answer: answer ?? this.answer,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetoxReflection &&
          id == other.id &&
          promptKey == other.promptKey &&
          answer == other.answer &&
          createdAt == other.createdAt;

  @override
  int get hashCode => Object.hash(id, promptKey, answer, createdAt);

  @override
  String toString() =>
      'DetoxReflection(id: $id, promptKey: $promptKey, answer: ${answer == null ? 'null(skipped)' : '…'})';
}
