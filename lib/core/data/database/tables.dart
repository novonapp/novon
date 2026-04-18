import 'package:drift/drift.dart';

/// Relational schema for representing novel metadata, including source 
/// identification, bibliographic attributes, and library status.
class Novels extends Table {
  TextColumn get id => text()();
  TextColumn get sourceId => text()();
  TextColumn get url => text()();
  TextColumn get title => text()();
  TextColumn get author => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get coverUrl => text().nullable()();
  TextColumn get status => text().nullable()();
  TextColumn get genres => text().nullable()();
  BoolColumn get inLibrary => boolean().withDefault(const Constant(false))();
  DateTimeColumn get dateAdded => dateTime().nullable()();
  DateTimeColumn get lastFetched => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Relational schema for representing individual chapter segments, maintaining 
/// referential integrity with the novel index and tracking consumption progress.
class Chapters extends Table {
  TextColumn get id => text()();
  TextColumn get novelId => text().references(Novels, #id)();
  TextColumn get url => text()();
  TextColumn get name => text()();
  RealColumn get number => real().nullable()();
  DateTimeColumn get dateUpload => dateTime().nullable()();
  BoolColumn get read => boolean().withDefault(const Constant(false))();
  IntColumn get lastPageRead => integer().withDefault(const Constant(0))();
  BoolColumn get downloaded => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Relational schema for orchestrating the temporal archival of consumption 
/// events, facilitating analytical retrieval of reading patterns.
class History extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get chapterId => text().references(Chapters, #id)();
  DateTimeColumn get readAt => dateTime()();
  IntColumn get timeSpentMs => integer()();
  IntColumn get wordsRead => integer()();
}

/// Relational schema for managing user-defined organizational segments.
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get orderIndex => integer()();
}

/// Relational schema for orchestrating the many-to-many relationship between 
/// library entities and organizational categories.
class NovelCategories extends Table {
  TextColumn get novelId => text().references(Novels, #id)();
  IntColumn get categoryId => integer().references(Categories, #id)();

  @override
  Set<Column> get primaryKey => {novelId, categoryId};
}

/// Relational schema for managing localized overrides and behavioral 
/// configurations for individual library entities.
class LibraryFlags extends Table {
  TextColumn get novelId => text().references(Novels, #id)();
  BoolColumn get favorite => boolean().withDefault(const Constant(false))();
  TextColumn get customCover => text().nullable()();
  TextColumn get readingMode => text().nullable()();
  TextColumn get displayMode => text().nullable()();

  @override
  Set<Column> get primaryKey => {novelId};
}

/// Relational schema for orchestrating synchronization with external 
/// archival and tracking services.
class TrackerItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get novelId => text().references(Novels, #id)();
  TextColumn get trackerId => text()();
  TextColumn get remoteId => text()();
  TextColumn get status => text().nullable()();
  RealColumn get score => real().nullable()();
  IntColumn get lastChapter => integer().nullable()();
}
