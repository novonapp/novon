/// A centralized registry for defining and identifying background orchestration 
/// tasks and their associated execution identifiers.
class WorkerConstants {
  WorkerConstants._();

  // Task Names
  static const String taskAutoBackup = 'auto_backup';
  static const String taskUpdateLibrary = 'update_library';
  static const String taskCheckExtensions = 'check_extensions';
  static const String taskPruneLogs = 'prune_exception_logs';
  static const String taskPruneRemovedNovels = 'prune_removed_novels';

  // Task IDs
  static const String idAutoBackup = 'autoBackupTask';
  static const String idUpdateLibrary = 'updateLibraryTask';
  static const String idCheckExtensions = 'checkExtensionsTask';
  static const String idPruneLogs = 'pruneLogsTask';
  static const String idPruneRemovedNovels = 'pruneRemovedNovelsTask';
}
