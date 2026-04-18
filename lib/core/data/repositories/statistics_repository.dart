
/// Structured representation of analyzed reading telemetry for a specific 
/// temporal interval.
class DailyReadingStat {
  final DateTime date;
  final int timeSpentMs;

  DailyReadingStat({required this.date, required this.timeSpentMs});
}

/// Structured representation of aggregated reading telemetry associated 
/// with a specific novel entity.
class NovelReadingStat {
  final String novelId;
  final String title;
  final int chaptersRead;
  final int totalTimeSpentMs;

  NovelReadingStat({
    required this.novelId,
    required this.title,
    required this.chaptersRead,
    required this.totalTimeSpentMs,
  });
}

class ChapterReadingStat {
  final String chapterId;
  final String chapterName;
  final String novelTitle;
  final int readCount;

  ChapterReadingStat({
    required this.chapterId,
    required this.chapterName,
    required this.novelTitle,
    required this.readCount,
  });
}

/// Comprehensive orchestration of application consumption telemetry, 
/// facilitating high-level appraisal of reading patterns and library progress.
class StatOverview {
  final int totalNovels;
  final int completedNovels;
  final int readingNovels;
  final int planToReadNovels;
  final int chaptersRead;
  final int totalChapters;
  final int totalWordsRead;
  final int totalTimeSpentMs;
  final int daysRead;
  final int longestStreak;
  final int currentStreak;
  final int avgWordsPerChapter;
  final int avgTimePerChapterMs;

  StatOverview({
    required this.totalNovels,
    required this.completedNovels,
    required this.readingNovels,
    required this.planToReadNovels,
    required this.chaptersRead,
    required this.totalChapters,
    required this.totalWordsRead,
    required this.totalTimeSpentMs,
    required this.daysRead,
    required this.longestStreak,
    required this.currentStreak,
    required this.avgWordsPerChapter,
    required this.avgTimePerChapterMs,
  });
}

/// Contractual orchestration layer for the aggregation and analytical 
/// retrieval of application consumption telemetry.
abstract class StatisticsRepository {
  Future<StatOverview> getOverview();
  Future<List<DailyReadingStat>> getDailyReadingStats(int days);
  Future<List<NovelReadingStat>> getTopNovels({int limit = 20});
  Future<List<ChapterReadingStat>> getTopChapters({int limit = 30});
}
