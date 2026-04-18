import 'package:drift/drift.dart';
import 'package:novon/core/common/models/reading_position.dart';
import 'package:novon/core/data/repositories/history_repository.dart';
import '../database/database.dart';

/// Concrete orchestration layer for managing session history, encompassing
/// specialized resolution logic for URI variants and the maintenance of
/// referential integrity.
class HistoryRepositoryImpl implements HistoryRepository {
  final AppDatabase db;
  HistoryRepositoryImpl(this.db);

  /// Resolves the collection of possible URL variants for a chapter,
  /// facilitating resilient history matching across different encoding states.
  List<String> _chapterUrlVariants(String chapterUrl) {
    final variants = <String>{};
    final trimmed = chapterUrl.trim();
    if (trimmed.isNotEmpty) variants.add(trimmed);
    final noSlash = trimmed.replaceAll(RegExp(r'/+$'), '');
    if (noSlash.isNotEmpty) variants.add(noSlash);
    try {
      final decoded = Uri.decodeComponent(trimmed);
      if (decoded.isNotEmpty) variants.add(decoded);
      final decodedNoSlash = decoded.replaceAll(RegExp(r'/+$'), '');
      if (decodedNoSlash.isNotEmpty) variants.add(decodedNoSlash);
      final encoded = Uri.encodeFull(
        decodedNoSlash.isNotEmpty ? decodedNoSlash : decoded,
      );
      if (encoded.isNotEmpty) variants.add(encoded);
      final encodedNoSlash = encoded.replaceAll(RegExp(r'/+$'), '');
      if (encodedNoSlash.isNotEmpty) variants.add(encodedNoSlash);
    } catch (_) {
      // keep best-effort variants only
    }
    return variants.toList();
  }

  /// Appraises the localized relational store to resolve a canonical chapter ID
  /// from a variety of potential URL or ID variants.
  Future<String?> _resolveChapterId(String chapterId) async {
    final variants = _chapterUrlVariants(chapterId);
    for (final candidate in variants) {
      final byId = await (db.select(
        db.chapters,
      )..where((t) => t.id.equals(candidate))).getSingleOrNull();
      if (byId != null) return byId.id;
      final byUrl = await (db.select(
        db.chapters,
      )..where((t) => t.url.equals(candidate))).getSingleOrNull();
      if (byUrl != null) return byUrl.id;
    }
    return null;
  }

  ReadingPosition _toModel(TypedResult row) {
    final h = row.readTable(db.history);
    final c = row.readTable(db.chapters);

    return ReadingPosition(
      chapterId: h.chapterId,
      novelId: c.novelId,
      itemIndex: c.lastPageRead,
      scrollOffset: 0.0,
      lastRead: h.readAt,
      timeSpentMs: h.timeSpentMs,
    );
  }

  Selectable<TypedResult> _baseQuery() {
    final q = db.select(db.history).join([
      innerJoin(db.chapters, db.chapters.id.equalsExp(db.history.chapterId)),
    ]);
    q.orderBy([OrderingTerm.desc(db.history.readAt)]);
    return q;
  }

  @override
  Future<List<ReadingPosition>> getHistory({
    int limit = 50,
    int offset = 0,
  }) async {
    final q =
        db.select(db.history).join([
            innerJoin(
              db.chapters,
              db.chapters.id.equalsExp(db.history.chapterId),
            ),
          ])
          ..orderBy([OrderingTerm.desc(db.history.readAt)])
          ..limit(limit, offset: offset);

    final rows = await q.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<ReadingPosition?> getLastRead(String novelId) async {
    final q =
        db.select(db.history).join([
            innerJoin(
              db.chapters,
              db.chapters.id.equalsExp(db.history.chapterId),
            ),
          ])
          ..where(db.chapters.novelId.equals(novelId))
          ..orderBy([OrderingTerm.desc(db.history.readAt)])
          ..limit(1);

    final row = await q.getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  /// Orchestrates the insertion of a historical session record, ensuring
  /// referential integrity by apprising and initializing parent entities
  /// if they are absent from localized storage.
  @override
  Future<void> upsertHistory(ReadingPosition position) async {
    final resolvedChapterId = await _resolveChapterId(position.chapterId);
    final chapterId = resolvedChapterId ?? position.chapterId;

    // Ensure parent novel exists for FK safety.
    final novel = await (db.select(
      db.novels,
    )..where((t) => t.id.equals(position.novelId))).getSingleOrNull();
    if (novel == null) {
      await db
          .into(db.novels)
          .insertOnConflictUpdate(
            NovelsCompanion.insert(
              id: position.novelId,
              sourceId: '',
              url: position.novelId,
              title: 'Unknown novel',
              inLibrary: const Value(false),
            ),
          );
    }

    // Ensure chapter exists for FK safety.
    final chapter = await (db.select(
      db.chapters,
    )..where((t) => t.id.equals(chapterId))).getSingleOrNull();
    if (chapter == null) {
      await db
          .into(db.chapters)
          .insertOnConflictUpdate(
            ChaptersCompanion.insert(
              id: chapterId,
              novelId: position.novelId,
              url: position.chapterId,
              name: 'Unknown chapter',
              number: const Value(null),
              dateUpload: const Value(null),
              read: const Value(false),
              lastPageRead: const Value(0),
              downloaded: const Value(false),
            ),
          );
    }

    await db
        .into(db.history)
        .insert(
          HistoryCompanion.insert(
            chapterId: chapterId,
            readAt: position.lastRead ?? DateTime.now(),
            timeSpentMs: position.timeSpentMs,
            wordsRead: 0,
          ),
        );
  }

  @override
  Future<void> deleteHistory(String novelId) async {
    // delete all history events for chapters belonging to novel
    final chapterIds = db.selectOnly(db.chapters)
      ..addColumns([db.chapters.id])
      ..where(db.chapters.novelId.equals(novelId));
    final ids = await chapterIds.get().then(
      (rows) => rows.map((r) => r.read(db.chapters.id)!).toList(),
    );
    if (ids.isEmpty) return;
    await (db.delete(db.history)..where((t) => t.chapterId.isIn(ids))).go();
  }

  @override
  Future<void> clearAllHistory() async {
    await db.delete(db.history).go();
  }

  @override
  Stream<List<ReadingPosition>> watchHistory() {
    return _baseQuery().watch().map((rows) => rows.map(_toModel).toList());
  }
}
