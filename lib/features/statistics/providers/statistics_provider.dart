import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/repositories/statistics_repository.dart';
import '../../../core/data/repositories/statistics_repository_impl.dart';
import '../../../core/data/database/database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError(
    'Database provider must be overridden in ProviderScope',
  );
});

final statisticsRepositoryProvider = Provider<StatisticsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return StatisticsRepositoryImpl(db);
});

final statisticsOverviewProvider = FutureProvider<StatOverview>((ref) {
  final repository = ref.watch(statisticsRepositoryProvider);
  return repository.getOverview();
});

final statisticsDailyReadingProvider =
    FutureProvider.family<List<DailyReadingStat>, int>((ref, days) {
      final repository = ref.watch(statisticsRepositoryProvider);
      return repository.getDailyReadingStats(days);
    });

final statisticsTopNovelsProvider = FutureProvider<List<NovelReadingStat>>((
  ref,
) {
  final repository = ref.watch(statisticsRepositoryProvider);
  return repository.getTopNovels(limit: 20);
});

final statisticsTopChaptersProvider = FutureProvider<List<ChapterReadingStat>>((
  ref,
) {
  final repository = ref.watch(statisticsRepositoryProvider);
  return repository.getTopChapters(limit: 30);
});
