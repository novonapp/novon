import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Novels,
  Chapters,
  History,
  Categories,
  NovelCategories,
  LibraryFlags,
  TrackerItems,
])
/// Primary relational persistence orchestration layer, managing the application's 
/// structured data schema, lifecycle migrations, and localized storage anchors.
class AppDatabase extends _$AppDatabase {
  AppDatabase(String storagePath) : super(_openConnection(storagePath));

  @override
  int get schemaVersion => 3;

  /// Orchestrates the schema evolution and structural maintenance of the 
  /// persistent relational data store.
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await customStatement('''
            CREATE TABLE IF NOT EXISTS chapter_contents (
              chapter_id TEXT PRIMARY KEY,
              html TEXT NOT NULL,
              title TEXT,
              word_count INTEGER NOT NULL DEFAULT 0,
              fetched_at TEXT
            );
          ''');
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await customStatement('''
              CREATE TABLE IF NOT EXISTS chapter_contents (
                chapter_id TEXT PRIMARY KEY,
                html TEXT NOT NULL,
                word_count INTEGER NOT NULL DEFAULT 0,
                fetched_at TEXT
              );
            ''');
          }
          if (from < 3) {
            await customStatement(
              'ALTER TABLE chapter_contents ADD COLUMN title TEXT;',
            );
          }
        },
      );
}

/// Resolves the localized data anchor and initializes the underlying 
/// query executor for the persistent relational store.
QueryExecutor _openConnection(String storagePath) {
  final dbDir = Directory(p.join(storagePath, 'database'));
  if (!dbDir.existsSync()) {
    dbDir.createSync(recursive: true);
  }
  final dbFile = File(p.join(dbDir.path, 'novon.sqlite'));
  return NativeDatabase.createInBackground(dbFile);
}
