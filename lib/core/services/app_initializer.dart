import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:novon/features/statistics/providers/statistics_provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:background_downloader/background_downloader.dart';

import 'background_service.dart';
import '../../features/reader/providers/reader_settings_provider.dart';
import '../data/database/database.dart';
import '../common/constants/hive_constants.dart';
import '../common/constants/app_constants.dart';
import 'storage_path_service.dart';
import 'migration_service.dart';
import 'hive_service.dart';

/// Consolidates orchestration routines for bootstrapping low-level background tasks,
/// asset acquisition monitoring, and persistence layers during the pre-runtime phase.
class AppInitializer {
  /// Orchestrates the registration of persistent background orchestration tasks
  /// for archival, library synchronization, and diagnostic maintenance.
  static void initBackgroundWorkers() {
    try {
      Workmanager().initialize(callbackDispatcher);
      BackgroundService.registerAutoBackup();
      BackgroundService.registerLibraryUpdate();
      BackgroundService.registerPruneLogs();
      BackgroundService.registerPruneRemovedNovels();
    } catch (e) {
      log('WorkManager init failed (expected on hot restart)', error: e);
    }
  }

  /// Configures the notification orchestration layer for monitoring the
  /// status of asynchronous asset acquisition tasks.
  static void initDownloadNotifications() {
    try {
      FileDownloader().configureNotificationForGroup(
        FileDownloader.defaultGroup,
        running: const TaskNotification('Downloading', 'file: {filename}'),
        complete: const TaskNotification(
          'Download finished',
          'file: {filename}',
        ),
        error: const TaskNotification('Error', 'file: {filename}'),
      );
    } catch (e) {
      log('FileDownloader init failed', error: e);
    }
  }

  /// Orchestrates the initialization of core singleton services, including
  /// environmental appraisal, localized persistence, and data migration layers.
  static Future<void> initCoreServices({bool reinitialize = false}) async {
    final sps = StoragePathService.instance;
    await sps.init();

    if (sps.isConfigured) {
      await sps.ensureDirectoriesExist();
      await MigrationService.maybeMigrateFirstRunData(sps);
      await sps.placeNomediaFile(sps.storagePath!);
    }

    await HiveService.init(reinitialize: reinitialize);
  }

  /// Appraises serialized application settings from localized persistence
  /// and constructs the dependency injection overrides for the reactive state graph.
  static List<Override> getProviderOverrides(AppDatabase database) {
    final readerBox = Hive.box(HiveBox.reader);

    final initialReaderFontSize =
        ((readerBox.get(HiveKeys.readerFontSize) as num?)?.toDouble() ??
                AppConstants.defaultReaderFontSize)
            .clamp(14, 24)
            .toDouble();

    final initialReaderLineHeight =
        ((readerBox.get(HiveKeys.readerLineHeight) as num?)?.toDouble() ??
                AppConstants.defaultReaderLineHeight)
            .clamp(1.4, 2.2)
            .toDouble();

    final initialReaderFontFamily = (readerBox.get(
      HiveKeys.readerFontFamily,
      defaultValue: AppConstants.defaultReaderFont,
    )).toString();

    return [
      databaseProvider.overrideWithValue(database),
      readerFontSizeProvider.overrideWith((ref) => initialReaderFontSize),
      readerLineHeightProvider.overrideWith((ref) => initialReaderLineHeight),
      readerFontFamilyProvider.overrideWith((ref) => initialReaderFontFamily),
    ];
  }
}
