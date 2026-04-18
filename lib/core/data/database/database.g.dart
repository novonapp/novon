// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $NovelsTable extends Novels with TableInfo<$NovelsTable, Novel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NovelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverUrlMeta = const VerificationMeta(
    'coverUrl',
  );
  @override
  late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
    'cover_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genresMeta = const VerificationMeta('genres');
  @override
  late final GeneratedColumn<String> genres = GeneratedColumn<String>(
    'genres',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _inLibraryMeta = const VerificationMeta(
    'inLibrary',
  );
  @override
  late final GeneratedColumn<bool> inLibrary = GeneratedColumn<bool>(
    'in_library',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("in_library" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dateAddedMeta = const VerificationMeta(
    'dateAdded',
  );
  @override
  late final GeneratedColumn<DateTime> dateAdded = GeneratedColumn<DateTime>(
    'date_added',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastFetchedMeta = const VerificationMeta(
    'lastFetched',
  );
  @override
  late final GeneratedColumn<DateTime> lastFetched = GeneratedColumn<DateTime>(
    'last_fetched',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceId,
    url,
    title,
    author,
    description,
    coverUrl,
    status,
    genres,
    inLibrary,
    dateAdded,
    lastFetched,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'novels';
  @override
  VerificationContext validateIntegrity(
    Insertable<Novel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('cover_url')) {
      context.handle(
        _coverUrlMeta,
        coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('genres')) {
      context.handle(
        _genresMeta,
        genres.isAcceptableOrUnknown(data['genres']!, _genresMeta),
      );
    }
    if (data.containsKey('in_library')) {
      context.handle(
        _inLibraryMeta,
        inLibrary.isAcceptableOrUnknown(data['in_library']!, _inLibraryMeta),
      );
    }
    if (data.containsKey('date_added')) {
      context.handle(
        _dateAddedMeta,
        dateAdded.isAcceptableOrUnknown(data['date_added']!, _dateAddedMeta),
      );
    }
    if (data.containsKey('last_fetched')) {
      context.handle(
        _lastFetchedMeta,
        lastFetched.isAcceptableOrUnknown(
          data['last_fetched']!,
          _lastFetchedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Novel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Novel(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      coverUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_url'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
      genres: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genres'],
      ),
      inLibrary: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}in_library'],
      )!,
      dateAdded: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_added'],
      ),
      lastFetched: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_fetched'],
      ),
    );
  }

  @override
  $NovelsTable createAlias(String alias) {
    return $NovelsTable(attachedDatabase, alias);
  }
}

class Novel extends DataClass implements Insertable<Novel> {
  final String id;
  final String sourceId;
  final String url;
  final String title;
  final String? author;
  final String? description;
  final String? coverUrl;
  final String? status;
  final String? genres;
  final bool inLibrary;
  final DateTime? dateAdded;
  final DateTime? lastFetched;
  const Novel({
    required this.id,
    required this.sourceId,
    required this.url,
    required this.title,
    this.author,
    this.description,
    this.coverUrl,
    this.status,
    this.genres,
    required this.inLibrary,
    this.dateAdded,
    this.lastFetched,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_id'] = Variable<String>(sourceId);
    map['url'] = Variable<String>(url);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || coverUrl != null) {
      map['cover_url'] = Variable<String>(coverUrl);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || genres != null) {
      map['genres'] = Variable<String>(genres);
    }
    map['in_library'] = Variable<bool>(inLibrary);
    if (!nullToAbsent || dateAdded != null) {
      map['date_added'] = Variable<DateTime>(dateAdded);
    }
    if (!nullToAbsent || lastFetched != null) {
      map['last_fetched'] = Variable<DateTime>(lastFetched);
    }
    return map;
  }

  NovelsCompanion toCompanion(bool nullToAbsent) {
    return NovelsCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      url: Value(url),
      title: Value(title),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      coverUrl: coverUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(coverUrl),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      genres: genres == null && nullToAbsent
          ? const Value.absent()
          : Value(genres),
      inLibrary: Value(inLibrary),
      dateAdded: dateAdded == null && nullToAbsent
          ? const Value.absent()
          : Value(dateAdded),
      lastFetched: lastFetched == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFetched),
    );
  }

  factory Novel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Novel(
      id: serializer.fromJson<String>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      url: serializer.fromJson<String>(json['url']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String?>(json['author']),
      description: serializer.fromJson<String?>(json['description']),
      coverUrl: serializer.fromJson<String?>(json['coverUrl']),
      status: serializer.fromJson<String?>(json['status']),
      genres: serializer.fromJson<String?>(json['genres']),
      inLibrary: serializer.fromJson<bool>(json['inLibrary']),
      dateAdded: serializer.fromJson<DateTime?>(json['dateAdded']),
      lastFetched: serializer.fromJson<DateTime?>(json['lastFetched']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'url': serializer.toJson<String>(url),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String?>(author),
      'description': serializer.toJson<String?>(description),
      'coverUrl': serializer.toJson<String?>(coverUrl),
      'status': serializer.toJson<String?>(status),
      'genres': serializer.toJson<String?>(genres),
      'inLibrary': serializer.toJson<bool>(inLibrary),
      'dateAdded': serializer.toJson<DateTime?>(dateAdded),
      'lastFetched': serializer.toJson<DateTime?>(lastFetched),
    };
  }

  Novel copyWith({
    String? id,
    String? sourceId,
    String? url,
    String? title,
    Value<String?> author = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> coverUrl = const Value.absent(),
    Value<String?> status = const Value.absent(),
    Value<String?> genres = const Value.absent(),
    bool? inLibrary,
    Value<DateTime?> dateAdded = const Value.absent(),
    Value<DateTime?> lastFetched = const Value.absent(),
  }) => Novel(
    id: id ?? this.id,
    sourceId: sourceId ?? this.sourceId,
    url: url ?? this.url,
    title: title ?? this.title,
    author: author.present ? author.value : this.author,
    description: description.present ? description.value : this.description,
    coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
    status: status.present ? status.value : this.status,
    genres: genres.present ? genres.value : this.genres,
    inLibrary: inLibrary ?? this.inLibrary,
    dateAdded: dateAdded.present ? dateAdded.value : this.dateAdded,
    lastFetched: lastFetched.present ? lastFetched.value : this.lastFetched,
  );
  Novel copyWithCompanion(NovelsCompanion data) {
    return Novel(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      url: data.url.present ? data.url.value : this.url,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      description: data.description.present
          ? data.description.value
          : this.description,
      coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
      status: data.status.present ? data.status.value : this.status,
      genres: data.genres.present ? data.genres.value : this.genres,
      inLibrary: data.inLibrary.present ? data.inLibrary.value : this.inLibrary,
      dateAdded: data.dateAdded.present ? data.dateAdded.value : this.dateAdded,
      lastFetched: data.lastFetched.present
          ? data.lastFetched.value
          : this.lastFetched,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Novel(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('url: $url, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('description: $description, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('status: $status, ')
          ..write('genres: $genres, ')
          ..write('inLibrary: $inLibrary, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('lastFetched: $lastFetched')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceId,
    url,
    title,
    author,
    description,
    coverUrl,
    status,
    genres,
    inLibrary,
    dateAdded,
    lastFetched,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Novel &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.url == this.url &&
          other.title == this.title &&
          other.author == this.author &&
          other.description == this.description &&
          other.coverUrl == this.coverUrl &&
          other.status == this.status &&
          other.genres == this.genres &&
          other.inLibrary == this.inLibrary &&
          other.dateAdded == this.dateAdded &&
          other.lastFetched == this.lastFetched);
}

class NovelsCompanion extends UpdateCompanion<Novel> {
  final Value<String> id;
  final Value<String> sourceId;
  final Value<String> url;
  final Value<String> title;
  final Value<String?> author;
  final Value<String?> description;
  final Value<String?> coverUrl;
  final Value<String?> status;
  final Value<String?> genres;
  final Value<bool> inLibrary;
  final Value<DateTime?> dateAdded;
  final Value<DateTime?> lastFetched;
  final Value<int> rowid;
  const NovelsCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.url = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.description = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.genres = const Value.absent(),
    this.inLibrary = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.lastFetched = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NovelsCompanion.insert({
    required String id,
    required String sourceId,
    required String url,
    required String title,
    this.author = const Value.absent(),
    this.description = const Value.absent(),
    this.coverUrl = const Value.absent(),
    this.status = const Value.absent(),
    this.genres = const Value.absent(),
    this.inLibrary = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.lastFetched = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceId = Value(sourceId),
       url = Value(url),
       title = Value(title);
  static Insertable<Novel> custom({
    Expression<String>? id,
    Expression<String>? sourceId,
    Expression<String>? url,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? description,
    Expression<String>? coverUrl,
    Expression<String>? status,
    Expression<String>? genres,
    Expression<bool>? inLibrary,
    Expression<DateTime>? dateAdded,
    Expression<DateTime>? lastFetched,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (url != null) 'url': url,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (description != null) 'description': description,
      if (coverUrl != null) 'cover_url': coverUrl,
      if (status != null) 'status': status,
      if (genres != null) 'genres': genres,
      if (inLibrary != null) 'in_library': inLibrary,
      if (dateAdded != null) 'date_added': dateAdded,
      if (lastFetched != null) 'last_fetched': lastFetched,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NovelsCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceId,
    Value<String>? url,
    Value<String>? title,
    Value<String?>? author,
    Value<String?>? description,
    Value<String?>? coverUrl,
    Value<String?>? status,
    Value<String?>? genres,
    Value<bool>? inLibrary,
    Value<DateTime?>? dateAdded,
    Value<DateTime?>? lastFetched,
    Value<int>? rowid,
  }) {
    return NovelsCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      url: url ?? this.url,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      status: status ?? this.status,
      genres: genres ?? this.genres,
      inLibrary: inLibrary ?? this.inLibrary,
      dateAdded: dateAdded ?? this.dateAdded,
      lastFetched: lastFetched ?? this.lastFetched,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (coverUrl.present) {
      map['cover_url'] = Variable<String>(coverUrl.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (genres.present) {
      map['genres'] = Variable<String>(genres.value);
    }
    if (inLibrary.present) {
      map['in_library'] = Variable<bool>(inLibrary.value);
    }
    if (dateAdded.present) {
      map['date_added'] = Variable<DateTime>(dateAdded.value);
    }
    if (lastFetched.present) {
      map['last_fetched'] = Variable<DateTime>(lastFetched.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NovelsCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('url: $url, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('description: $description, ')
          ..write('coverUrl: $coverUrl, ')
          ..write('status: $status, ')
          ..write('genres: $genres, ')
          ..write('inLibrary: $inLibrary, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('lastFetched: $lastFetched, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTable extends Chapters with TableInfo<$ChaptersTable, Chapter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _novelIdMeta = const VerificationMeta(
    'novelId',
  );
  @override
  late final GeneratedColumn<String> novelId = GeneratedColumn<String>(
    'novel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES novels (id)',
    ),
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<double> number = GeneratedColumn<double>(
    'number',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateUploadMeta = const VerificationMeta(
    'dateUpload',
  );
  @override
  late final GeneratedColumn<DateTime> dateUpload = GeneratedColumn<DateTime>(
    'date_upload',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _readMeta = const VerificationMeta('read');
  @override
  late final GeneratedColumn<bool> read = GeneratedColumn<bool>(
    'read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastPageReadMeta = const VerificationMeta(
    'lastPageRead',
  );
  @override
  late final GeneratedColumn<int> lastPageRead = GeneratedColumn<int>(
    'last_page_read',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _downloadedMeta = const VerificationMeta(
    'downloaded',
  );
  @override
  late final GeneratedColumn<bool> downloaded = GeneratedColumn<bool>(
    'downloaded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("downloaded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    novelId,
    url,
    name,
    number,
    dateUpload,
    read,
    lastPageRead,
    downloaded,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters';
  @override
  VerificationContext validateIntegrity(
    Insertable<Chapter> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('novel_id')) {
      context.handle(
        _novelIdMeta,
        novelId.isAcceptableOrUnknown(data['novel_id']!, _novelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_novelIdMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    }
    if (data.containsKey('date_upload')) {
      context.handle(
        _dateUploadMeta,
        dateUpload.isAcceptableOrUnknown(data['date_upload']!, _dateUploadMeta),
      );
    }
    if (data.containsKey('read')) {
      context.handle(
        _readMeta,
        read.isAcceptableOrUnknown(data['read']!, _readMeta),
      );
    }
    if (data.containsKey('last_page_read')) {
      context.handle(
        _lastPageReadMeta,
        lastPageRead.isAcceptableOrUnknown(
          data['last_page_read']!,
          _lastPageReadMeta,
        ),
      );
    }
    if (data.containsKey('downloaded')) {
      context.handle(
        _downloadedMeta,
        downloaded.isAcceptableOrUnknown(data['downloaded']!, _downloadedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chapter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chapter(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      novelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}novel_id'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}number'],
      ),
      dateUpload: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_upload'],
      ),
      read: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}read'],
      )!,
      lastPageRead: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_page_read'],
      )!,
      downloaded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}downloaded'],
      )!,
    );
  }

  @override
  $ChaptersTable createAlias(String alias) {
    return $ChaptersTable(attachedDatabase, alias);
  }
}

class Chapter extends DataClass implements Insertable<Chapter> {
  final String id;
  final String novelId;
  final String url;
  final String name;
  final double? number;
  final DateTime? dateUpload;
  final bool read;
  final int lastPageRead;
  final bool downloaded;
  const Chapter({
    required this.id,
    required this.novelId,
    required this.url,
    required this.name,
    this.number,
    this.dateUpload,
    required this.read,
    required this.lastPageRead,
    required this.downloaded,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['novel_id'] = Variable<String>(novelId);
    map['url'] = Variable<String>(url);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || number != null) {
      map['number'] = Variable<double>(number);
    }
    if (!nullToAbsent || dateUpload != null) {
      map['date_upload'] = Variable<DateTime>(dateUpload);
    }
    map['read'] = Variable<bool>(read);
    map['last_page_read'] = Variable<int>(lastPageRead);
    map['downloaded'] = Variable<bool>(downloaded);
    return map;
  }

  ChaptersCompanion toCompanion(bool nullToAbsent) {
    return ChaptersCompanion(
      id: Value(id),
      novelId: Value(novelId),
      url: Value(url),
      name: Value(name),
      number: number == null && nullToAbsent
          ? const Value.absent()
          : Value(number),
      dateUpload: dateUpload == null && nullToAbsent
          ? const Value.absent()
          : Value(dateUpload),
      read: Value(read),
      lastPageRead: Value(lastPageRead),
      downloaded: Value(downloaded),
    );
  }

  factory Chapter.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chapter(
      id: serializer.fromJson<String>(json['id']),
      novelId: serializer.fromJson<String>(json['novelId']),
      url: serializer.fromJson<String>(json['url']),
      name: serializer.fromJson<String>(json['name']),
      number: serializer.fromJson<double?>(json['number']),
      dateUpload: serializer.fromJson<DateTime?>(json['dateUpload']),
      read: serializer.fromJson<bool>(json['read']),
      lastPageRead: serializer.fromJson<int>(json['lastPageRead']),
      downloaded: serializer.fromJson<bool>(json['downloaded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'novelId': serializer.toJson<String>(novelId),
      'url': serializer.toJson<String>(url),
      'name': serializer.toJson<String>(name),
      'number': serializer.toJson<double?>(number),
      'dateUpload': serializer.toJson<DateTime?>(dateUpload),
      'read': serializer.toJson<bool>(read),
      'lastPageRead': serializer.toJson<int>(lastPageRead),
      'downloaded': serializer.toJson<bool>(downloaded),
    };
  }

  Chapter copyWith({
    String? id,
    String? novelId,
    String? url,
    String? name,
    Value<double?> number = const Value.absent(),
    Value<DateTime?> dateUpload = const Value.absent(),
    bool? read,
    int? lastPageRead,
    bool? downloaded,
  }) => Chapter(
    id: id ?? this.id,
    novelId: novelId ?? this.novelId,
    url: url ?? this.url,
    name: name ?? this.name,
    number: number.present ? number.value : this.number,
    dateUpload: dateUpload.present ? dateUpload.value : this.dateUpload,
    read: read ?? this.read,
    lastPageRead: lastPageRead ?? this.lastPageRead,
    downloaded: downloaded ?? this.downloaded,
  );
  Chapter copyWithCompanion(ChaptersCompanion data) {
    return Chapter(
      id: data.id.present ? data.id.value : this.id,
      novelId: data.novelId.present ? data.novelId.value : this.novelId,
      url: data.url.present ? data.url.value : this.url,
      name: data.name.present ? data.name.value : this.name,
      number: data.number.present ? data.number.value : this.number,
      dateUpload: data.dateUpload.present
          ? data.dateUpload.value
          : this.dateUpload,
      read: data.read.present ? data.read.value : this.read,
      lastPageRead: data.lastPageRead.present
          ? data.lastPageRead.value
          : this.lastPageRead,
      downloaded: data.downloaded.present
          ? data.downloaded.value
          : this.downloaded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chapter(')
          ..write('id: $id, ')
          ..write('novelId: $novelId, ')
          ..write('url: $url, ')
          ..write('name: $name, ')
          ..write('number: $number, ')
          ..write('dateUpload: $dateUpload, ')
          ..write('read: $read, ')
          ..write('lastPageRead: $lastPageRead, ')
          ..write('downloaded: $downloaded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    novelId,
    url,
    name,
    number,
    dateUpload,
    read,
    lastPageRead,
    downloaded,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chapter &&
          other.id == this.id &&
          other.novelId == this.novelId &&
          other.url == this.url &&
          other.name == this.name &&
          other.number == this.number &&
          other.dateUpload == this.dateUpload &&
          other.read == this.read &&
          other.lastPageRead == this.lastPageRead &&
          other.downloaded == this.downloaded);
}

class ChaptersCompanion extends UpdateCompanion<Chapter> {
  final Value<String> id;
  final Value<String> novelId;
  final Value<String> url;
  final Value<String> name;
  final Value<double?> number;
  final Value<DateTime?> dateUpload;
  final Value<bool> read;
  final Value<int> lastPageRead;
  final Value<bool> downloaded;
  final Value<int> rowid;
  const ChaptersCompanion({
    this.id = const Value.absent(),
    this.novelId = const Value.absent(),
    this.url = const Value.absent(),
    this.name = const Value.absent(),
    this.number = const Value.absent(),
    this.dateUpload = const Value.absent(),
    this.read = const Value.absent(),
    this.lastPageRead = const Value.absent(),
    this.downloaded = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChaptersCompanion.insert({
    required String id,
    required String novelId,
    required String url,
    required String name,
    this.number = const Value.absent(),
    this.dateUpload = const Value.absent(),
    this.read = const Value.absent(),
    this.lastPageRead = const Value.absent(),
    this.downloaded = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       novelId = Value(novelId),
       url = Value(url),
       name = Value(name);
  static Insertable<Chapter> custom({
    Expression<String>? id,
    Expression<String>? novelId,
    Expression<String>? url,
    Expression<String>? name,
    Expression<double>? number,
    Expression<DateTime>? dateUpload,
    Expression<bool>? read,
    Expression<int>? lastPageRead,
    Expression<bool>? downloaded,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (novelId != null) 'novel_id': novelId,
      if (url != null) 'url': url,
      if (name != null) 'name': name,
      if (number != null) 'number': number,
      if (dateUpload != null) 'date_upload': dateUpload,
      if (read != null) 'read': read,
      if (lastPageRead != null) 'last_page_read': lastPageRead,
      if (downloaded != null) 'downloaded': downloaded,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChaptersCompanion copyWith({
    Value<String>? id,
    Value<String>? novelId,
    Value<String>? url,
    Value<String>? name,
    Value<double?>? number,
    Value<DateTime?>? dateUpload,
    Value<bool>? read,
    Value<int>? lastPageRead,
    Value<bool>? downloaded,
    Value<int>? rowid,
  }) {
    return ChaptersCompanion(
      id: id ?? this.id,
      novelId: novelId ?? this.novelId,
      url: url ?? this.url,
      name: name ?? this.name,
      number: number ?? this.number,
      dateUpload: dateUpload ?? this.dateUpload,
      read: read ?? this.read,
      lastPageRead: lastPageRead ?? this.lastPageRead,
      downloaded: downloaded ?? this.downloaded,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (novelId.present) {
      map['novel_id'] = Variable<String>(novelId.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (number.present) {
      map['number'] = Variable<double>(number.value);
    }
    if (dateUpload.present) {
      map['date_upload'] = Variable<DateTime>(dateUpload.value);
    }
    if (read.present) {
      map['read'] = Variable<bool>(read.value);
    }
    if (lastPageRead.present) {
      map['last_page_read'] = Variable<int>(lastPageRead.value);
    }
    if (downloaded.present) {
      map['downloaded'] = Variable<bool>(downloaded.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersCompanion(')
          ..write('id: $id, ')
          ..write('novelId: $novelId, ')
          ..write('url: $url, ')
          ..write('name: $name, ')
          ..write('number: $number, ')
          ..write('dateUpload: $dateUpload, ')
          ..write('read: $read, ')
          ..write('lastPageRead: $lastPageRead, ')
          ..write('downloaded: $downloaded, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HistoryTable extends History with TableInfo<$HistoryTable, HistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HistoryTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chapters (id)',
    ),
  );
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
    'read_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeSpentMsMeta = const VerificationMeta(
    'timeSpentMs',
  );
  @override
  late final GeneratedColumn<int> timeSpentMs = GeneratedColumn<int>(
    'time_spent_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordsReadMeta = const VerificationMeta(
    'wordsRead',
  );
  @override
  late final GeneratedColumn<int> wordsRead = GeneratedColumn<int>(
    'words_read',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    chapterId,
    readAt,
    timeSpentMs,
    wordsRead,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'history';
  @override
  VerificationContext validateIntegrity(
    Insertable<HistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    } else if (isInserting) {
      context.missing(_readAtMeta);
    }
    if (data.containsKey('time_spent_ms')) {
      context.handle(
        _timeSpentMsMeta,
        timeSpentMs.isAcceptableOrUnknown(
          data['time_spent_ms']!,
          _timeSpentMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timeSpentMsMeta);
    }
    if (data.containsKey('words_read')) {
      context.handle(
        _wordsReadMeta,
        wordsRead.isAcceptableOrUnknown(data['words_read']!, _wordsReadMeta),
      );
    } else if (isInserting) {
      context.missing(_wordsReadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_id'],
      )!,
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}read_at'],
      )!,
      timeSpentMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_spent_ms'],
      )!,
      wordsRead: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}words_read'],
      )!,
    );
  }

  @override
  $HistoryTable createAlias(String alias) {
    return $HistoryTable(attachedDatabase, alias);
  }
}

class HistoryData extends DataClass implements Insertable<HistoryData> {
  final int id;
  final String chapterId;
  final DateTime readAt;
  final int timeSpentMs;
  final int wordsRead;
  const HistoryData({
    required this.id,
    required this.chapterId,
    required this.readAt,
    required this.timeSpentMs,
    required this.wordsRead,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['chapter_id'] = Variable<String>(chapterId);
    map['read_at'] = Variable<DateTime>(readAt);
    map['time_spent_ms'] = Variable<int>(timeSpentMs);
    map['words_read'] = Variable<int>(wordsRead);
    return map;
  }

  HistoryCompanion toCompanion(bool nullToAbsent) {
    return HistoryCompanion(
      id: Value(id),
      chapterId: Value(chapterId),
      readAt: Value(readAt),
      timeSpentMs: Value(timeSpentMs),
      wordsRead: Value(wordsRead),
    );
  }

  factory HistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HistoryData(
      id: serializer.fromJson<int>(json['id']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      readAt: serializer.fromJson<DateTime>(json['readAt']),
      timeSpentMs: serializer.fromJson<int>(json['timeSpentMs']),
      wordsRead: serializer.fromJson<int>(json['wordsRead']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'chapterId': serializer.toJson<String>(chapterId),
      'readAt': serializer.toJson<DateTime>(readAt),
      'timeSpentMs': serializer.toJson<int>(timeSpentMs),
      'wordsRead': serializer.toJson<int>(wordsRead),
    };
  }

  HistoryData copyWith({
    int? id,
    String? chapterId,
    DateTime? readAt,
    int? timeSpentMs,
    int? wordsRead,
  }) => HistoryData(
    id: id ?? this.id,
    chapterId: chapterId ?? this.chapterId,
    readAt: readAt ?? this.readAt,
    timeSpentMs: timeSpentMs ?? this.timeSpentMs,
    wordsRead: wordsRead ?? this.wordsRead,
  );
  HistoryData copyWithCompanion(HistoryCompanion data) {
    return HistoryData(
      id: data.id.present ? data.id.value : this.id,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
      timeSpentMs: data.timeSpentMs.present
          ? data.timeSpentMs.value
          : this.timeSpentMs,
      wordsRead: data.wordsRead.present ? data.wordsRead.value : this.wordsRead,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HistoryData(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('readAt: $readAt, ')
          ..write('timeSpentMs: $timeSpentMs, ')
          ..write('wordsRead: $wordsRead')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, chapterId, readAt, timeSpentMs, wordsRead);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HistoryData &&
          other.id == this.id &&
          other.chapterId == this.chapterId &&
          other.readAt == this.readAt &&
          other.timeSpentMs == this.timeSpentMs &&
          other.wordsRead == this.wordsRead);
}

class HistoryCompanion extends UpdateCompanion<HistoryData> {
  final Value<int> id;
  final Value<String> chapterId;
  final Value<DateTime> readAt;
  final Value<int> timeSpentMs;
  final Value<int> wordsRead;
  const HistoryCompanion({
    this.id = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.readAt = const Value.absent(),
    this.timeSpentMs = const Value.absent(),
    this.wordsRead = const Value.absent(),
  });
  HistoryCompanion.insert({
    this.id = const Value.absent(),
    required String chapterId,
    required DateTime readAt,
    required int timeSpentMs,
    required int wordsRead,
  }) : chapterId = Value(chapterId),
       readAt = Value(readAt),
       timeSpentMs = Value(timeSpentMs),
       wordsRead = Value(wordsRead);
  static Insertable<HistoryData> custom({
    Expression<int>? id,
    Expression<String>? chapterId,
    Expression<DateTime>? readAt,
    Expression<int>? timeSpentMs,
    Expression<int>? wordsRead,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chapterId != null) 'chapter_id': chapterId,
      if (readAt != null) 'read_at': readAt,
      if (timeSpentMs != null) 'time_spent_ms': timeSpentMs,
      if (wordsRead != null) 'words_read': wordsRead,
    });
  }

  HistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? chapterId,
    Value<DateTime>? readAt,
    Value<int>? timeSpentMs,
    Value<int>? wordsRead,
  }) {
    return HistoryCompanion(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      readAt: readAt ?? this.readAt,
      timeSpentMs: timeSpentMs ?? this.timeSpentMs,
      wordsRead: wordsRead ?? this.wordsRead,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (timeSpentMs.present) {
      map['time_spent_ms'] = Variable<int>(timeSpentMs.value);
    }
    if (wordsRead.present) {
      map['words_read'] = Variable<int>(wordsRead.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HistoryCompanion(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('readAt: $readAt, ')
          ..write('timeSpentMs: $timeSpentMs, ')
          ..write('wordsRead: $wordsRead')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, orderIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final int orderIndex;
  const Category({
    required this.id,
    required this.name,
    required this.orderIndex,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      orderIndex: Value(orderIndex),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  Category copyWith({int? id, String? name, int? orderIndex}) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    orderIndex: orderIndex ?? this.orderIndex,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.orderIndex == this.orderIndex);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> orderIndex;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.orderIndex = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int orderIndex,
  }) : name = Value(name),
       orderIndex = Value(orderIndex);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? orderIndex,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (orderIndex != null) 'order_index': orderIndex,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? orderIndex,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }
}

class $NovelCategoriesTable extends NovelCategories
    with TableInfo<$NovelCategoriesTable, NovelCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NovelCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _novelIdMeta = const VerificationMeta(
    'novelId',
  );
  @override
  late final GeneratedColumn<String> novelId = GeneratedColumn<String>(
    'novel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES novels (id)',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [novelId, categoryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'novel_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<NovelCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('novel_id')) {
      context.handle(
        _novelIdMeta,
        novelId.isAcceptableOrUnknown(data['novel_id']!, _novelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_novelIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {novelId, categoryId};
  @override
  NovelCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NovelCategory(
      novelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}novel_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
    );
  }

  @override
  $NovelCategoriesTable createAlias(String alias) {
    return $NovelCategoriesTable(attachedDatabase, alias);
  }
}

class NovelCategory extends DataClass implements Insertable<NovelCategory> {
  final String novelId;
  final int categoryId;
  const NovelCategory({required this.novelId, required this.categoryId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['novel_id'] = Variable<String>(novelId);
    map['category_id'] = Variable<int>(categoryId);
    return map;
  }

  NovelCategoriesCompanion toCompanion(bool nullToAbsent) {
    return NovelCategoriesCompanion(
      novelId: Value(novelId),
      categoryId: Value(categoryId),
    );
  }

  factory NovelCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NovelCategory(
      novelId: serializer.fromJson<String>(json['novelId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'novelId': serializer.toJson<String>(novelId),
      'categoryId': serializer.toJson<int>(categoryId),
    };
  }

  NovelCategory copyWith({String? novelId, int? categoryId}) => NovelCategory(
    novelId: novelId ?? this.novelId,
    categoryId: categoryId ?? this.categoryId,
  );
  NovelCategory copyWithCompanion(NovelCategoriesCompanion data) {
    return NovelCategory(
      novelId: data.novelId.present ? data.novelId.value : this.novelId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NovelCategory(')
          ..write('novelId: $novelId, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(novelId, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NovelCategory &&
          other.novelId == this.novelId &&
          other.categoryId == this.categoryId);
}

class NovelCategoriesCompanion extends UpdateCompanion<NovelCategory> {
  final Value<String> novelId;
  final Value<int> categoryId;
  final Value<int> rowid;
  const NovelCategoriesCompanion({
    this.novelId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NovelCategoriesCompanion.insert({
    required String novelId,
    required int categoryId,
    this.rowid = const Value.absent(),
  }) : novelId = Value(novelId),
       categoryId = Value(categoryId);
  static Insertable<NovelCategory> custom({
    Expression<String>? novelId,
    Expression<int>? categoryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (novelId != null) 'novel_id': novelId,
      if (categoryId != null) 'category_id': categoryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NovelCategoriesCompanion copyWith({
    Value<String>? novelId,
    Value<int>? categoryId,
    Value<int>? rowid,
  }) {
    return NovelCategoriesCompanion(
      novelId: novelId ?? this.novelId,
      categoryId: categoryId ?? this.categoryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (novelId.present) {
      map['novel_id'] = Variable<String>(novelId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NovelCategoriesCompanion(')
          ..write('novelId: $novelId, ')
          ..write('categoryId: $categoryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LibraryFlagsTable extends LibraryFlags
    with TableInfo<$LibraryFlagsTable, LibraryFlag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibraryFlagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _novelIdMeta = const VerificationMeta(
    'novelId',
  );
  @override
  late final GeneratedColumn<String> novelId = GeneratedColumn<String>(
    'novel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES novels (id)',
    ),
  );
  static const VerificationMeta _favoriteMeta = const VerificationMeta(
    'favorite',
  );
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _customCoverMeta = const VerificationMeta(
    'customCover',
  );
  @override
  late final GeneratedColumn<String> customCover = GeneratedColumn<String>(
    'custom_cover',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _readingModeMeta = const VerificationMeta(
    'readingMode',
  );
  @override
  late final GeneratedColumn<String> readingMode = GeneratedColumn<String>(
    'reading_mode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayModeMeta = const VerificationMeta(
    'displayMode',
  );
  @override
  late final GeneratedColumn<String> displayMode = GeneratedColumn<String>(
    'display_mode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    novelId,
    favorite,
    customCover,
    readingMode,
    displayMode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_flags';
  @override
  VerificationContext validateIntegrity(
    Insertable<LibraryFlag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('novel_id')) {
      context.handle(
        _novelIdMeta,
        novelId.isAcceptableOrUnknown(data['novel_id']!, _novelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_novelIdMeta);
    }
    if (data.containsKey('favorite')) {
      context.handle(
        _favoriteMeta,
        favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta),
      );
    }
    if (data.containsKey('custom_cover')) {
      context.handle(
        _customCoverMeta,
        customCover.isAcceptableOrUnknown(
          data['custom_cover']!,
          _customCoverMeta,
        ),
      );
    }
    if (data.containsKey('reading_mode')) {
      context.handle(
        _readingModeMeta,
        readingMode.isAcceptableOrUnknown(
          data['reading_mode']!,
          _readingModeMeta,
        ),
      );
    }
    if (data.containsKey('display_mode')) {
      context.handle(
        _displayModeMeta,
        displayMode.isAcceptableOrUnknown(
          data['display_mode']!,
          _displayModeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {novelId};
  @override
  LibraryFlag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryFlag(
      novelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}novel_id'],
      )!,
      favorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}favorite'],
      )!,
      customCover: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_cover'],
      ),
      readingMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading_mode'],
      ),
      displayMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_mode'],
      ),
    );
  }

  @override
  $LibraryFlagsTable createAlias(String alias) {
    return $LibraryFlagsTable(attachedDatabase, alias);
  }
}

class LibraryFlag extends DataClass implements Insertable<LibraryFlag> {
  final String novelId;
  final bool favorite;
  final String? customCover;
  final String? readingMode;
  final String? displayMode;
  const LibraryFlag({
    required this.novelId,
    required this.favorite,
    this.customCover,
    this.readingMode,
    this.displayMode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['novel_id'] = Variable<String>(novelId);
    map['favorite'] = Variable<bool>(favorite);
    if (!nullToAbsent || customCover != null) {
      map['custom_cover'] = Variable<String>(customCover);
    }
    if (!nullToAbsent || readingMode != null) {
      map['reading_mode'] = Variable<String>(readingMode);
    }
    if (!nullToAbsent || displayMode != null) {
      map['display_mode'] = Variable<String>(displayMode);
    }
    return map;
  }

  LibraryFlagsCompanion toCompanion(bool nullToAbsent) {
    return LibraryFlagsCompanion(
      novelId: Value(novelId),
      favorite: Value(favorite),
      customCover: customCover == null && nullToAbsent
          ? const Value.absent()
          : Value(customCover),
      readingMode: readingMode == null && nullToAbsent
          ? const Value.absent()
          : Value(readingMode),
      displayMode: displayMode == null && nullToAbsent
          ? const Value.absent()
          : Value(displayMode),
    );
  }

  factory LibraryFlag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryFlag(
      novelId: serializer.fromJson<String>(json['novelId']),
      favorite: serializer.fromJson<bool>(json['favorite']),
      customCover: serializer.fromJson<String?>(json['customCover']),
      readingMode: serializer.fromJson<String?>(json['readingMode']),
      displayMode: serializer.fromJson<String?>(json['displayMode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'novelId': serializer.toJson<String>(novelId),
      'favorite': serializer.toJson<bool>(favorite),
      'customCover': serializer.toJson<String?>(customCover),
      'readingMode': serializer.toJson<String?>(readingMode),
      'displayMode': serializer.toJson<String?>(displayMode),
    };
  }

  LibraryFlag copyWith({
    String? novelId,
    bool? favorite,
    Value<String?> customCover = const Value.absent(),
    Value<String?> readingMode = const Value.absent(),
    Value<String?> displayMode = const Value.absent(),
  }) => LibraryFlag(
    novelId: novelId ?? this.novelId,
    favorite: favorite ?? this.favorite,
    customCover: customCover.present ? customCover.value : this.customCover,
    readingMode: readingMode.present ? readingMode.value : this.readingMode,
    displayMode: displayMode.present ? displayMode.value : this.displayMode,
  );
  LibraryFlag copyWithCompanion(LibraryFlagsCompanion data) {
    return LibraryFlag(
      novelId: data.novelId.present ? data.novelId.value : this.novelId,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      customCover: data.customCover.present
          ? data.customCover.value
          : this.customCover,
      readingMode: data.readingMode.present
          ? data.readingMode.value
          : this.readingMode,
      displayMode: data.displayMode.present
          ? data.displayMode.value
          : this.displayMode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryFlag(')
          ..write('novelId: $novelId, ')
          ..write('favorite: $favorite, ')
          ..write('customCover: $customCover, ')
          ..write('readingMode: $readingMode, ')
          ..write('displayMode: $displayMode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(novelId, favorite, customCover, readingMode, displayMode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryFlag &&
          other.novelId == this.novelId &&
          other.favorite == this.favorite &&
          other.customCover == this.customCover &&
          other.readingMode == this.readingMode &&
          other.displayMode == this.displayMode);
}

class LibraryFlagsCompanion extends UpdateCompanion<LibraryFlag> {
  final Value<String> novelId;
  final Value<bool> favorite;
  final Value<String?> customCover;
  final Value<String?> readingMode;
  final Value<String?> displayMode;
  final Value<int> rowid;
  const LibraryFlagsCompanion({
    this.novelId = const Value.absent(),
    this.favorite = const Value.absent(),
    this.customCover = const Value.absent(),
    this.readingMode = const Value.absent(),
    this.displayMode = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LibraryFlagsCompanion.insert({
    required String novelId,
    this.favorite = const Value.absent(),
    this.customCover = const Value.absent(),
    this.readingMode = const Value.absent(),
    this.displayMode = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : novelId = Value(novelId);
  static Insertable<LibraryFlag> custom({
    Expression<String>? novelId,
    Expression<bool>? favorite,
    Expression<String>? customCover,
    Expression<String>? readingMode,
    Expression<String>? displayMode,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (novelId != null) 'novel_id': novelId,
      if (favorite != null) 'favorite': favorite,
      if (customCover != null) 'custom_cover': customCover,
      if (readingMode != null) 'reading_mode': readingMode,
      if (displayMode != null) 'display_mode': displayMode,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LibraryFlagsCompanion copyWith({
    Value<String>? novelId,
    Value<bool>? favorite,
    Value<String?>? customCover,
    Value<String?>? readingMode,
    Value<String?>? displayMode,
    Value<int>? rowid,
  }) {
    return LibraryFlagsCompanion(
      novelId: novelId ?? this.novelId,
      favorite: favorite ?? this.favorite,
      customCover: customCover ?? this.customCover,
      readingMode: readingMode ?? this.readingMode,
      displayMode: displayMode ?? this.displayMode,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (novelId.present) {
      map['novel_id'] = Variable<String>(novelId.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (customCover.present) {
      map['custom_cover'] = Variable<String>(customCover.value);
    }
    if (readingMode.present) {
      map['reading_mode'] = Variable<String>(readingMode.value);
    }
    if (displayMode.present) {
      map['display_mode'] = Variable<String>(displayMode.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibraryFlagsCompanion(')
          ..write('novelId: $novelId, ')
          ..write('favorite: $favorite, ')
          ..write('customCover: $customCover, ')
          ..write('readingMode: $readingMode, ')
          ..write('displayMode: $displayMode, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrackerItemsTable extends TrackerItems
    with TableInfo<$TrackerItemsTable, TrackerItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackerItemsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _novelIdMeta = const VerificationMeta(
    'novelId',
  );
  @override
  late final GeneratedColumn<String> novelId = GeneratedColumn<String>(
    'novel_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES novels (id)',
    ),
  );
  static const VerificationMeta _trackerIdMeta = const VerificationMeta(
    'trackerId',
  );
  @override
  late final GeneratedColumn<String> trackerId = GeneratedColumn<String>(
    'tracker_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastChapterMeta = const VerificationMeta(
    'lastChapter',
  );
  @override
  late final GeneratedColumn<int> lastChapter = GeneratedColumn<int>(
    'last_chapter',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    novelId,
    trackerId,
    remoteId,
    status,
    score,
    lastChapter,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tracker_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrackerItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('novel_id')) {
      context.handle(
        _novelIdMeta,
        novelId.isAcceptableOrUnknown(data['novel_id']!, _novelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_novelIdMeta);
    }
    if (data.containsKey('tracker_id')) {
      context.handle(
        _trackerIdMeta,
        trackerId.isAcceptableOrUnknown(data['tracker_id']!, _trackerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackerIdMeta);
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_remoteIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('last_chapter')) {
      context.handle(
        _lastChapterMeta,
        lastChapter.isAcceptableOrUnknown(
          data['last_chapter']!,
          _lastChapterMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackerItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackerItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      novelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}novel_id'],
      )!,
      trackerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracker_id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      ),
      lastChapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_chapter'],
      ),
    );
  }

  @override
  $TrackerItemsTable createAlias(String alias) {
    return $TrackerItemsTable(attachedDatabase, alias);
  }
}

class TrackerItem extends DataClass implements Insertable<TrackerItem> {
  final int id;
  final String novelId;
  final String trackerId;
  final String remoteId;
  final String? status;
  final double? score;
  final int? lastChapter;
  const TrackerItem({
    required this.id,
    required this.novelId,
    required this.trackerId,
    required this.remoteId,
    this.status,
    this.score,
    this.lastChapter,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['novel_id'] = Variable<String>(novelId);
    map['tracker_id'] = Variable<String>(trackerId);
    map['remote_id'] = Variable<String>(remoteId);
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<double>(score);
    }
    if (!nullToAbsent || lastChapter != null) {
      map['last_chapter'] = Variable<int>(lastChapter);
    }
    return map;
  }

  TrackerItemsCompanion toCompanion(bool nullToAbsent) {
    return TrackerItemsCompanion(
      id: Value(id),
      novelId: Value(novelId),
      trackerId: Value(trackerId),
      remoteId: Value(remoteId),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
      lastChapter: lastChapter == null && nullToAbsent
          ? const Value.absent()
          : Value(lastChapter),
    );
  }

  factory TrackerItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackerItem(
      id: serializer.fromJson<int>(json['id']),
      novelId: serializer.fromJson<String>(json['novelId']),
      trackerId: serializer.fromJson<String>(json['trackerId']),
      remoteId: serializer.fromJson<String>(json['remoteId']),
      status: serializer.fromJson<String?>(json['status']),
      score: serializer.fromJson<double?>(json['score']),
      lastChapter: serializer.fromJson<int?>(json['lastChapter']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'novelId': serializer.toJson<String>(novelId),
      'trackerId': serializer.toJson<String>(trackerId),
      'remoteId': serializer.toJson<String>(remoteId),
      'status': serializer.toJson<String?>(status),
      'score': serializer.toJson<double?>(score),
      'lastChapter': serializer.toJson<int?>(lastChapter),
    };
  }

  TrackerItem copyWith({
    int? id,
    String? novelId,
    String? trackerId,
    String? remoteId,
    Value<String?> status = const Value.absent(),
    Value<double?> score = const Value.absent(),
    Value<int?> lastChapter = const Value.absent(),
  }) => TrackerItem(
    id: id ?? this.id,
    novelId: novelId ?? this.novelId,
    trackerId: trackerId ?? this.trackerId,
    remoteId: remoteId ?? this.remoteId,
    status: status.present ? status.value : this.status,
    score: score.present ? score.value : this.score,
    lastChapter: lastChapter.present ? lastChapter.value : this.lastChapter,
  );
  TrackerItem copyWithCompanion(TrackerItemsCompanion data) {
    return TrackerItem(
      id: data.id.present ? data.id.value : this.id,
      novelId: data.novelId.present ? data.novelId.value : this.novelId,
      trackerId: data.trackerId.present ? data.trackerId.value : this.trackerId,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      status: data.status.present ? data.status.value : this.status,
      score: data.score.present ? data.score.value : this.score,
      lastChapter: data.lastChapter.present
          ? data.lastChapter.value
          : this.lastChapter,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackerItem(')
          ..write('id: $id, ')
          ..write('novelId: $novelId, ')
          ..write('trackerId: $trackerId, ')
          ..write('remoteId: $remoteId, ')
          ..write('status: $status, ')
          ..write('score: $score, ')
          ..write('lastChapter: $lastChapter')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, novelId, trackerId, remoteId, status, score, lastChapter);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackerItem &&
          other.id == this.id &&
          other.novelId == this.novelId &&
          other.trackerId == this.trackerId &&
          other.remoteId == this.remoteId &&
          other.status == this.status &&
          other.score == this.score &&
          other.lastChapter == this.lastChapter);
}

class TrackerItemsCompanion extends UpdateCompanion<TrackerItem> {
  final Value<int> id;
  final Value<String> novelId;
  final Value<String> trackerId;
  final Value<String> remoteId;
  final Value<String?> status;
  final Value<double?> score;
  final Value<int?> lastChapter;
  const TrackerItemsCompanion({
    this.id = const Value.absent(),
    this.novelId = const Value.absent(),
    this.trackerId = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.status = const Value.absent(),
    this.score = const Value.absent(),
    this.lastChapter = const Value.absent(),
  });
  TrackerItemsCompanion.insert({
    this.id = const Value.absent(),
    required String novelId,
    required String trackerId,
    required String remoteId,
    this.status = const Value.absent(),
    this.score = const Value.absent(),
    this.lastChapter = const Value.absent(),
  }) : novelId = Value(novelId),
       trackerId = Value(trackerId),
       remoteId = Value(remoteId);
  static Insertable<TrackerItem> custom({
    Expression<int>? id,
    Expression<String>? novelId,
    Expression<String>? trackerId,
    Expression<String>? remoteId,
    Expression<String>? status,
    Expression<double>? score,
    Expression<int>? lastChapter,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (novelId != null) 'novel_id': novelId,
      if (trackerId != null) 'tracker_id': trackerId,
      if (remoteId != null) 'remote_id': remoteId,
      if (status != null) 'status': status,
      if (score != null) 'score': score,
      if (lastChapter != null) 'last_chapter': lastChapter,
    });
  }

  TrackerItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? novelId,
    Value<String>? trackerId,
    Value<String>? remoteId,
    Value<String?>? status,
    Value<double?>? score,
    Value<int?>? lastChapter,
  }) {
    return TrackerItemsCompanion(
      id: id ?? this.id,
      novelId: novelId ?? this.novelId,
      trackerId: trackerId ?? this.trackerId,
      remoteId: remoteId ?? this.remoteId,
      status: status ?? this.status,
      score: score ?? this.score,
      lastChapter: lastChapter ?? this.lastChapter,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (novelId.present) {
      map['novel_id'] = Variable<String>(novelId.value);
    }
    if (trackerId.present) {
      map['tracker_id'] = Variable<String>(trackerId.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (lastChapter.present) {
      map['last_chapter'] = Variable<int>(lastChapter.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackerItemsCompanion(')
          ..write('id: $id, ')
          ..write('novelId: $novelId, ')
          ..write('trackerId: $trackerId, ')
          ..write('remoteId: $remoteId, ')
          ..write('status: $status, ')
          ..write('score: $score, ')
          ..write('lastChapter: $lastChapter')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NovelsTable novels = $NovelsTable(this);
  late final $ChaptersTable chapters = $ChaptersTable(this);
  late final $HistoryTable history = $HistoryTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $NovelCategoriesTable novelCategories = $NovelCategoriesTable(
    this,
  );
  late final $LibraryFlagsTable libraryFlags = $LibraryFlagsTable(this);
  late final $TrackerItemsTable trackerItems = $TrackerItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    novels,
    chapters,
    history,
    categories,
    novelCategories,
    libraryFlags,
    trackerItems,
  ];
}

typedef $$NovelsTableCreateCompanionBuilder =
    NovelsCompanion Function({
      required String id,
      required String sourceId,
      required String url,
      required String title,
      Value<String?> author,
      Value<String?> description,
      Value<String?> coverUrl,
      Value<String?> status,
      Value<String?> genres,
      Value<bool> inLibrary,
      Value<DateTime?> dateAdded,
      Value<DateTime?> lastFetched,
      Value<int> rowid,
    });
typedef $$NovelsTableUpdateCompanionBuilder =
    NovelsCompanion Function({
      Value<String> id,
      Value<String> sourceId,
      Value<String> url,
      Value<String> title,
      Value<String?> author,
      Value<String?> description,
      Value<String?> coverUrl,
      Value<String?> status,
      Value<String?> genres,
      Value<bool> inLibrary,
      Value<DateTime?> dateAdded,
      Value<DateTime?> lastFetched,
      Value<int> rowid,
    });

final class $$NovelsTableReferences
    extends BaseReferences<_$AppDatabase, $NovelsTable, Novel> {
  $$NovelsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChaptersTable, List<Chapter>> _chaptersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.chapters,
    aliasName: $_aliasNameGenerator(db.novels.id, db.chapters.novelId),
  );

  $$ChaptersTableProcessedTableManager get chaptersRefs {
    final manager = $$ChaptersTableTableManager(
      $_db,
      $_db.chapters,
    ).filter((f) => f.novelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_chaptersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NovelCategoriesTable, List<NovelCategory>>
  _novelCategoriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.novelCategories,
    aliasName: $_aliasNameGenerator(db.novels.id, db.novelCategories.novelId),
  );

  $$NovelCategoriesTableProcessedTableManager get novelCategoriesRefs {
    final manager = $$NovelCategoriesTableTableManager(
      $_db,
      $_db.novelCategories,
    ).filter((f) => f.novelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _novelCategoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LibraryFlagsTable, List<LibraryFlag>>
  _libraryFlagsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.libraryFlags,
    aliasName: $_aliasNameGenerator(db.novels.id, db.libraryFlags.novelId),
  );

  $$LibraryFlagsTableProcessedTableManager get libraryFlagsRefs {
    final manager = $$LibraryFlagsTableTableManager(
      $_db,
      $_db.libraryFlags,
    ).filter((f) => f.novelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_libraryFlagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TrackerItemsTable, List<TrackerItem>>
  _trackerItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.trackerItems,
    aliasName: $_aliasNameGenerator(db.novels.id, db.trackerItems.novelId),
  );

  $$TrackerItemsTableProcessedTableManager get trackerItemsRefs {
    final manager = $$TrackerItemsTableTableManager(
      $_db,
      $_db.trackerItems,
    ).filter((f) => f.novelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_trackerItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$NovelsTableFilterComposer
    extends Composer<_$AppDatabase, $NovelsTable> {
  $$NovelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genres => $composableBuilder(
    column: $table.genres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get inLibrary => $composableBuilder(
    column: $table.inLibrary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastFetched => $composableBuilder(
    column: $table.lastFetched,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> chaptersRefs(
    Expression<bool> Function($$ChaptersTableFilterComposer f) f,
  ) {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.novelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableFilterComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> novelCategoriesRefs(
    Expression<bool> Function($$NovelCategoriesTableFilterComposer f) f,
  ) {
    final $$NovelCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.novelCategories,
      getReferencedColumn: (t) => t.novelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.novelCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> libraryFlagsRefs(
    Expression<bool> Function($$LibraryFlagsTableFilterComposer f) f,
  ) {
    final $$LibraryFlagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.libraryFlags,
      getReferencedColumn: (t) => t.novelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LibraryFlagsTableFilterComposer(
            $db: $db,
            $table: $db.libraryFlags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> trackerItemsRefs(
    Expression<bool> Function($$TrackerItemsTableFilterComposer f) f,
  ) {
    final $$TrackerItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackerItems,
      getReferencedColumn: (t) => t.novelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackerItemsTableFilterComposer(
            $db: $db,
            $table: $db.trackerItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NovelsTableOrderingComposer
    extends Composer<_$AppDatabase, $NovelsTable> {
  $$NovelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverUrl => $composableBuilder(
    column: $table.coverUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genres => $composableBuilder(
    column: $table.genres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get inLibrary => $composableBuilder(
    column: $table.inLibrary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastFetched => $composableBuilder(
    column: $table.lastFetched,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NovelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NovelsTable> {
  $$NovelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coverUrl =>
      $composableBuilder(column: $table.coverUrl, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get genres =>
      $composableBuilder(column: $table.genres, builder: (column) => column);

  GeneratedColumn<bool> get inLibrary =>
      $composableBuilder(column: $table.inLibrary, builder: (column) => column);

  GeneratedColumn<DateTime> get dateAdded =>
      $composableBuilder(column: $table.dateAdded, builder: (column) => column);

  GeneratedColumn<DateTime> get lastFetched => $composableBuilder(
    column: $table.lastFetched,
    builder: (column) => column,
  );

  Expression<T> chaptersRefs<T extends Object>(
    Expression<T> Function($$ChaptersTableAnnotationComposer a) f,
  ) {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.novelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableAnnotationComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> novelCategoriesRefs<T extends Object>(
    Expression<T> Function($$NovelCategoriesTableAnnotationComposer a) f,
  ) {
    final $$NovelCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.novelCategories,
      getReferencedColumn: (t) => t.novelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.novelCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> libraryFlagsRefs<T extends Object>(
    Expression<T> Function($$LibraryFlagsTableAnnotationComposer a) f,
  ) {
    final $$LibraryFlagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.libraryFlags,
      getReferencedColumn: (t) => t.novelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LibraryFlagsTableAnnotationComposer(
            $db: $db,
            $table: $db.libraryFlags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> trackerItemsRefs<T extends Object>(
    Expression<T> Function($$TrackerItemsTableAnnotationComposer a) f,
  ) {
    final $$TrackerItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackerItems,
      getReferencedColumn: (t) => t.novelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackerItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.trackerItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NovelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NovelsTable,
          Novel,
          $$NovelsTableFilterComposer,
          $$NovelsTableOrderingComposer,
          $$NovelsTableAnnotationComposer,
          $$NovelsTableCreateCompanionBuilder,
          $$NovelsTableUpdateCompanionBuilder,
          (Novel, $$NovelsTableReferences),
          Novel,
          PrefetchHooks Function({
            bool chaptersRefs,
            bool novelCategoriesRefs,
            bool libraryFlagsRefs,
            bool trackerItemsRefs,
          })
        > {
  $$NovelsTableTableManager(_$AppDatabase db, $NovelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NovelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NovelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NovelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<String?> genres = const Value.absent(),
                Value<bool> inLibrary = const Value.absent(),
                Value<DateTime?> dateAdded = const Value.absent(),
                Value<DateTime?> lastFetched = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NovelsCompanion(
                id: id,
                sourceId: sourceId,
                url: url,
                title: title,
                author: author,
                description: description,
                coverUrl: coverUrl,
                status: status,
                genres: genres,
                inLibrary: inLibrary,
                dateAdded: dateAdded,
                lastFetched: lastFetched,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceId,
                required String url,
                required String title,
                Value<String?> author = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> coverUrl = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<String?> genres = const Value.absent(),
                Value<bool> inLibrary = const Value.absent(),
                Value<DateTime?> dateAdded = const Value.absent(),
                Value<DateTime?> lastFetched = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NovelsCompanion.insert(
                id: id,
                sourceId: sourceId,
                url: url,
                title: title,
                author: author,
                description: description,
                coverUrl: coverUrl,
                status: status,
                genres: genres,
                inLibrary: inLibrary,
                dateAdded: dateAdded,
                lastFetched: lastFetched,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$NovelsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                chaptersRefs = false,
                novelCategoriesRefs = false,
                libraryFlagsRefs = false,
                trackerItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (chaptersRefs) db.chapters,
                    if (novelCategoriesRefs) db.novelCategories,
                    if (libraryFlagsRefs) db.libraryFlags,
                    if (trackerItemsRefs) db.trackerItems,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (chaptersRefs)
                        await $_getPrefetchedData<Novel, $NovelsTable, Chapter>(
                          currentTable: table,
                          referencedTable: $$NovelsTableReferences
                              ._chaptersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$NovelsTableReferences(
                                db,
                                table,
                                p0,
                              ).chaptersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.novelId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (novelCategoriesRefs)
                        await $_getPrefetchedData<
                          Novel,
                          $NovelsTable,
                          NovelCategory
                        >(
                          currentTable: table,
                          referencedTable: $$NovelsTableReferences
                              ._novelCategoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$NovelsTableReferences(
                                db,
                                table,
                                p0,
                              ).novelCategoriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.novelId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (libraryFlagsRefs)
                        await $_getPrefetchedData<
                          Novel,
                          $NovelsTable,
                          LibraryFlag
                        >(
                          currentTable: table,
                          referencedTable: $$NovelsTableReferences
                              ._libraryFlagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$NovelsTableReferences(
                                db,
                                table,
                                p0,
                              ).libraryFlagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.novelId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (trackerItemsRefs)
                        await $_getPrefetchedData<
                          Novel,
                          $NovelsTable,
                          TrackerItem
                        >(
                          currentTable: table,
                          referencedTable: $$NovelsTableReferences
                              ._trackerItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$NovelsTableReferences(
                                db,
                                table,
                                p0,
                              ).trackerItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.novelId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$NovelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NovelsTable,
      Novel,
      $$NovelsTableFilterComposer,
      $$NovelsTableOrderingComposer,
      $$NovelsTableAnnotationComposer,
      $$NovelsTableCreateCompanionBuilder,
      $$NovelsTableUpdateCompanionBuilder,
      (Novel, $$NovelsTableReferences),
      Novel,
      PrefetchHooks Function({
        bool chaptersRefs,
        bool novelCategoriesRefs,
        bool libraryFlagsRefs,
        bool trackerItemsRefs,
      })
    >;
typedef $$ChaptersTableCreateCompanionBuilder =
    ChaptersCompanion Function({
      required String id,
      required String novelId,
      required String url,
      required String name,
      Value<double?> number,
      Value<DateTime?> dateUpload,
      Value<bool> read,
      Value<int> lastPageRead,
      Value<bool> downloaded,
      Value<int> rowid,
    });
typedef $$ChaptersTableUpdateCompanionBuilder =
    ChaptersCompanion Function({
      Value<String> id,
      Value<String> novelId,
      Value<String> url,
      Value<String> name,
      Value<double?> number,
      Value<DateTime?> dateUpload,
      Value<bool> read,
      Value<int> lastPageRead,
      Value<bool> downloaded,
      Value<int> rowid,
    });

final class $$ChaptersTableReferences
    extends BaseReferences<_$AppDatabase, $ChaptersTable, Chapter> {
  $$ChaptersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NovelsTable _novelIdTable(_$AppDatabase db) => db.novels.createAlias(
    $_aliasNameGenerator(db.chapters.novelId, db.novels.id),
  );

  $$NovelsTableProcessedTableManager get novelId {
    final $_column = $_itemColumn<String>('novel_id')!;

    final manager = $$NovelsTableTableManager(
      $_db,
      $_db.novels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_novelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$HistoryTable, List<HistoryData>>
  _historyRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.history,
    aliasName: $_aliasNameGenerator(db.chapters.id, db.history.chapterId),
  );

  $$HistoryTableProcessedTableManager get historyRefs {
    final manager = $$HistoryTableTableManager(
      $_db,
      $_db.history,
    ).filter((f) => f.chapterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_historyRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChaptersTableFilterComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateUpload => $composableBuilder(
    column: $table.dateUpload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get read => $composableBuilder(
    column: $table.read,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastPageRead => $composableBuilder(
    column: $table.lastPageRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get downloaded => $composableBuilder(
    column: $table.downloaded,
    builder: (column) => ColumnFilters(column),
  );

  $$NovelsTableFilterComposer get novelId {
    final $$NovelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.novelId,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableFilterComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> historyRefs(
    Expression<bool> Function($$HistoryTableFilterComposer f) f,
  ) {
    final $$HistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.history,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HistoryTableFilterComposer(
            $db: $db,
            $table: $db.history,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChaptersTableOrderingComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateUpload => $composableBuilder(
    column: $table.dateUpload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get read => $composableBuilder(
    column: $table.read,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastPageRead => $composableBuilder(
    column: $table.lastPageRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get downloaded => $composableBuilder(
    column: $table.downloaded,
    builder: (column) => ColumnOrderings(column),
  );

  $$NovelsTableOrderingComposer get novelId {
    final $$NovelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.novelId,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableOrderingComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChaptersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChaptersTable> {
  $$ChaptersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<DateTime> get dateUpload => $composableBuilder(
    column: $table.dateUpload,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get read =>
      $composableBuilder(column: $table.read, builder: (column) => column);

  GeneratedColumn<int> get lastPageRead => $composableBuilder(
    column: $table.lastPageRead,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get downloaded => $composableBuilder(
    column: $table.downloaded,
    builder: (column) => column,
  );

  $$NovelsTableAnnotationComposer get novelId {
    final $$NovelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.novelId,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableAnnotationComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> historyRefs<T extends Object>(
    Expression<T> Function($$HistoryTableAnnotationComposer a) f,
  ) {
    final $$HistoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.history,
      getReferencedColumn: (t) => t.chapterId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HistoryTableAnnotationComposer(
            $db: $db,
            $table: $db.history,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChaptersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChaptersTable,
          Chapter,
          $$ChaptersTableFilterComposer,
          $$ChaptersTableOrderingComposer,
          $$ChaptersTableAnnotationComposer,
          $$ChaptersTableCreateCompanionBuilder,
          $$ChaptersTableUpdateCompanionBuilder,
          (Chapter, $$ChaptersTableReferences),
          Chapter,
          PrefetchHooks Function({bool novelId, bool historyRefs})
        > {
  $$ChaptersTableTableManager(_$AppDatabase db, $ChaptersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> novelId = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double?> number = const Value.absent(),
                Value<DateTime?> dateUpload = const Value.absent(),
                Value<bool> read = const Value.absent(),
                Value<int> lastPageRead = const Value.absent(),
                Value<bool> downloaded = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChaptersCompanion(
                id: id,
                novelId: novelId,
                url: url,
                name: name,
                number: number,
                dateUpload: dateUpload,
                read: read,
                lastPageRead: lastPageRead,
                downloaded: downloaded,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String novelId,
                required String url,
                required String name,
                Value<double?> number = const Value.absent(),
                Value<DateTime?> dateUpload = const Value.absent(),
                Value<bool> read = const Value.absent(),
                Value<int> lastPageRead = const Value.absent(),
                Value<bool> downloaded = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChaptersCompanion.insert(
                id: id,
                novelId: novelId,
                url: url,
                name: name,
                number: number,
                dateUpload: dateUpload,
                read: read,
                lastPageRead: lastPageRead,
                downloaded: downloaded,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChaptersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({novelId = false, historyRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (historyRefs) db.history],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (novelId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.novelId,
                                referencedTable: $$ChaptersTableReferences
                                    ._novelIdTable(db),
                                referencedColumn: $$ChaptersTableReferences
                                    ._novelIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (historyRefs)
                    await $_getPrefetchedData<
                      Chapter,
                      $ChaptersTable,
                      HistoryData
                    >(
                      currentTable: table,
                      referencedTable: $$ChaptersTableReferences
                          ._historyRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ChaptersTableReferences(db, table, p0).historyRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.chapterId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ChaptersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChaptersTable,
      Chapter,
      $$ChaptersTableFilterComposer,
      $$ChaptersTableOrderingComposer,
      $$ChaptersTableAnnotationComposer,
      $$ChaptersTableCreateCompanionBuilder,
      $$ChaptersTableUpdateCompanionBuilder,
      (Chapter, $$ChaptersTableReferences),
      Chapter,
      PrefetchHooks Function({bool novelId, bool historyRefs})
    >;
typedef $$HistoryTableCreateCompanionBuilder =
    HistoryCompanion Function({
      Value<int> id,
      required String chapterId,
      required DateTime readAt,
      required int timeSpentMs,
      required int wordsRead,
    });
typedef $$HistoryTableUpdateCompanionBuilder =
    HistoryCompanion Function({
      Value<int> id,
      Value<String> chapterId,
      Value<DateTime> readAt,
      Value<int> timeSpentMs,
      Value<int> wordsRead,
    });

final class $$HistoryTableReferences
    extends BaseReferences<_$AppDatabase, $HistoryTable, HistoryData> {
  $$HistoryTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChaptersTable _chapterIdTable(_$AppDatabase db) => db.chapters
      .createAlias($_aliasNameGenerator(db.history.chapterId, db.chapters.id));

  $$ChaptersTableProcessedTableManager get chapterId {
    final $_column = $_itemColumn<String>('chapter_id')!;

    final manager = $$ChaptersTableTableManager(
      $_db,
      $_db.chapters,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HistoryTableFilterComposer
    extends Composer<_$AppDatabase, $HistoryTable> {
  $$HistoryTableFilterComposer({
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

  ColumnFilters<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeSpentMs => $composableBuilder(
    column: $table.timeSpentMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordsRead => $composableBuilder(
    column: $table.wordsRead,
    builder: (column) => ColumnFilters(column),
  );

  $$ChaptersTableFilterComposer get chapterId {
    final $$ChaptersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableFilterComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $HistoryTable> {
  $$HistoryTableOrderingComposer({
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

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeSpentMs => $composableBuilder(
    column: $table.timeSpentMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordsRead => $composableBuilder(
    column: $table.wordsRead,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChaptersTableOrderingComposer get chapterId {
    final $$ChaptersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableOrderingComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $HistoryTable> {
  $$HistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);

  GeneratedColumn<int> get timeSpentMs => $composableBuilder(
    column: $table.timeSpentMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wordsRead =>
      $composableBuilder(column: $table.wordsRead, builder: (column) => column);

  $$ChaptersTableAnnotationComposer get chapterId {
    final $$ChaptersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chapterId,
      referencedTable: $db.chapters,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableAnnotationComposer(
            $db: $db,
            $table: $db.chapters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HistoryTable,
          HistoryData,
          $$HistoryTableFilterComposer,
          $$HistoryTableOrderingComposer,
          $$HistoryTableAnnotationComposer,
          $$HistoryTableCreateCompanionBuilder,
          $$HistoryTableUpdateCompanionBuilder,
          (HistoryData, $$HistoryTableReferences),
          HistoryData,
          PrefetchHooks Function({bool chapterId})
        > {
  $$HistoryTableTableManager(_$AppDatabase db, $HistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> chapterId = const Value.absent(),
                Value<DateTime> readAt = const Value.absent(),
                Value<int> timeSpentMs = const Value.absent(),
                Value<int> wordsRead = const Value.absent(),
              }) => HistoryCompanion(
                id: id,
                chapterId: chapterId,
                readAt: readAt,
                timeSpentMs: timeSpentMs,
                wordsRead: wordsRead,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String chapterId,
                required DateTime readAt,
                required int timeSpentMs,
                required int wordsRead,
              }) => HistoryCompanion.insert(
                id: id,
                chapterId: chapterId,
                readAt: readAt,
                timeSpentMs: timeSpentMs,
                wordsRead: wordsRead,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HistoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chapterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (chapterId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chapterId,
                                referencedTable: $$HistoryTableReferences
                                    ._chapterIdTable(db),
                                referencedColumn: $$HistoryTableReferences
                                    ._chapterIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HistoryTable,
      HistoryData,
      $$HistoryTableFilterComposer,
      $$HistoryTableOrderingComposer,
      $$HistoryTableAnnotationComposer,
      $$HistoryTableCreateCompanionBuilder,
      $$HistoryTableUpdateCompanionBuilder,
      (HistoryData, $$HistoryTableReferences),
      HistoryData,
      PrefetchHooks Function({bool chapterId})
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required String name,
      required int orderIndex,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> orderIndex,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$NovelCategoriesTable, List<NovelCategory>>
  _novelCategoriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.novelCategories,
    aliasName: $_aliasNameGenerator(
      db.categories.id,
      db.novelCategories.categoryId,
    ),
  );

  $$NovelCategoriesTableProcessedTableManager get novelCategoriesRefs {
    final manager = $$NovelCategoriesTableTableManager(
      $_db,
      $_db.novelCategories,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _novelCategoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> novelCategoriesRefs(
    Expression<bool> Function($$NovelCategoriesTableFilterComposer f) f,
  ) {
    final $$NovelCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.novelCategories,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.novelCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  Expression<T> novelCategoriesRefs<T extends Object>(
    Expression<T> Function($$NovelCategoriesTableAnnotationComposer a) f,
  ) {
    final $$NovelCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.novelCategories,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.novelCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({bool novelCategoriesRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                orderIndex: orderIndex,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int orderIndex,
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                orderIndex: orderIndex,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({novelCategoriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (novelCategoriesRefs) db.novelCategories,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (novelCategoriesRefs)
                    await $_getPrefetchedData<
                      Category,
                      $CategoriesTable,
                      NovelCategory
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._novelCategoriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).novelCategoriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({bool novelCategoriesRefs})
    >;
typedef $$NovelCategoriesTableCreateCompanionBuilder =
    NovelCategoriesCompanion Function({
      required String novelId,
      required int categoryId,
      Value<int> rowid,
    });
typedef $$NovelCategoriesTableUpdateCompanionBuilder =
    NovelCategoriesCompanion Function({
      Value<String> novelId,
      Value<int> categoryId,
      Value<int> rowid,
    });

final class $$NovelCategoriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $NovelCategoriesTable, NovelCategory> {
  $$NovelCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $NovelsTable _novelIdTable(_$AppDatabase db) => db.novels.createAlias(
    $_aliasNameGenerator(db.novelCategories.novelId, db.novels.id),
  );

  $$NovelsTableProcessedTableManager get novelId {
    final $_column = $_itemColumn<String>('novel_id')!;

    final manager = $$NovelsTableTableManager(
      $_db,
      $_db.novels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_novelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
        $_aliasNameGenerator(db.novelCategories.categoryId, db.categories.id),
      );

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$NovelCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $NovelCategoriesTable> {
  $$NovelCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$NovelsTableFilterComposer get novelId {
    final $$NovelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.novelId,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableFilterComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NovelCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $NovelCategoriesTable> {
  $$NovelCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$NovelsTableOrderingComposer get novelId {
    final $$NovelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.novelId,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableOrderingComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NovelCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NovelCategoriesTable> {
  $$NovelCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$NovelsTableAnnotationComposer get novelId {
    final $$NovelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.novelId,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableAnnotationComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NovelCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NovelCategoriesTable,
          NovelCategory,
          $$NovelCategoriesTableFilterComposer,
          $$NovelCategoriesTableOrderingComposer,
          $$NovelCategoriesTableAnnotationComposer,
          $$NovelCategoriesTableCreateCompanionBuilder,
          $$NovelCategoriesTableUpdateCompanionBuilder,
          (NovelCategory, $$NovelCategoriesTableReferences),
          NovelCategory,
          PrefetchHooks Function({bool novelId, bool categoryId})
        > {
  $$NovelCategoriesTableTableManager(
    _$AppDatabase db,
    $NovelCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NovelCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NovelCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NovelCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> novelId = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NovelCategoriesCompanion(
                novelId: novelId,
                categoryId: categoryId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String novelId,
                required int categoryId,
                Value<int> rowid = const Value.absent(),
              }) => NovelCategoriesCompanion.insert(
                novelId: novelId,
                categoryId: categoryId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$NovelCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({novelId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (novelId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.novelId,
                                referencedTable:
                                    $$NovelCategoriesTableReferences
                                        ._novelIdTable(db),
                                referencedColumn:
                                    $$NovelCategoriesTableReferences
                                        ._novelIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable:
                                    $$NovelCategoriesTableReferences
                                        ._categoryIdTable(db),
                                referencedColumn:
                                    $$NovelCategoriesTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$NovelCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NovelCategoriesTable,
      NovelCategory,
      $$NovelCategoriesTableFilterComposer,
      $$NovelCategoriesTableOrderingComposer,
      $$NovelCategoriesTableAnnotationComposer,
      $$NovelCategoriesTableCreateCompanionBuilder,
      $$NovelCategoriesTableUpdateCompanionBuilder,
      (NovelCategory, $$NovelCategoriesTableReferences),
      NovelCategory,
      PrefetchHooks Function({bool novelId, bool categoryId})
    >;
typedef $$LibraryFlagsTableCreateCompanionBuilder =
    LibraryFlagsCompanion Function({
      required String novelId,
      Value<bool> favorite,
      Value<String?> customCover,
      Value<String?> readingMode,
      Value<String?> displayMode,
      Value<int> rowid,
    });
typedef $$LibraryFlagsTableUpdateCompanionBuilder =
    LibraryFlagsCompanion Function({
      Value<String> novelId,
      Value<bool> favorite,
      Value<String?> customCover,
      Value<String?> readingMode,
      Value<String?> displayMode,
      Value<int> rowid,
    });

final class $$LibraryFlagsTableReferences
    extends BaseReferences<_$AppDatabase, $LibraryFlagsTable, LibraryFlag> {
  $$LibraryFlagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NovelsTable _novelIdTable(_$AppDatabase db) => db.novels.createAlias(
    $_aliasNameGenerator(db.libraryFlags.novelId, db.novels.id),
  );

  $$NovelsTableProcessedTableManager get novelId {
    final $_column = $_itemColumn<String>('novel_id')!;

    final manager = $$NovelsTableTableManager(
      $_db,
      $_db.novels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_novelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LibraryFlagsTableFilterComposer
    extends Composer<_$AppDatabase, $LibraryFlagsTable> {
  $$LibraryFlagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customCover => $composableBuilder(
    column: $table.customCover,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get readingMode => $composableBuilder(
    column: $table.readingMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayMode => $composableBuilder(
    column: $table.displayMode,
    builder: (column) => ColumnFilters(column),
  );

  $$NovelsTableFilterComposer get novelId {
    final $$NovelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.novelId,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableFilterComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LibraryFlagsTableOrderingComposer
    extends Composer<_$AppDatabase, $LibraryFlagsTable> {
  $$LibraryFlagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customCover => $composableBuilder(
    column: $table.customCover,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get readingMode => $composableBuilder(
    column: $table.readingMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayMode => $composableBuilder(
    column: $table.displayMode,
    builder: (column) => ColumnOrderings(column),
  );

  $$NovelsTableOrderingComposer get novelId {
    final $$NovelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.novelId,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableOrderingComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LibraryFlagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LibraryFlagsTable> {
  $$LibraryFlagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<String> get customCover => $composableBuilder(
    column: $table.customCover,
    builder: (column) => column,
  );

  GeneratedColumn<String> get readingMode => $composableBuilder(
    column: $table.readingMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayMode => $composableBuilder(
    column: $table.displayMode,
    builder: (column) => column,
  );

  $$NovelsTableAnnotationComposer get novelId {
    final $$NovelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.novelId,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableAnnotationComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LibraryFlagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LibraryFlagsTable,
          LibraryFlag,
          $$LibraryFlagsTableFilterComposer,
          $$LibraryFlagsTableOrderingComposer,
          $$LibraryFlagsTableAnnotationComposer,
          $$LibraryFlagsTableCreateCompanionBuilder,
          $$LibraryFlagsTableUpdateCompanionBuilder,
          (LibraryFlag, $$LibraryFlagsTableReferences),
          LibraryFlag,
          PrefetchHooks Function({bool novelId})
        > {
  $$LibraryFlagsTableTableManager(_$AppDatabase db, $LibraryFlagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibraryFlagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibraryFlagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibraryFlagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> novelId = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                Value<String?> customCover = const Value.absent(),
                Value<String?> readingMode = const Value.absent(),
                Value<String?> displayMode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LibraryFlagsCompanion(
                novelId: novelId,
                favorite: favorite,
                customCover: customCover,
                readingMode: readingMode,
                displayMode: displayMode,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String novelId,
                Value<bool> favorite = const Value.absent(),
                Value<String?> customCover = const Value.absent(),
                Value<String?> readingMode = const Value.absent(),
                Value<String?> displayMode = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LibraryFlagsCompanion.insert(
                novelId: novelId,
                favorite: favorite,
                customCover: customCover,
                readingMode: readingMode,
                displayMode: displayMode,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LibraryFlagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({novelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (novelId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.novelId,
                                referencedTable: $$LibraryFlagsTableReferences
                                    ._novelIdTable(db),
                                referencedColumn: $$LibraryFlagsTableReferences
                                    ._novelIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LibraryFlagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LibraryFlagsTable,
      LibraryFlag,
      $$LibraryFlagsTableFilterComposer,
      $$LibraryFlagsTableOrderingComposer,
      $$LibraryFlagsTableAnnotationComposer,
      $$LibraryFlagsTableCreateCompanionBuilder,
      $$LibraryFlagsTableUpdateCompanionBuilder,
      (LibraryFlag, $$LibraryFlagsTableReferences),
      LibraryFlag,
      PrefetchHooks Function({bool novelId})
    >;
typedef $$TrackerItemsTableCreateCompanionBuilder =
    TrackerItemsCompanion Function({
      Value<int> id,
      required String novelId,
      required String trackerId,
      required String remoteId,
      Value<String?> status,
      Value<double?> score,
      Value<int?> lastChapter,
    });
typedef $$TrackerItemsTableUpdateCompanionBuilder =
    TrackerItemsCompanion Function({
      Value<int> id,
      Value<String> novelId,
      Value<String> trackerId,
      Value<String> remoteId,
      Value<String?> status,
      Value<double?> score,
      Value<int?> lastChapter,
    });

final class $$TrackerItemsTableReferences
    extends BaseReferences<_$AppDatabase, $TrackerItemsTable, TrackerItem> {
  $$TrackerItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NovelsTable _novelIdTable(_$AppDatabase db) => db.novels.createAlias(
    $_aliasNameGenerator(db.trackerItems.novelId, db.novels.id),
  );

  $$NovelsTableProcessedTableManager get novelId {
    final $_column = $_itemColumn<String>('novel_id')!;

    final manager = $$NovelsTableTableManager(
      $_db,
      $_db.novels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_novelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TrackerItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TrackerItemsTable> {
  $$TrackerItemsTableFilterComposer({
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

  ColumnFilters<String> get trackerId => $composableBuilder(
    column: $table.trackerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastChapter => $composableBuilder(
    column: $table.lastChapter,
    builder: (column) => ColumnFilters(column),
  );

  $$NovelsTableFilterComposer get novelId {
    final $$NovelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.novelId,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableFilterComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackerItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackerItemsTable> {
  $$TrackerItemsTableOrderingComposer({
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

  ColumnOrderings<String> get trackerId => $composableBuilder(
    column: $table.trackerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastChapter => $composableBuilder(
    column: $table.lastChapter,
    builder: (column) => ColumnOrderings(column),
  );

  $$NovelsTableOrderingComposer get novelId {
    final $$NovelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.novelId,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableOrderingComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackerItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackerItemsTable> {
  $$TrackerItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get trackerId =>
      $composableBuilder(column: $table.trackerId, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get lastChapter => $composableBuilder(
    column: $table.lastChapter,
    builder: (column) => column,
  );

  $$NovelsTableAnnotationComposer get novelId {
    final $$NovelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.novelId,
      referencedTable: $db.novels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NovelsTableAnnotationComposer(
            $db: $db,
            $table: $db.novels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackerItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackerItemsTable,
          TrackerItem,
          $$TrackerItemsTableFilterComposer,
          $$TrackerItemsTableOrderingComposer,
          $$TrackerItemsTableAnnotationComposer,
          $$TrackerItemsTableCreateCompanionBuilder,
          $$TrackerItemsTableUpdateCompanionBuilder,
          (TrackerItem, $$TrackerItemsTableReferences),
          TrackerItem,
          PrefetchHooks Function({bool novelId})
        > {
  $$TrackerItemsTableTableManager(_$AppDatabase db, $TrackerItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackerItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackerItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackerItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> novelId = const Value.absent(),
                Value<String> trackerId = const Value.absent(),
                Value<String> remoteId = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<double?> score = const Value.absent(),
                Value<int?> lastChapter = const Value.absent(),
              }) => TrackerItemsCompanion(
                id: id,
                novelId: novelId,
                trackerId: trackerId,
                remoteId: remoteId,
                status: status,
                score: score,
                lastChapter: lastChapter,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String novelId,
                required String trackerId,
                required String remoteId,
                Value<String?> status = const Value.absent(),
                Value<double?> score = const Value.absent(),
                Value<int?> lastChapter = const Value.absent(),
              }) => TrackerItemsCompanion.insert(
                id: id,
                novelId: novelId,
                trackerId: trackerId,
                remoteId: remoteId,
                status: status,
                score: score,
                lastChapter: lastChapter,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TrackerItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({novelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (novelId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.novelId,
                                referencedTable: $$TrackerItemsTableReferences
                                    ._novelIdTable(db),
                                referencedColumn: $$TrackerItemsTableReferences
                                    ._novelIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TrackerItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackerItemsTable,
      TrackerItem,
      $$TrackerItemsTableFilterComposer,
      $$TrackerItemsTableOrderingComposer,
      $$TrackerItemsTableAnnotationComposer,
      $$TrackerItemsTableCreateCompanionBuilder,
      $$TrackerItemsTableUpdateCompanionBuilder,
      (TrackerItem, $$TrackerItemsTableReferences),
      TrackerItem,
      PrefetchHooks Function({bool novelId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NovelsTableTableManager get novels =>
      $$NovelsTableTableManager(_db, _db.novels);
  $$ChaptersTableTableManager get chapters =>
      $$ChaptersTableTableManager(_db, _db.chapters);
  $$HistoryTableTableManager get history =>
      $$HistoryTableTableManager(_db, _db.history);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$NovelCategoriesTableTableManager get novelCategories =>
      $$NovelCategoriesTableTableManager(_db, _db.novelCategories);
  $$LibraryFlagsTableTableManager get libraryFlags =>
      $$LibraryFlagsTableTableManager(_db, _db.libraryFlags);
  $$TrackerItemsTableTableManager get trackerItems =>
      $$TrackerItemsTableTableManager(_db, _db.trackerItems);
}
