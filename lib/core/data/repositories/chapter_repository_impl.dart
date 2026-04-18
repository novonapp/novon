import 'package:drift/drift.dart';
import 'package:novon/core/common/models/chapter.dart' as m;
import 'package:novon/core/data/repositories/chapter_repository.dart';
import '../database/database.dart';

/// Concrete orchestration layer for managing chapter-level relational data,
/// encompassing specialized logic for ID variant resolution and
/// non-destructive state synchronization.
class ChapterRepositoryImpl implements ChapterRepository {
  final AppDatabase db;
  ChapterRepositoryImpl(this.db);

  /// Resolves the collection of possible ID and URL variants for a given
  /// chapter, facilitating resilient entity matching across different
  /// encoding states.
  List<String> _chapterIdVariants(String chapterId) {
    final variants = <String>{};
    final raw = chapterId.trim();
    if (raw.isNotEmpty) variants.add(raw);
    final noSlash = raw.replaceAll(RegExp(r'/+$'), '');
    if (noSlash.isNotEmpty) variants.add(noSlash);
    String decoded = raw;
    try {
      decoded = Uri.decodeComponent(raw);
    } catch (_) {}
    if (decoded.isNotEmpty) variants.add(decoded);
    final decodedNoSlash = decoded.replaceAll(RegExp(r'/+$'), '');
    if (decodedNoSlash.isNotEmpty) variants.add(decodedNoSlash);
    final encoded = Uri.encodeFull(
      decodedNoSlash.isNotEmpty ? decodedNoSlash : decoded,
    );
    if (encoded.isNotEmpty) variants.add(encoded);
    final encodedNoSlash = encoded.replaceAll(RegExp(r'/+$'), '');
    if (encodedNoSlash.isNotEmpty) variants.add(encodedNoSlash);
    return variants.toList(growable: false);
  }

  m.Chapter _toModel(dynamic row) {
    return m.Chapter(
      id: row.id as String,
      novelId: row.novelId as String,
      url: row.url as String,
      name: row.name as String,
      number: (row.number as double?) ?? -1,
      dateUpload: row.dateUpload as DateTime?,
      read: row.read as bool,
      lastPageRead: row.lastPageRead as int,
      downloaded: row.downloaded as bool,
    );
  }

  /// Orchestrates the retrieval of all chapter segments associated with a
  /// specific novel entity.
  @override
  Future<List<m.Chapter>> getChaptersForNovel(String novelId) async {
    final rows = await (db.select(
      db.chapters,
    )..where((t) => t.novelId.equals(novelId))).get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<m.Chapter?> getChapter(String chapterId) async {
    final row = await (db.select(
      db.chapters,
    )..where((t) => t.id.equals(chapterId))).getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  @override
  Future<void> insertChapters(List<m.Chapter> chapters) async {
    await db.batch((b) {
      b.insertAll(
        db.chapters,
        chapters
            .map(
              (c) => ChaptersCompanion.insert(
                id: c.id,
                novelId: c.novelId,
                url: c.url,
                name: c.name,
                number: Value(c.number < 0 ? null : c.number),
                dateUpload: Value(c.dateUpload),
                read: Value(c.read),
                lastPageRead: Value(c.lastPageRead),
                downloaded: Value(c.downloaded),
              ),
            )
            .toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  @override
  Future<void> updateChapter(m.Chapter chapter) async {
    await (db.update(db.chapters)..where((t) => t.id.equals(chapter.id))).write(
      ChaptersCompanion(
        name: Value(chapter.name),
        number: Value(chapter.number < 0 ? null : chapter.number),
        dateUpload: Value(chapter.dateUpload),
        read: Value(chapter.read),
        lastPageRead: Value(chapter.lastPageRead),
        downloaded: Value(chapter.downloaded),
      ),
    );
  }

  @override
  Future<void> markChapterRead(String chapterId) async {
    final variants = _chapterIdVariants(chapterId);
    await (db.update(db.chapters)
          ..where((t) => t.id.isIn(variants) | t.url.isIn(variants)))
        .write(const ChaptersCompanion(read: Value(true)));
  }

  @override
  Future<void> markChapterUnread(String chapterId) async {
    final variants = _chapterIdVariants(chapterId);
    await (db.update(db.chapters)
          ..where((t) => t.id.isIn(variants) | t.url.isIn(variants)))
        .write(const ChaptersCompanion(read: Value(false)));
  }

  @override
  Future<void> markAllRead(String novelId) async {
    await (db.update(db.chapters)..where((t) => t.novelId.equals(novelId)))
        .write(const ChaptersCompanion(read: Value(true)));
  }

  @override
  Future<void> markAllLibraryUpdatesRead() async {
    await db.customStatement('''
      UPDATE chapters
      SET read = 1
      WHERE read = 0
        AND novel_id IN (
          SELECT id FROM novels WHERE in_library = 1
        )
    ''');
  }

  @override
  Future<void> updateReadingPosition(
    String chapterId,
    int lastPageRead,
    double scrollOffset,
  ) async {
    final progress = (scrollOffset * 100).round().clamp(0, 100);
    final variants = _chapterIdVariants(chapterId);
    await (db.update(db.chapters)
          ..where((t) => t.id.isIn(variants) | t.url.isIn(variants)))
        .write(ChaptersCompanion(lastPageRead: Value(progress)));
  }

  @override
  Future<m.ChapterContent?> getChapterContent(String chapterId) async {
    final variants = _chapterIdVariants(chapterId);
    // Use raw select to query the chapter_contents table safely across all variants
    final rows = await db.customSelect(
      'SELECT chapter_id, html, title, word_count, fetched_at FROM chapter_contents WHERE chapter_id IN (${List.filled(variants.length, '?').join(',')}) LIMIT 1',
      variables: variants.map((v) => Variable.withString(v)).toList(),
    ).get();

    if (rows.isEmpty) return null;
    final row = rows.first;
    final fetchedRaw = row.read<String?>('fetched_at');
    return m.ChapterContent(
      chapterId: row.read<String>('chapter_id'),
      html: row.read<String>('html'),
      title: row.read<String?>('title'),
      wordCount: row.read<int>('word_count'),
      fetchedAt: fetchedRaw == null ? null : DateTime.tryParse(fetchedRaw),
    );
  }

  @override
  Future<void> cacheChapterContent(m.ChapterContent content) async {
    // We normalize the ID to the "best" variant (usually the one provided)
    // but the IN lookup in getChapterContent will find it regardless.
    await db.customStatement(
      '''
      INSERT INTO chapter_contents(chapter_id, html, title, word_count, fetched_at)
      VALUES(?, ?, ?, ?, ?)
      ON CONFLICT(chapter_id) DO UPDATE SET
        html = excluded.html,
        title = excluded.title,
        word_count = excluded.word_count,
        fetched_at = excluded.fetched_at
      ''',
      [
        content.chapterId,
        content.html,
        content.title,
        content.wordCount,
        content.fetchedAt?.toIso8601String(),
      ],
    );
  }

  @override
  Future<void> deleteChapterContent(String chapterId) async {
    await db.customStatement(
      'DELETE FROM chapter_contents WHERE chapter_id = ?',
      [chapterId],
    );
  }

  @override
  Future<int> getUnreadCount(String novelId) async {
    final row = await (db.select(
      db.chapters,
    )..where((t) => t.novelId.equals(novelId) & t.read.equals(false))).get();
    return row.length;
  }

  /// Orchestrates the appraisal and synchronization of a remote chapter index
  /// with localized storage, ensuring the preservation of user-specific state.
  @override
  Future<void> upsertChapters(List<m.Chapter> chapters) async {
    if (chapters.isEmpty) return;

    // Load all existing chapters for the novel in one query.
    final novelId = chapters.first.novelId;
    final existing = await (db.select(
      db.chapters,
    )..where((t) => t.novelId.equals(novelId))).get();
    final existingById = {for (final c in existing) c.id: c};

    final newRows = <ChaptersCompanion>[];
    final toUpdate =
        <(String id, String name, double? number, DateTime? dateUpload)>[];

    for (final c in chapters) {
      final prev = existingById[c.id];
      if (prev == null) {
        // Brand new chapter — insert fresh.
        newRows.add(
          ChaptersCompanion.insert(
            id: c.id,
            novelId: c.novelId,
            url: c.url,
            name: c.name,
            number: Value(c.number < 0 ? null : c.number),
            dateUpload: Value(c.dateUpload),
            read: const Value(false),
            lastPageRead: const Value(0),
            downloaded: const Value(false),
          ),
        );
      } else {
        // Existing — only update name/number/dateUpload if they differ.
        final nameChanged = prev.name != c.name;
        final numChanged =
            (prev.number ?? -1) != (c.number < 0 ? null : c.number);
        if (nameChanged || numChanged) {
          toUpdate.add((
            c.id,
            c.name,
            c.number < 0 ? null : c.number,
            c.dateUpload,
          ));
        }
      }
    }

    if (newRows.isNotEmpty) {
      await db.batch((b) => b.insertAll(db.chapters, newRows));
    }

    for (final (id, name, number, dateUpload) in toUpdate) {
      await (db.update(db.chapters)..where((t) => t.id.equals(id))).write(
        ChaptersCompanion(
          name: Value(name),
          number: Value(number),
          dateUpload: Value(dateUpload),
        ),
      );
    }
  }

  @override
  Future<void> deleteAllChaptersForNovel(String novelId) async {
    await (db.delete(
      db.chapters,
    )..where((t) => t.novelId.equals(novelId))).go();
    // Also wipe cached chapter content for this novel's chapters.
    await db.customStatement(
      'DELETE FROM chapter_contents WHERE chapter_id IN (SELECT id FROM chapters WHERE novel_id = ?)',
      [novelId],
    );
    // Since chapters are deleted, re-run the content cleanup separately:
    await db.customStatement(
      '''DELETE FROM chapter_contents WHERE chapter_id NOT IN (SELECT id FROM chapters)''',
    );
  }

  @override
  Stream<List<m.Chapter>> watchChaptersForNovel(String novelId) {
    final q = db.select(db.chapters)..where((t) => t.novelId.equals(novelId));
    return q.watch().map((rows) => rows.map(_toModel).toList());
  }
}
