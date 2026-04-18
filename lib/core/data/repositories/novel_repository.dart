import '../../common/models/novel.dart';
import '../../common/models/novel_filter.dart';

/// Contractual orchestration layer for managing novel-level relational data,
/// encompassing library state management and metadata synchronization.
abstract class NovelRepository {
  Future<List<Novel>> getLibraryNovels();
  Future<List<Novel>> getLibraryNovelsFiltered(NovelFilter filter);
  Future<Novel?> getNovel(String sourceId, String novelId);
  Future<Novel?> getNovelById(String novelId);
  Future<void> insertNovel(Novel novel);
  Future<void> updateNovel(Novel novel);

  /// Orchestrates the selective patching of novel metadata, facilitating
  /// synchronization with remote source attributes.
  Future<void> patchNovelMetadata(
    String novelId, {
    String? title,
    String? author,
    String? description,
    String? coverUrl,
    String? status,
    List<String>? genres,
    DateTime? lastFetched,
  });

  /// Orchestrates the state transition for incorporating an external novel
  /// entity into the localized library persistence.
  Future<void> addToLibrary(String novelId);

  /// Orchestrates the decommissioning of a library entity, facilitating
  /// localized removal while maintaining referential history.
  Future<void> removeFromLibrary(String novelId);
  Future<bool> isInLibrary(String novelId);
  Stream<List<Novel>> watchLibraryNovels();
  Stream<Novel?> watchNovel(String novelId);
}
