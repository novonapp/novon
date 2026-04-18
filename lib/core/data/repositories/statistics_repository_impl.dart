import 'package:drift/drift.dart';

import '../database/database.dart';
import './statistics_repository.dart';

/// Concrete orchestration layer for the aggregation and analytical retrieval 
/// of application consumption telemetry, utilizing direct SQL execution 
/// for optimized data synthesis.
class StatisticsRepositoryImpl implements StatisticsRepository {
  final AppDatabase db;

  StatisticsRepositoryImpl(this.db);

  /// Orchestrates the synthesis of a comprehensive high-level appraisal of 
  /// library progress, consumption metrics, and user engagement streaks.
  @override
  Future<StatOverview> getOverview() async {
    final chaptersReadSql = await db
        .customSelect('SELECT COUNT(id) FROM chapters WHERE read = 1')
        .getSingle();
    final chaptersRead = chaptersReadSql.read<int>('COUNT(id)');

    final totalChaptersSql = await db
        .customSelect('SELECT COUNT(id) FROM chapters')
        .getSingle();
    final totalChapters = totalChaptersSql.read<int>('COUNT(id)');

    final novelsSql = await db
        .customSelect('SELECT COUNT(id) FROM novels WHERE in_library = 1')
        .getSingle();
    final totalNovels = novelsSql.read<int>('COUNT(id)');

    final sumWordsSql = await db
        .customSelect(
          'SELECT SUM(words_read) as sum, SUM(time_spent_ms) as ms FROM history',
        )
        .getSingle();
    final totalWordsRead = sumWordsSql.read<int?>('sum') ?? 0;
    final totalTimeSpentMs = sumWordsSql.read<int?>('ms') ?? 0;

    final completedSql = await db.customSelect('''
      SELECT COUNT(*) AS c
      FROM novels n
      WHERE n.in_library = 1
        AND EXISTS (SELECT 1 FROM chapters c WHERE c.novel_id = n.id)
        AND NOT EXISTS (SELECT 1 FROM chapters c WHERE c.novel_id = n.id AND c.read = 0)
    ''').getSingle();
    final completedNovels = completedSql.read<int>('c');

    final readingSql = await db.customSelect('''
      SELECT COUNT(*) AS c
      FROM novels n
      WHERE n.in_library = 1
        AND EXISTS (SELECT 1 FROM chapters c WHERE c.novel_id = n.id AND c.read = 1)
        AND EXISTS (SELECT 1 FROM chapters c WHERE c.novel_id = n.id AND c.read = 0)
    ''').getSingle();
    final readingNovels = readingSql.read<int>('c');

    final daysReadSql = await db.customSelect(
      'SELECT COUNT(DISTINCT date(read_at)) AS c FROM history',
    ).getSingle();
    final daysRead = daysReadSql.read<int>('c');

    final streakRows = await db.customSelect(
      'SELECT DISTINCT date(read_at) AS day FROM history ORDER BY day ASC',
    ).get();
    final dayList = streakRows
        .map((r) => DateTime.tryParse(r.read<String?>('day') ?? ''))
        .whereType<DateTime>()
        .toList();
    final streaks = _computeStreaks(dayList);

    return StatOverview(
      totalNovels: totalNovels,
      completedNovels: completedNovels,
      readingNovels: readingNovels,
      planToReadNovels: 0,
      chaptersRead: chaptersRead,
      totalChapters: totalChapters,
      totalWordsRead: totalWordsRead,
      totalTimeSpentMs: totalTimeSpentMs,
      daysRead: daysRead,
      longestStreak: streaks.$1,
      currentStreak: streaks.$2,
      avgWordsPerChapter: chaptersRead > 0 ? totalWordsRead ~/ chaptersRead : 0,
      avgTimePerChapterMs: chaptersRead > 0
          ? totalTimeSpentMs ~/ chaptersRead
          : 0,
    );
  }

  @override
  Future<List<DailyReadingStat>> getDailyReadingStats(int days) async {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final cutoffDate = DateTime(cutoff.year, cutoff.month, cutoff.day).toIso8601String().split('T').first;

    final result = await db
        .customSelect(
          '''
      SELECT date(read_at) as day, SUM(time_spent_ms) as ts
      FROM history
      WHERE date(read_at) >= date(?)
      GROUP BY day
      ORDER BY day ASC
      ''',
          variables: [Variable.withString(cutoffDate)],
        )
        .get();

    final List<DailyReadingStat> stats = [];
    for (final row in result) {
      final dayStr = row.read<String?>('day');
      if (dayStr == null || dayStr.isEmpty) continue;
      final ts = row.read<int?>('ts') ?? 0;
      stats.add(
        DailyReadingStat(date: DateTime.parse(dayStr), timeSpentMs: ts),
      );
    }

    return stats;
  }

  @override
  Future<List<NovelReadingStat>> getTopNovels({int limit = 20}) async {
    final rows = await db.customSelect(
      '''
      SELECT n.id AS novel_id, n.title AS title, COUNT(h.id) AS reads, COALESCE(SUM(h.time_spent_ms), 0) AS spent
      FROM history h
      JOIN chapters c ON c.id = h.chapter_id
      JOIN novels n ON n.id = c.novel_id
      GROUP BY n.id, n.title
      ORDER BY reads DESC, spent DESC
      LIMIT ?
      ''',
      variables: [Variable.withInt(limit)],
    ).get();
    return rows
        .map(
          (r) => NovelReadingStat(
            novelId: r.read<String>('novel_id'),
            title: r.read<String?>('title') ?? 'Unknown novel',
            chaptersRead: r.read<int>('reads'),
            totalTimeSpentMs: r.read<int>('spent'),
          ),
        )
        .toList();
  }

  @override
  Future<List<ChapterReadingStat>> getTopChapters({int limit = 30}) async {
    final rows = await db.customSelect(
      '''
      SELECT c.id AS chapter_id, c.name AS chapter_name, n.title AS novel_title, COUNT(h.id) AS reads
      FROM history h
      JOIN chapters c ON c.id = h.chapter_id
      JOIN novels n ON n.id = c.novel_id
      GROUP BY c.id, c.name, n.title
      ORDER BY reads DESC
      LIMIT ?
      ''',
      variables: [Variable.withInt(limit)],
    ).get();
    return rows
        .map(
          (r) => ChapterReadingStat(
            chapterId: r.read<String>('chapter_id'),
            chapterName: r.read<String?>('chapter_name') ?? 'Unknown chapter',
            novelTitle: r.read<String?>('novel_title') ?? 'Unknown novel',
            readCount: r.read<int>('reads'),
          ),
        )
        .toList();
  }

  /// Appraises the chronologically ordered session history to determine 
  /// engagement streaks and identify the most significant interval of 
  /// consecutive interaction.
  (int, int) _computeStreaks(List<DateTime> sortedDays) {
    if (sortedDays.isEmpty) return (0, 0);
    int longest = 1;
    int current = 1;
    int run = 1;
    for (var i = 1; i < sortedDays.length; i++) {
      final a = DateTime(sortedDays[i - 1].year, sortedDays[i - 1].month, sortedDays[i - 1].day);
      final b = DateTime(sortedDays[i].year, sortedDays[i].month, sortedDays[i].day);
      if (b.difference(a).inDays == 1) {
        run++;
      } else if (b.difference(a).inDays > 1) {
        run = 1;
      }
      if (run > longest) longest = run;
    }
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final set = sortedDays
        .map((d) => DateTime(d.year, d.month, d.day).toIso8601String().split('T').first)
        .toSet();
    var probe = todayDate;
    current = 0;
    while (set.contains(probe.toIso8601String().split('T').first)) {
      current++;
      probe = probe.subtract(const Duration(days: 1));
    }
    return (longest, current);
  }
}

