import '../../common/models/chapter.dart';

/// Contractual orchestration layer for managing chapter-level relational data,
/// encompassing state persistence for consumption status and localized content caching.
abstract class ChapterRepository {
  Future<List<Chapter>> getChaptersForNovel(String novelId);
  Future<Chapter?> getChapter(String chapterId);
  Future<void> insertChapters(List<Chapter> chapters);

  /// Orchestrates the insertion of new chapter entities and patches existing
  /// metadata without impacting localized consumption or archival status.
  Future<void> upsertChapters(List<Chapter> chapters);
  Future<void> updateChapter(Chapter chapter);
  Future<void> markChapterRead(String chapterId);
  Future<void> markChapterUnread(String chapterId);
  Future<void> markAllRead(String novelId);
  Future<void> markAllLibraryUpdatesRead();

  /// Orchestrates the persistent archival of consumption progress for a specific entity.
  Future<void> updateReadingPosition(
    String chapterId,
    int lastPageRead,
    double scrollOffset,
  );
  Future<ChapterContent?> getChapterContent(String chapterId);
  Future<void> deleteChapterContent(String chapterId);
  Future<void> cacheChapterContent(ChapterContent content);
  Future<int> getUnreadCount(String novelId);
  Future<void> deleteAllChaptersForNovel(String novelId);
  Stream<List<Chapter>> watchChaptersForNovel(String novelId);
}
