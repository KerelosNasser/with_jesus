/// A decrypted journal entry ready for presentation.
///
/// Unlike the database row ([JournalEntry] from `app_database.g.dart`), this
/// model holds plaintext `title` and `body` fields. It is the type that
/// crosses the data→domain boundary.
class JournalEntry {
  /// Creates a journal entry with the given properties.
  const JournalEntry({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Unique identifier (matches the database row id).
  final int id;

  /// Category label (e.g. "reflection", "prayer", "gratitude").
  final String category;

  /// Decrypted entry title.
  final String title;

  /// Decrypted entry body.
  final String body;

  /// When the entry was first created.
  final DateTime createdAt;

  /// When the entry was last modified.
  final DateTime updatedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntry &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          category == other.category &&
          title == other.title &&
          body == other.body &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(id, category, title, body, createdAt, updatedAt);

  @override
  String toString() =>
      'JournalEntry(id: $id, category: $category, title: $title)';
}
