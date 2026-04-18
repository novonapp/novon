import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:novon/core/common/enums/sort_mode.dart';
import 'package:novon/core/common/models/novel.dart' as m;
import 'package:novon/core/common/models/novel_filter.dart';
import 'package:novon/core/data/repositories/novel_repository.dart';
import '../database/database.dart';

/// Concrete orchestration layer for managing novel-level relational data,
/// implementing specialized logic for complex filtering and selective
/// attribute patching.
class NovelRepositoryImpl implements NovelRepository {
  final AppDatabase db;
  NovelRepositoryImpl(this.db);

  /// Orchestrates the transformation of a raw database row into a structured
  /// novel model, encompassing enum resolution and genre serialization handling.
  m.Novel _toModel(dynamic row) {
    final statusStr = (row.status as String?) ?? '';
    final status = switch (statusStr.toLowerCase()) {
      'ongoing' => m.NovelStatus.ongoing,
      'completed' => m.NovelStatus.completed,
      'hiatus' => m.NovelStatus.hiatus,
      'dropped' => m.NovelStatus.dropped,
      _ => m.NovelStatus.unknown,
    };

    List<String> genres = const [];
    final rawGenres = row.genres as String?;
    if (rawGenres != null && rawGenres.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawGenres);
        if (decoded is List) {
          genres = decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {
        genres = rawGenres
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
      }
    }

    return m.Novel(
      id: row.id as String,
      sourceId: row.sourceId as String,
      url: row.url as String,
      title: row.title as String,
      author: (row.author as String?) ?? '',
      description: (row.description as String?) ?? '',
      coverUrl: (row.coverUrl as String?) ?? '',
      status: status,
      genres: genres,
      inLibrary: row.inLibrary as bool,
      dateAdded: row.dateAdded as DateTime?,
      lastFetched: row.lastFetched as DateTime?,
      // totalChapters/readChapters/downloadedChapters/lastRead are computed elsewhere for now
    );
  }

  @override
  Future<List<m.Novel>> getLibraryNovels() async {
    final rows = await (db.select(
      db.novels,
    )..where((t) => t.inLibrary.equals(true))).get();
    return rows.map(_toModel).toList();
  }

  /// Orchestrates the retrieval of library novels based on a specialized
  /// filtering context, including text matching and chronological sorting.
  @override
  Future<List<m.Novel>> getLibraryNovelsFiltered(NovelFilter filter) async {
    final q = db.select(db.novels)..where((t) => t.inLibrary.equals(true));

    if (filter.query.trim().isNotEmpty) {
      final like = '%${filter.query.trim()}%';
      q.where((t) => t.title.like(like) | t.author.like(like));
    }

    // Basic sorts (we don't have lastRead in novels table yet)
    switch (filter.sortMode) {
      case SortMode.alphabetical:
        q.orderBy([(t) => OrderingTerm(expression: t.title)]);
      case SortMode.dateAdded:
        q.orderBy([
          (t) => OrderingTerm(expression: t.dateAdded, mode: OrderingMode.desc),
        ]);
      case SortMode.lastUpdated:
        q.orderBy([
          (t) =>
              OrderingTerm(expression: t.lastFetched, mode: OrderingMode.desc),
        ]);
      default:
        q.orderBy([
          (t) => OrderingTerm(expression: t.dateAdded, mode: OrderingMode.desc),
        ]);
    }

    final rows = await q.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<m.Novel?> getNovel(String sourceId, String novelId) async {
    final row =
        await (db.select(
              db.novels,
            )..where((t) => t.id.equals(novelId) & t.sourceId.equals(sourceId)))
            .getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  @override
  Future<void> insertNovel(m.Novel novel) async {
    // Fetch raw database row to preserve DB-exclusive fields like dateAdded
    final row = await (db.select(
      db.novels,
    )..where((t) => t.id.equals(novel.id))).getSingleOrNull();

    final inLibrary = row != null
        ? (row.inLibrary || novel.inLibrary)
        : novel.inLibrary;
    final dateAdded = row?.dateAdded ?? (inLibrary ? DateTime.now() : null);

    await db
        .into(db.novels)
        .insert(
          NovelsCompanion.insert(
            id: novel.id,
            sourceId: novel.sourceId,
            url: novel.url,
            title: novel.title,
            author: Value(
              novel.author.isEmpty ? (row?.author ?? '') : novel.author,
            ),
            description: Value(
              novel.description.isEmpty
                  ? (row?.description ?? '')
                  : novel.description,
            ),
            coverUrl: Value(
              novel.coverUrl.isEmpty ? (row?.coverUrl ?? '') : novel.coverUrl,
            ),
            status: Value(
              novel.status == m.NovelStatus.unknown
                  ? (row?.status ?? 'unknown')
                  : novel.status.name,
            ),
            genres: Value(
              novel.genres.isEmpty
                  ? (row?.genres != null ? row!.genres! : '[]')
                  : jsonEncode(novel.genres),
            ),
            inLibrary: Value(inLibrary),
            dateAdded: Value(dateAdded),
            lastFetched: Value(novel.lastFetched),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<void> updateNovel(m.Novel novel) async {
    await (db.update(db.novels)..where((t) => t.id.equals(novel.id))).write(
      NovelsCompanion(
        title: Value(novel.title),
        author: Value(novel.author.isEmpty ? null : novel.author),
        description: Value(
          novel.description.isEmpty ? null : novel.description,
        ),
        coverUrl: Value(novel.coverUrl.isEmpty ? null : novel.coverUrl),
        status: Value(novel.status.name),
        genres: Value(jsonEncode(novel.genres)),
        inLibrary: Value(novel.inLibrary),
        lastFetched: Value(novel.lastFetched),
      ),
    );
  }

  @override
  Future<void> addToLibrary(String novelId) async {
    await (db.update(db.novels)..where((t) => t.id.equals(novelId))).write(
      NovelsCompanion(
        inLibrary: const Value(true),
        dateAdded: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> removeFromLibrary(String novelId) async {
    await (db.update(db.novels)..where((t) => t.id.equals(novelId))).write(
      const NovelsCompanion(inLibrary: Value(false)),
    );
  }

  @override
  Future<bool> isInLibrary(String novelId) async {
    final row = await (db.select(
      db.novels,
    )..where((t) => t.id.equals(novelId))).getSingleOrNull();
    return row?.inLibrary ?? false;
  }

  @override
  Future<m.Novel?> getNovelById(String novelId) async {
    final row = await (db.select(
      db.novels,
    )..where((t) => t.id.equals(novelId))).getSingleOrNull();
    return row == null ? null : _toModel(row);
  }

  /// Orchestrates the selective patching of novel metadata, facilitating
  /// efficient synchronization with remote source update signals.
  @override
  Future<void> patchNovelMetadata(
    String novelId, {
    String? title,
    String? author,
    String? description,
    String? coverUrl,
    String? status,
    List<String>? genres,
    DateTime? lastFetched,
  }) async {
    await (db.update(db.novels)..where((t) => t.id.equals(novelId))).write(
      NovelsCompanion(
        title: title != null ? Value(title) : const Value.absent(),
        author: author != null
            ? Value(author.isEmpty ? null : author)
            : const Value.absent(),
        description: description != null
            ? Value(description.isEmpty ? null : description)
            : const Value.absent(),
        coverUrl: coverUrl != null
            ? Value(coverUrl.isEmpty ? null : coverUrl)
            : const Value.absent(),
        status: status != null ? Value(status) : const Value.absent(),
        genres: genres != null
            ? Value(jsonEncode(genres))
            : const Value.absent(),
        lastFetched: lastFetched != null
            ? Value(lastFetched)
            : const Value.absent(),
      ),
    );
  }

  @override
  Stream<List<m.Novel>> watchLibraryNovels() {
    final q = db.select(db.novels)..where((t) => t.inLibrary.equals(true));
    return q.watch().map((rows) => rows.map(_toModel).toList());
  }

  @override
  Stream<m.Novel?> watchNovel(String novelId) {
    return (db.select(db.novels)..where((t) => t.id.equals(novelId)))
        .watchSingleOrNull()
        .map((row) => row == null ? null : _toModel(row));
  }
}
