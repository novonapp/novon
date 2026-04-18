import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/repositories/novel_repository.dart';
import '../data/repositories/chapter_repository.dart';
import '../data/repositories/history_repository.dart';
import '../common/models/novel.dart';
import '../common/models/chapter.dart';
import '../data/repositories/novel_repository_impl.dart';
import '../data/repositories/chapter_repository_impl.dart';
import '../data/repositories/history_repository_impl.dart';
import '../../features/statistics/providers/statistics_provider.dart'
    show databaseProvider;
import 'package:drift/drift.dart';
import 'dart:convert';
import 'package:novon/core/common/constants/hive_constants.dart';

final novelRepositoryProvider = Provider<NovelRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return NovelRepositoryImpl(db);
});

final chapterRepositoryProvider = Provider<ChapterRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ChapterRepositoryImpl(db);
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return HistoryRepositoryImpl(db);
});

final updatesSeenRevisionProvider = StateProvider<int>((ref) => 0);

Set<String> _readSeenUpdates() {
  final box = Hive.box(HiveBox.app);
  final raw = box.get(HiveKeys.updatesSeenChapterIds);
  if (raw is List) {
    return raw.map((e) => e.toString()).toSet();
  }
  if (raw is Set) {
    return raw.map((e) => e.toString()).toSet();
  }
  return <String>{};
}

Set<String> _readPendingUpdates() {
  final box = Hive.box(HiveBox.app);
  final raw = box.get(HiveKeys.notifChapterUpdates);
  if (raw is List) {
    return raw.map((e) => e.toString()).toSet();
  }
  if (raw is Set) {
    return raw.map((e) => e.toString()).toSet();
  }
  return <String>{};
}

final libraryNovelsStreamProvider = StreamProvider((ref) {
  return ref.watch(novelRepositoryProvider).watchLibraryNovels();
});

final libraryNovelsAggregatedProvider = StreamProvider<List<Novel>>((ref) {
  final db = ref.watch(databaseProvider);

  final totalExp = db.chapters.id.count();
  final readExp = const CustomExpression<int>(
    'SUM(CASE WHEN chapters.read = 1 THEN 1 ELSE 0 END)',
  );
  final downExp = const CustomExpression<int>(
    'SUM(CASE WHEN chapters.downloaded = 1 THEN 1 ELSE 0 END)',
  );
  final lastReadExp = db.history.readAt.max();

  final q =
      db.select(db.novels).join([
          leftOuterJoin(
            db.chapters,
            db.chapters.novelId.equalsExp(db.novels.id),
          ),
          leftOuterJoin(
            db.history,
            db.history.chapterId.equalsExp(db.chapters.id),
          ),
        ])
        ..where(db.novels.inLibrary.equals(true))
        ..addColumns([totalExp, readExp, downExp, lastReadExp])
        ..groupBy([db.novels.id]);

  return q.watch().map((rows) {
    return rows.map((row) {
      final n = row.readTable(db.novels);
      final total = row.read(totalExp) ?? 0;
      final read = row.read(readExp) ?? 0;
      final down = row.read(downExp) ?? 0;
      final lastRead = row.read(lastReadExp);

      List<String> genres = const [];
      final genreStr = n.genres;
      if (genreStr != null && genreStr.isNotEmpty) {
        try {
          final decoded = jsonDecode(genreStr);
          if (decoded is List) {
            genres = decoded.map((e) => e.toString()).toList();
          }
        } catch (_) {}
      }

      return Novel(
        id: n.id,
        sourceId: n.sourceId,
        url: n.url,
        title: n.title,
        author: n.author ?? '',
        description: n.description ?? '',
        coverUrl: n.coverUrl ?? '',
        status: NovelStatus.values.firstWhere(
          (e) => e.name == (n.status ?? 'unknown'),
          orElse: () => NovelStatus.unknown,
        ),
        genres: genres,
        inLibrary: n.inLibrary,
        dateAdded: n.dateAdded ?? n.lastFetched ?? DateTime.now(),
        lastFetched: n.lastFetched,
        totalChapters: total,
        readChapters: read,
        downloadedChapters: down,
        lastRead: lastRead,
      );
    }).toList();
  });
});

final isNovelInLibraryProvider = FutureProvider.family<bool, String>((
  ref,
  novelId,
) {
  return ref.watch(novelRepositoryProvider).isInLibrary(novelId);
});

final isNovelInLibraryStreamProvider = StreamProvider.family<bool, String>((
  ref,
  novelId,
) {
  return ref
      .watch(novelRepositoryProvider)
      .watchLibraryNovels()
      .map((items) => items.any((n) => n.id == novelId || n.url == novelId));
});

final historyStreamProvider = StreamProvider((ref) {
  return ref.watch(historyRepositoryProvider).watchHistory();
});

class HistoryItemVm {
  final String sourceId;
  final String novelUrl;
  final String novelTitle;
  final String novelCoverUrl;
  final String chapterId;
  final String chapterName;
  final double chapterNumber;
  final DateTime readAt;

  const HistoryItemVm({
    required this.sourceId,
    required this.novelUrl,
    required this.novelTitle,
    required this.novelCoverUrl,
    required this.chapterId,
    required this.chapterName,
    required this.chapterNumber,
    required this.readAt,
  });
}

final historyItemsProvider = StreamProvider<List<HistoryItemVm>>((ref) {
  final db = ref.watch(databaseProvider);
  final q = db.select(db.history).join([
    innerJoin(db.chapters, db.chapters.id.equalsExp(db.history.chapterId)),
    innerJoin(db.novels, db.novels.id.equalsExp(db.chapters.novelId)),
  ])..orderBy([OrderingTerm.desc(db.history.readAt)]);

  return q.watch().map((rows) {
    return rows.map((r) {
      final h = r.readTable(db.history);
      final c = r.readTable(db.chapters);
      final n = r.readTable(db.novels);
      return HistoryItemVm(
        sourceId: n.sourceId,
        novelUrl: n.url,
        novelTitle: n.title,
        novelCoverUrl: n.coverUrl ?? '',
        chapterId: h.chapterId,
        chapterName: c.name,
        chapterNumber: c.number ?? -1,
        readAt: h.readAt,
      );
    }).toList();
  });
});

class UpdateItemVm {
  final String sourceId;
  final String novelUrl;
  final String novelTitle;
  final String novelCoverUrl;
  final String chapterId;
  final String chapterName;
  final DateTime? dateUpload;

  const UpdateItemVm({
    required this.sourceId,
    required this.novelUrl,
    required this.novelTitle,
    required this.novelCoverUrl,
    required this.chapterId,
    required this.chapterName,
    this.dateUpload,
  });
}

final updatesItemsProvider = StreamProvider<List<UpdateItemVm>>((ref) {
  ref.watch(updatesSeenRevisionProvider);
  final db = ref.watch(databaseProvider);
  final pending = _readPendingUpdates();
  if (pending.isEmpty) {
    return Stream.value(const <UpdateItemVm>[]);
  }
  final q =
      db.select(db.chapters).join([
          innerJoin(db.novels, db.novels.id.equalsExp(db.chapters.novelId)),
        ])
        ..where(
          db.novels.inLibrary.equals(true) &
              db.chapters.id.isIn(pending.toList(growable: false)) &
              db.chapters.read.equals(false),
        )
        ..orderBy([OrderingTerm.desc(db.chapters.dateUpload)]);

  return q.watch().map((rows) {
    final seen = _readSeenUpdates();
    return rows
        .map((r) {
          final c = r.readTable(db.chapters);
          final n = r.readTable(db.novels);
          return UpdateItemVm(
            sourceId: n.sourceId,
            novelUrl: n.url,
            novelTitle: n.title,
            novelCoverUrl: n.coverUrl ?? '',
            chapterId: c.id,
            chapterName: c.name,
            dateUpload: c.dateUpload,
          );
        })
        .where((item) => !seen.contains(item.chapterId))
        .toList();
  });
});

final unreadUpdatesCountProvider = Provider<int>((ref) {
  return ref.watch(updatesItemsProvider).valueOrNull?.length ?? 0;
});

final chapterReadStateProvider = StreamProvider.family<Set<String>, String>((
  ref,
  novelId,
) {
  final repo = ref.watch(chapterRepositoryProvider);
  return repo.watchChaptersForNovel(novelId).map((chapters) {
    return chapters.where((c) => c.read).map((c) => c.url).toSet();
  });
});

final chapterDownloadedStateProvider =
    StreamProvider.family<Set<String>, String>((ref, novelId) {
      final repo = ref.watch(chapterRepositoryProvider);
      return repo.watchChaptersForNovel(novelId).map((chapters) {
        return chapters.where((c) => c.downloaded).map((c) => c.url).toSet();
      });
    });

final cachedNovelChaptersProvider =
    StreamProvider.family<List<Chapter>, String>((ref, novelId) {
      return ref
          .watch(chapterRepositoryProvider)
          .watchChaptersForNovel(novelId);
    });

/// Watches a single novel from the local DB.
/// We use this for instant offline-first rendering on the novel detail screen.
final cachedNovelDetailProvider = StreamProvider.family<Novel?, String>((
  ref,
  novelId,
) {
  return ref.watch(novelRepositoryProvider).watchNovel(novelId);
});

class DownloadItemVm {
  final String sourceId;
  final String novelUrl;
  final String novelTitle;
  final String novelCoverUrl;
  final String chapterId;
  final String chapterName;
  final bool downloaded;
  final bool read;

  const DownloadItemVm({
    required this.sourceId,
    required this.novelUrl,
    required this.novelTitle,
    required this.novelCoverUrl,
    required this.chapterId,
    required this.chapterName,
    required this.downloaded,
    required this.read,
  });
}

final downloadItemsProvider = StreamProvider<List<DownloadItemVm>>((ref) {
  final db = ref.watch(databaseProvider);
  final q = db.select(db.chapters).join([
    innerJoin(db.novels, db.novels.id.equalsExp(db.chapters.novelId)),
  ])..where(db.novels.inLibrary.equals(true));

  return q.watch().map((rows) {
    return rows.map((r) {
      final c = r.readTable(db.chapters);
      final n = r.readTable(db.novels);
      return DownloadItemVm(
        sourceId: n.sourceId,
        novelUrl: n.url,
        novelTitle: n.title,
        novelCoverUrl: n.coverUrl ?? '',
        chapterId: c.id,
        chapterName: c.name,
        downloaded: c.downloaded,
        read: c.read,
      );
    }).toList();
  });
});
