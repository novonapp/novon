import '../../common/models/reading_position.dart';

/// Contractual orchestration layer for the temporal archival of reading events
/// and the persistent tracking of consumption history.
abstract class HistoryRepository {
  /// Orchestrates the retrieval of chronologically ordered reading session data
  /// with support for paginated access.
  Future<List<ReadingPosition>> getHistory({int limit = 50, int offset = 0});
  Future<ReadingPosition?> getLastRead(String novelId);

  /// Orchestrates the creation or update of a historical reading record,
  /// ensuring persistent tracking of the user's navigational state.
  Future<void> upsertHistory(ReadingPosition position);
  Future<void> deleteHistory(String novelId);
  Future<void> clearAllHistory();
  Stream<List<ReadingPosition>> watchHistory();
}
