// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ReadingHistoryTable extends ReadingHistory
    with TableInfo<$ReadingHistoryTable, ReadingHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bookMeta = const VerificationMeta('book');
  @override
  late final GeneratedColumn<String> book = GeneratedColumn<String>(
    'book',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  @override
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<String> readAt = GeneratedColumn<String>(
    'read_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [book, chapter, category, readAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('book')) {
      context.handle(
        _bookMeta,
        book.isAcceptableOrUnknown(data['book']!, _bookMeta),
      );
    } else if (isInserting) {
      context.missing(_bookMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    } else if (isInserting) {
      context.missing(_readAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {book, chapter};
  @override
  ReadingHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingHistoryData(
      book: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}read_at'],
      )!,
    );
  }

  @override
  $ReadingHistoryTable createAlias(String alias) {
    return $ReadingHistoryTable(attachedDatabase, alias);
  }
}

class ReadingHistoryData extends DataClass
    implements Insertable<ReadingHistoryData> {
  final String book;
  final int chapter;
  final String category;
  final String readAt;
  const ReadingHistoryData({
    required this.book,
    required this.chapter,
    required this.category,
    required this.readAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['book'] = Variable<String>(book);
    map['chapter'] = Variable<int>(chapter);
    map['category'] = Variable<String>(category);
    map['read_at'] = Variable<String>(readAt);
    return map;
  }

  ReadingHistoryCompanion toCompanion(bool nullToAbsent) {
    return ReadingHistoryCompanion(
      book: Value(book),
      chapter: Value(chapter),
      category: Value(category),
      readAt: Value(readAt),
    );
  }

  factory ReadingHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingHistoryData(
      book: serializer.fromJson<String>(json['book']),
      chapter: serializer.fromJson<int>(json['chapter']),
      category: serializer.fromJson<String>(json['category']),
      readAt: serializer.fromJson<String>(json['readAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'book': serializer.toJson<String>(book),
      'chapter': serializer.toJson<int>(chapter),
      'category': serializer.toJson<String>(category),
      'readAt': serializer.toJson<String>(readAt),
    };
  }

  ReadingHistoryData copyWith({
    String? book,
    int? chapter,
    String? category,
    String? readAt,
  }) => ReadingHistoryData(
    book: book ?? this.book,
    chapter: chapter ?? this.chapter,
    category: category ?? this.category,
    readAt: readAt ?? this.readAt,
  );
  ReadingHistoryData copyWithCompanion(ReadingHistoryCompanion data) {
    return ReadingHistoryData(
      book: data.book.present ? data.book.value : this.book,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      category: data.category.present ? data.category.value : this.category,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingHistoryData(')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('category: $category, ')
          ..write('readAt: $readAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(book, chapter, category, readAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingHistoryData &&
          other.book == this.book &&
          other.chapter == this.chapter &&
          other.category == this.category &&
          other.readAt == this.readAt);
}

class ReadingHistoryCompanion extends UpdateCompanion<ReadingHistoryData> {
  final Value<String> book;
  final Value<int> chapter;
  final Value<String> category;
  final Value<String> readAt;
  final Value<int> rowid;
  const ReadingHistoryCompanion({
    this.book = const Value.absent(),
    this.chapter = const Value.absent(),
    this.category = const Value.absent(),
    this.readAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadingHistoryCompanion.insert({
    required String book,
    required int chapter,
    required String category,
    required String readAt,
    this.rowid = const Value.absent(),
  }) : book = Value(book),
       chapter = Value(chapter),
       category = Value(category),
       readAt = Value(readAt);
  static Insertable<ReadingHistoryData> custom({
    Expression<String>? book,
    Expression<int>? chapter,
    Expression<String>? category,
    Expression<String>? readAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (book != null) 'book': book,
      if (chapter != null) 'chapter': chapter,
      if (category != null) 'category': category,
      if (readAt != null) 'read_at': readAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingHistoryCompanion copyWith({
    Value<String>? book,
    Value<int>? chapter,
    Value<String>? category,
    Value<String>? readAt,
    Value<int>? rowid,
  }) {
    return ReadingHistoryCompanion(
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      category: category ?? this.category,
      readAt: readAt ?? this.readAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (book.present) {
      map['book'] = Variable<String>(book.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<String>(readAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingHistoryCompanion(')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('category: $category, ')
          ..write('readAt: $readAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContinueReadingTable extends ContinueReading
    with TableInfo<$ContinueReadingTable, ContinueReadingData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContinueReadingTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _bookMeta = const VerificationMeta('book');
  @override
  late final GeneratedColumn<String> book = GeneratedColumn<String>(
    'book',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  @override
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseMeta = const VerificationMeta('verse');
  @override
  late final GeneratedColumn<int> verse = GeneratedColumn<int>(
    'verse',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _appUsedMeta = const VerificationMeta(
    'appUsed',
  );
  @override
  late final GeneratedColumn<String> appUsed = GeneratedColumn<String>(
    'app_used',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    book,
    chapter,
    verse,
    appUsed,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'continue_reading';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContinueReadingData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book')) {
      context.handle(
        _bookMeta,
        book.isAcceptableOrUnknown(data['book']!, _bookMeta),
      );
    } else if (isInserting) {
      context.missing(_bookMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('verse')) {
      context.handle(
        _verseMeta,
        verse.isAcceptableOrUnknown(data['verse']!, _verseMeta),
      );
    }
    if (data.containsKey('app_used')) {
      context.handle(
        _appUsedMeta,
        appUsed.isAcceptableOrUnknown(data['app_used']!, _appUsedMeta),
      );
    } else if (isInserting) {
      context.missing(_appUsedMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContinueReadingData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContinueReadingData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      book: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter'],
      )!,
      verse: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse'],
      ),
      appUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_used'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ContinueReadingTable createAlias(String alias) {
    return $ContinueReadingTable(attachedDatabase, alias);
  }
}

class ContinueReadingData extends DataClass
    implements Insertable<ContinueReadingData> {
  final int id;
  final String book;
  final int chapter;
  final int? verse;
  final String appUsed;
  final String updatedAt;
  const ContinueReadingData({
    required this.id,
    required this.book,
    required this.chapter,
    this.verse,
    required this.appUsed,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book'] = Variable<String>(book);
    map['chapter'] = Variable<int>(chapter);
    if (!nullToAbsent || verse != null) {
      map['verse'] = Variable<int>(verse);
    }
    map['app_used'] = Variable<String>(appUsed);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  ContinueReadingCompanion toCompanion(bool nullToAbsent) {
    return ContinueReadingCompanion(
      id: Value(id),
      book: Value(book),
      chapter: Value(chapter),
      verse: verse == null && nullToAbsent
          ? const Value.absent()
          : Value(verse),
      appUsed: Value(appUsed),
      updatedAt: Value(updatedAt),
    );
  }

  factory ContinueReadingData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContinueReadingData(
      id: serializer.fromJson<int>(json['id']),
      book: serializer.fromJson<String>(json['book']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verse: serializer.fromJson<int?>(json['verse']),
      appUsed: serializer.fromJson<String>(json['appUsed']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'book': serializer.toJson<String>(book),
      'chapter': serializer.toJson<int>(chapter),
      'verse': serializer.toJson<int?>(verse),
      'appUsed': serializer.toJson<String>(appUsed),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  ContinueReadingData copyWith({
    int? id,
    String? book,
    int? chapter,
    Value<int?> verse = const Value.absent(),
    String? appUsed,
    String? updatedAt,
  }) => ContinueReadingData(
    id: id ?? this.id,
    book: book ?? this.book,
    chapter: chapter ?? this.chapter,
    verse: verse.present ? verse.value : this.verse,
    appUsed: appUsed ?? this.appUsed,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ContinueReadingData copyWithCompanion(ContinueReadingCompanion data) {
    return ContinueReadingData(
      id: data.id.present ? data.id.value : this.id,
      book: data.book.present ? data.book.value : this.book,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verse: data.verse.present ? data.verse.value : this.verse,
      appUsed: data.appUsed.present ? data.appUsed.value : this.appUsed,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContinueReadingData(')
          ..write('id: $id, ')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('appUsed: $appUsed, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, book, chapter, verse, appUsed, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContinueReadingData &&
          other.id == this.id &&
          other.book == this.book &&
          other.chapter == this.chapter &&
          other.verse == this.verse &&
          other.appUsed == this.appUsed &&
          other.updatedAt == this.updatedAt);
}

class ContinueReadingCompanion extends UpdateCompanion<ContinueReadingData> {
  final Value<int> id;
  final Value<String> book;
  final Value<int> chapter;
  final Value<int?> verse;
  final Value<String> appUsed;
  final Value<String> updatedAt;
  const ContinueReadingCompanion({
    this.id = const Value.absent(),
    this.book = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verse = const Value.absent(),
    this.appUsed = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ContinueReadingCompanion.insert({
    this.id = const Value.absent(),
    required String book,
    required int chapter,
    this.verse = const Value.absent(),
    required String appUsed,
    required String updatedAt,
  }) : book = Value(book),
       chapter = Value(chapter),
       appUsed = Value(appUsed),
       updatedAt = Value(updatedAt);
  static Insertable<ContinueReadingData> custom({
    Expression<int>? id,
    Expression<String>? book,
    Expression<int>? chapter,
    Expression<int>? verse,
    Expression<String>? appUsed,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (book != null) 'book': book,
      if (chapter != null) 'chapter': chapter,
      if (verse != null) 'verse': verse,
      if (appUsed != null) 'app_used': appUsed,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ContinueReadingCompanion copyWith({
    Value<int>? id,
    Value<String>? book,
    Value<int>? chapter,
    Value<int?>? verse,
    Value<String>? appUsed,
    Value<String>? updatedAt,
  }) {
    return ContinueReadingCompanion(
      id: id ?? this.id,
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      appUsed: appUsed ?? this.appUsed,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (book.present) {
      map['book'] = Variable<String>(book.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verse.present) {
      map['verse'] = Variable<int>(verse.value);
    }
    if (appUsed.present) {
      map['app_used'] = Variable<String>(appUsed.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContinueReadingCompanion(')
          ..write('id: $id, ')
          ..write('book: $book, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('appUsed: $appUsed, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesTable extends JournalEntries
    with TableInfo<$JournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleNonceMeta = const VerificationMeta(
    'titleNonce',
  );
  @override
  late final GeneratedColumn<Uint8List> titleNonce = GeneratedColumn<Uint8List>(
    'title_nonce',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleCiphertextMeta = const VerificationMeta(
    'titleCiphertext',
  );
  @override
  late final GeneratedColumn<Uint8List> titleCiphertext =
      GeneratedColumn<Uint8List>(
        'title_ciphertext',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _titleMacMeta = const VerificationMeta(
    'titleMac',
  );
  @override
  late final GeneratedColumn<Uint8List> titleMac = GeneratedColumn<Uint8List>(
    'title_mac',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyNonceMeta = const VerificationMeta(
    'bodyNonce',
  );
  @override
  late final GeneratedColumn<Uint8List> bodyNonce = GeneratedColumn<Uint8List>(
    'body_nonce',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyCiphertextMeta = const VerificationMeta(
    'bodyCiphertext',
  );
  @override
  late final GeneratedColumn<Uint8List> bodyCiphertext =
      GeneratedColumn<Uint8List>(
        'body_ciphertext',
        aliasedName,
        false,
        type: DriftSqlType.blob,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _bodyMacMeta = const VerificationMeta(
    'bodyMac',
  );
  @override
  late final GeneratedColumn<Uint8List> bodyMac = GeneratedColumn<Uint8List>(
    'body_mac',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    titleNonce,
    titleCiphertext,
    titleMac,
    bodyNonce,
    bodyCiphertext,
    bodyMac,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('title_nonce')) {
      context.handle(
        _titleNonceMeta,
        titleNonce.isAcceptableOrUnknown(data['title_nonce']!, _titleNonceMeta),
      );
    } else if (isInserting) {
      context.missing(_titleNonceMeta);
    }
    if (data.containsKey('title_ciphertext')) {
      context.handle(
        _titleCiphertextMeta,
        titleCiphertext.isAcceptableOrUnknown(
          data['title_ciphertext']!,
          _titleCiphertextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_titleCiphertextMeta);
    }
    if (data.containsKey('title_mac')) {
      context.handle(
        _titleMacMeta,
        titleMac.isAcceptableOrUnknown(data['title_mac']!, _titleMacMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMacMeta);
    }
    if (data.containsKey('body_nonce')) {
      context.handle(
        _bodyNonceMeta,
        bodyNonce.isAcceptableOrUnknown(data['body_nonce']!, _bodyNonceMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyNonceMeta);
    }
    if (data.containsKey('body_ciphertext')) {
      context.handle(
        _bodyCiphertextMeta,
        bodyCiphertext.isAcceptableOrUnknown(
          data['body_ciphertext']!,
          _bodyCiphertextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bodyCiphertextMeta);
    }
    if (data.containsKey('body_mac')) {
      context.handle(
        _bodyMacMeta,
        bodyMac.isAcceptableOrUnknown(data['body_mac']!, _bodyMacMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMacMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      titleNonce: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}title_nonce'],
      )!,
      titleCiphertext: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}title_ciphertext'],
      )!,
      titleMac: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}title_mac'],
      )!,
      bodyNonce: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}body_nonce'],
      )!,
      bodyCiphertext: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}body_ciphertext'],
      )!,
      bodyMac: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}body_mac'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $JournalEntriesTable createAlias(String alias) {
    return $JournalEntriesTable(attachedDatabase, alias);
  }
}

class JournalEntry extends DataClass implements Insertable<JournalEntry> {
  final int id;
  final String category;
  final Uint8List titleNonce;
  final Uint8List titleCiphertext;
  final Uint8List titleMac;
  final Uint8List bodyNonce;
  final Uint8List bodyCiphertext;
  final Uint8List bodyMac;
  final DateTime createdAt;
  final DateTime updatedAt;
  const JournalEntry({
    required this.id,
    required this.category,
    required this.titleNonce,
    required this.titleCiphertext,
    required this.titleMac,
    required this.bodyNonce,
    required this.bodyCiphertext,
    required this.bodyMac,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<String>(category);
    map['title_nonce'] = Variable<Uint8List>(titleNonce);
    map['title_ciphertext'] = Variable<Uint8List>(titleCiphertext);
    map['title_mac'] = Variable<Uint8List>(titleMac);
    map['body_nonce'] = Variable<Uint8List>(bodyNonce);
    map['body_ciphertext'] = Variable<Uint8List>(bodyCiphertext);
    map['body_mac'] = Variable<Uint8List>(bodyMac);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      category: Value(category),
      titleNonce: Value(titleNonce),
      titleCiphertext: Value(titleCiphertext),
      titleMac: Value(titleMac),
      bodyNonce: Value(bodyNonce),
      bodyCiphertext: Value(bodyCiphertext),
      bodyMac: Value(bodyMac),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory JournalEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntry(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      titleNonce: serializer.fromJson<Uint8List>(json['titleNonce']),
      titleCiphertext: serializer.fromJson<Uint8List>(json['titleCiphertext']),
      titleMac: serializer.fromJson<Uint8List>(json['titleMac']),
      bodyNonce: serializer.fromJson<Uint8List>(json['bodyNonce']),
      bodyCiphertext: serializer.fromJson<Uint8List>(json['bodyCiphertext']),
      bodyMac: serializer.fromJson<Uint8List>(json['bodyMac']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(category),
      'titleNonce': serializer.toJson<Uint8List>(titleNonce),
      'titleCiphertext': serializer.toJson<Uint8List>(titleCiphertext),
      'titleMac': serializer.toJson<Uint8List>(titleMac),
      'bodyNonce': serializer.toJson<Uint8List>(bodyNonce),
      'bodyCiphertext': serializer.toJson<Uint8List>(bodyCiphertext),
      'bodyMac': serializer.toJson<Uint8List>(bodyMac),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  JournalEntry copyWith({
    int? id,
    String? category,
    Uint8List? titleNonce,
    Uint8List? titleCiphertext,
    Uint8List? titleMac,
    Uint8List? bodyNonce,
    Uint8List? bodyCiphertext,
    Uint8List? bodyMac,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => JournalEntry(
    id: id ?? this.id,
    category: category ?? this.category,
    titleNonce: titleNonce ?? this.titleNonce,
    titleCiphertext: titleCiphertext ?? this.titleCiphertext,
    titleMac: titleMac ?? this.titleMac,
    bodyNonce: bodyNonce ?? this.bodyNonce,
    bodyCiphertext: bodyCiphertext ?? this.bodyCiphertext,
    bodyMac: bodyMac ?? this.bodyMac,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  JournalEntry copyWithCompanion(JournalEntriesCompanion data) {
    return JournalEntry(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      titleNonce: data.titleNonce.present
          ? data.titleNonce.value
          : this.titleNonce,
      titleCiphertext: data.titleCiphertext.present
          ? data.titleCiphertext.value
          : this.titleCiphertext,
      titleMac: data.titleMac.present ? data.titleMac.value : this.titleMac,
      bodyNonce: data.bodyNonce.present ? data.bodyNonce.value : this.bodyNonce,
      bodyCiphertext: data.bodyCiphertext.present
          ? data.bodyCiphertext.value
          : this.bodyCiphertext,
      bodyMac: data.bodyMac.present ? data.bodyMac.value : this.bodyMac,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntry(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('titleNonce: $titleNonce, ')
          ..write('titleCiphertext: $titleCiphertext, ')
          ..write('titleMac: $titleMac, ')
          ..write('bodyNonce: $bodyNonce, ')
          ..write('bodyCiphertext: $bodyCiphertext, ')
          ..write('bodyMac: $bodyMac, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    category,
    $driftBlobEquality.hash(titleNonce),
    $driftBlobEquality.hash(titleCiphertext),
    $driftBlobEquality.hash(titleMac),
    $driftBlobEquality.hash(bodyNonce),
    $driftBlobEquality.hash(bodyCiphertext),
    $driftBlobEquality.hash(bodyMac),
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntry &&
          other.id == this.id &&
          other.category == this.category &&
          $driftBlobEquality.equals(other.titleNonce, this.titleNonce) &&
          $driftBlobEquality.equals(
            other.titleCiphertext,
            this.titleCiphertext,
          ) &&
          $driftBlobEquality.equals(other.titleMac, this.titleMac) &&
          $driftBlobEquality.equals(other.bodyNonce, this.bodyNonce) &&
          $driftBlobEquality.equals(
            other.bodyCiphertext,
            this.bodyCiphertext,
          ) &&
          $driftBlobEquality.equals(other.bodyMac, this.bodyMac) &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<int> id;
  final Value<String> category;
  final Value<Uint8List> titleNonce;
  final Value<Uint8List> titleCiphertext;
  final Value<Uint8List> titleMac;
  final Value<Uint8List> bodyNonce;
  final Value<Uint8List> bodyCiphertext;
  final Value<Uint8List> bodyMac;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.titleNonce = const Value.absent(),
    this.titleCiphertext = const Value.absent(),
    this.titleMac = const Value.absent(),
    this.bodyNonce = const Value.absent(),
    this.bodyCiphertext = const Value.absent(),
    this.bodyMac = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String category,
    required Uint8List titleNonce,
    required Uint8List titleCiphertext,
    required Uint8List titleMac,
    required Uint8List bodyNonce,
    required Uint8List bodyCiphertext,
    required Uint8List bodyMac,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : category = Value(category),
       titleNonce = Value(titleNonce),
       titleCiphertext = Value(titleCiphertext),
       titleMac = Value(titleMac),
       bodyNonce = Value(bodyNonce),
       bodyCiphertext = Value(bodyCiphertext),
       bodyMac = Value(bodyMac),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<JournalEntry> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<Uint8List>? titleNonce,
    Expression<Uint8List>? titleCiphertext,
    Expression<Uint8List>? titleMac,
    Expression<Uint8List>? bodyNonce,
    Expression<Uint8List>? bodyCiphertext,
    Expression<Uint8List>? bodyMac,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (titleNonce != null) 'title_nonce': titleNonce,
      if (titleCiphertext != null) 'title_ciphertext': titleCiphertext,
      if (titleMac != null) 'title_mac': titleMac,
      if (bodyNonce != null) 'body_nonce': bodyNonce,
      if (bodyCiphertext != null) 'body_ciphertext': bodyCiphertext,
      if (bodyMac != null) 'body_mac': bodyMac,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  JournalEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? category,
    Value<Uint8List>? titleNonce,
    Value<Uint8List>? titleCiphertext,
    Value<Uint8List>? titleMac,
    Value<Uint8List>? bodyNonce,
    Value<Uint8List>? bodyCiphertext,
    Value<Uint8List>? bodyMac,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      titleNonce: titleNonce ?? this.titleNonce,
      titleCiphertext: titleCiphertext ?? this.titleCiphertext,
      titleMac: titleMac ?? this.titleMac,
      bodyNonce: bodyNonce ?? this.bodyNonce,
      bodyCiphertext: bodyCiphertext ?? this.bodyCiphertext,
      bodyMac: bodyMac ?? this.bodyMac,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (titleNonce.present) {
      map['title_nonce'] = Variable<Uint8List>(titleNonce.value);
    }
    if (titleCiphertext.present) {
      map['title_ciphertext'] = Variable<Uint8List>(titleCiphertext.value);
    }
    if (titleMac.present) {
      map['title_mac'] = Variable<Uint8List>(titleMac.value);
    }
    if (bodyNonce.present) {
      map['body_nonce'] = Variable<Uint8List>(bodyNonce.value);
    }
    if (bodyCiphertext.present) {
      map['body_ciphertext'] = Variable<Uint8List>(bodyCiphertext.value);
    }
    if (bodyMac.present) {
      map['body_mac'] = Variable<Uint8List>(bodyMac.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('titleNonce: $titleNonce, ')
          ..write('titleCiphertext: $titleCiphertext, ')
          ..write('titleMac: $titleMac, ')
          ..write('bodyNonce: $bodyNonce, ')
          ..write('bodyCiphertext: $bodyCiphertext, ')
          ..write('bodyMac: $bodyMac, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ReadingHistoryTable readingHistory = $ReadingHistoryTable(this);
  late final $ContinueReadingTable continueReading = $ContinueReadingTable(
    this,
  );
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    readingHistory,
    continueReading,
    journalEntries,
  ];
}

typedef $$ReadingHistoryTableCreateCompanionBuilder =
    ReadingHistoryCompanion Function({
      required String book,
      required int chapter,
      required String category,
      required String readAt,
      Value<int> rowid,
    });
typedef $$ReadingHistoryTableUpdateCompanionBuilder =
    ReadingHistoryCompanion Function({
      Value<String> book,
      Value<int> chapter,
      Value<String> category,
      Value<String> readAt,
      Value<int> rowid,
    });

class $$ReadingHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingHistoryTable> {
  $$ReadingHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReadingHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingHistoryTable> {
  $$ReadingHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReadingHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingHistoryTable> {
  $$ReadingHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get book =>
      $composableBuilder(column: $table.book, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);
}

class $$ReadingHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingHistoryTable,
          ReadingHistoryData,
          $$ReadingHistoryTableFilterComposer,
          $$ReadingHistoryTableOrderingComposer,
          $$ReadingHistoryTableAnnotationComposer,
          $$ReadingHistoryTableCreateCompanionBuilder,
          $$ReadingHistoryTableUpdateCompanionBuilder,
          (
            ReadingHistoryData,
            BaseReferences<
              _$AppDatabase,
              $ReadingHistoryTable,
              ReadingHistoryData
            >,
          ),
          ReadingHistoryData,
          PrefetchHooks Function()
        > {
  $$ReadingHistoryTableTableManager(
    _$AppDatabase db,
    $ReadingHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> book = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> readAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingHistoryCompanion(
                book: book,
                chapter: chapter,
                category: category,
                readAt: readAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String book,
                required int chapter,
                required String category,
                required String readAt,
                Value<int> rowid = const Value.absent(),
              }) => ReadingHistoryCompanion.insert(
                book: book,
                chapter: chapter,
                category: category,
                readAt: readAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReadingHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingHistoryTable,
      ReadingHistoryData,
      $$ReadingHistoryTableFilterComposer,
      $$ReadingHistoryTableOrderingComposer,
      $$ReadingHistoryTableAnnotationComposer,
      $$ReadingHistoryTableCreateCompanionBuilder,
      $$ReadingHistoryTableUpdateCompanionBuilder,
      (
        ReadingHistoryData,
        BaseReferences<_$AppDatabase, $ReadingHistoryTable, ReadingHistoryData>,
      ),
      ReadingHistoryData,
      PrefetchHooks Function()
    >;
typedef $$ContinueReadingTableCreateCompanionBuilder =
    ContinueReadingCompanion Function({
      Value<int> id,
      required String book,
      required int chapter,
      Value<int?> verse,
      required String appUsed,
      required String updatedAt,
    });
typedef $$ContinueReadingTableUpdateCompanionBuilder =
    ContinueReadingCompanion Function({
      Value<int> id,
      Value<String> book,
      Value<int> chapter,
      Value<int?> verse,
      Value<String> appUsed,
      Value<String> updatedAt,
    });

class $$ContinueReadingTableFilterComposer
    extends Composer<_$AppDatabase, $ContinueReadingTable> {
  $$ContinueReadingTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verse => $composableBuilder(
    column: $table.verse,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appUsed => $composableBuilder(
    column: $table.appUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContinueReadingTableOrderingComposer
    extends Composer<_$AppDatabase, $ContinueReadingTable> {
  $$ContinueReadingTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get book => $composableBuilder(
    column: $table.book,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verse => $composableBuilder(
    column: $table.verse,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appUsed => $composableBuilder(
    column: $table.appUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContinueReadingTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContinueReadingTable> {
  $$ContinueReadingTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get book =>
      $composableBuilder(column: $table.book, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verse =>
      $composableBuilder(column: $table.verse, builder: (column) => column);

  GeneratedColumn<String> get appUsed =>
      $composableBuilder(column: $table.appUsed, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ContinueReadingTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContinueReadingTable,
          ContinueReadingData,
          $$ContinueReadingTableFilterComposer,
          $$ContinueReadingTableOrderingComposer,
          $$ContinueReadingTableAnnotationComposer,
          $$ContinueReadingTableCreateCompanionBuilder,
          $$ContinueReadingTableUpdateCompanionBuilder,
          (
            ContinueReadingData,
            BaseReferences<
              _$AppDatabase,
              $ContinueReadingTable,
              ContinueReadingData
            >,
          ),
          ContinueReadingData,
          PrefetchHooks Function()
        > {
  $$ContinueReadingTableTableManager(
    _$AppDatabase db,
    $ContinueReadingTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContinueReadingTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContinueReadingTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContinueReadingTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> book = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<int?> verse = const Value.absent(),
                Value<String> appUsed = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
              }) => ContinueReadingCompanion(
                id: id,
                book: book,
                chapter: chapter,
                verse: verse,
                appUsed: appUsed,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String book,
                required int chapter,
                Value<int?> verse = const Value.absent(),
                required String appUsed,
                required String updatedAt,
              }) => ContinueReadingCompanion.insert(
                id: id,
                book: book,
                chapter: chapter,
                verse: verse,
                appUsed: appUsed,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContinueReadingTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContinueReadingTable,
      ContinueReadingData,
      $$ContinueReadingTableFilterComposer,
      $$ContinueReadingTableOrderingComposer,
      $$ContinueReadingTableAnnotationComposer,
      $$ContinueReadingTableCreateCompanionBuilder,
      $$ContinueReadingTableUpdateCompanionBuilder,
      (
        ContinueReadingData,
        BaseReferences<
          _$AppDatabase,
          $ContinueReadingTable,
          ContinueReadingData
        >,
      ),
      ContinueReadingData,
      PrefetchHooks Function()
    >;
typedef $$JournalEntriesTableCreateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<int> id,
      required String category,
      required Uint8List titleNonce,
      required Uint8List titleCiphertext,
      required Uint8List titleMac,
      required Uint8List bodyNonce,
      required Uint8List bodyCiphertext,
      required Uint8List bodyMac,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$JournalEntriesTableUpdateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<int> id,
      Value<String> category,
      Value<Uint8List> titleNonce,
      Value<Uint8List> titleCiphertext,
      Value<Uint8List> titleMac,
      Value<Uint8List> bodyNonce,
      Value<Uint8List> bodyCiphertext,
      Value<Uint8List> bodyMac,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$JournalEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get titleNonce => $composableBuilder(
    column: $table.titleNonce,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get titleCiphertext => $composableBuilder(
    column: $table.titleCiphertext,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get titleMac => $composableBuilder(
    column: $table.titleMac,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get bodyNonce => $composableBuilder(
    column: $table.bodyNonce,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get bodyCiphertext => $composableBuilder(
    column: $table.bodyCiphertext,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get bodyMac => $composableBuilder(
    column: $table.bodyMac,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JournalEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get titleNonce => $composableBuilder(
    column: $table.titleNonce,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get titleCiphertext => $composableBuilder(
    column: $table.titleCiphertext,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get titleMac => $composableBuilder(
    column: $table.titleMac,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get bodyNonce => $composableBuilder(
    column: $table.bodyNonce,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get bodyCiphertext => $composableBuilder(
    column: $table.bodyCiphertext,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get bodyMac => $composableBuilder(
    column: $table.bodyMac,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JournalEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<Uint8List> get titleNonce => $composableBuilder(
    column: $table.titleNonce,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get titleCiphertext => $composableBuilder(
    column: $table.titleCiphertext,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get titleMac =>
      $composableBuilder(column: $table.titleMac, builder: (column) => column);

  GeneratedColumn<Uint8List> get bodyNonce =>
      $composableBuilder(column: $table.bodyNonce, builder: (column) => column);

  GeneratedColumn<Uint8List> get bodyCiphertext => $composableBuilder(
    column: $table.bodyCiphertext,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get bodyMac =>
      $composableBuilder(column: $table.bodyMac, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$JournalEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JournalEntriesTable,
          JournalEntry,
          $$JournalEntriesTableFilterComposer,
          $$JournalEntriesTableOrderingComposer,
          $$JournalEntriesTableAnnotationComposer,
          $$JournalEntriesTableCreateCompanionBuilder,
          $$JournalEntriesTableUpdateCompanionBuilder,
          (
            JournalEntry,
            BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry>,
          ),
          JournalEntry,
          PrefetchHooks Function()
        > {
  $$JournalEntriesTableTableManager(
    _$AppDatabase db,
    $JournalEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<Uint8List> titleNonce = const Value.absent(),
                Value<Uint8List> titleCiphertext = const Value.absent(),
                Value<Uint8List> titleMac = const Value.absent(),
                Value<Uint8List> bodyNonce = const Value.absent(),
                Value<Uint8List> bodyCiphertext = const Value.absent(),
                Value<Uint8List> bodyMac = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => JournalEntriesCompanion(
                id: id,
                category: category,
                titleNonce: titleNonce,
                titleCiphertext: titleCiphertext,
                titleMac: titleMac,
                bodyNonce: bodyNonce,
                bodyCiphertext: bodyCiphertext,
                bodyMac: bodyMac,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String category,
                required Uint8List titleNonce,
                required Uint8List titleCiphertext,
                required Uint8List titleMac,
                required Uint8List bodyNonce,
                required Uint8List bodyCiphertext,
                required Uint8List bodyMac,
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => JournalEntriesCompanion.insert(
                id: id,
                category: category,
                titleNonce: titleNonce,
                titleCiphertext: titleCiphertext,
                titleMac: titleMac,
                bodyNonce: bodyNonce,
                bodyCiphertext: bodyCiphertext,
                bodyMac: bodyMac,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JournalEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JournalEntriesTable,
      JournalEntry,
      $$JournalEntriesTableFilterComposer,
      $$JournalEntriesTableOrderingComposer,
      $$JournalEntriesTableAnnotationComposer,
      $$JournalEntriesTableCreateCompanionBuilder,
      $$JournalEntriesTableUpdateCompanionBuilder,
      (
        JournalEntry,
        BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry>,
      ),
      JournalEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ReadingHistoryTableTableManager get readingHistory =>
      $$ReadingHistoryTableTableManager(_db, _db.readingHistory);
  $$ContinueReadingTableTableManager get continueReading =>
      $$ContinueReadingTableTableManager(_db, _db.continueReading);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(_db, _db.journalEntries);
}
