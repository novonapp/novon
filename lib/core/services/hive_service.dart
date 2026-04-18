import 'package:hive_flutter/hive_flutter.dart';
import 'package:novon/core/common/constants/hive_constants.dart';
import 'package:novon/core/services/storage_path_service.dart';

/// Centralized orchestration layer for persistent storage initialization and 
/// the management of localized preference containers via Hive.
class HiveService {
  HiveService._();

  /// Orchestrates the initialization of the Hive persistence layer at the 
  /// resolved storage path and ensures the availability of all required containers.
  static Future<void> init({bool reinitialize = false}) async {
    if (reinitialize) {
      await Hive.close();
    }

    final sps = StoragePathService.instance;
    final String hivePath;
    if (sps.isConfigured) {
      hivePath = sps.hiveDir;
    } else {
      hivePath = await sps.getFallbackPath();
    }

    await Hive.initFlutter(hivePath);
    await Hive.openBox(HiveBox.app);
    await Hive.openBox(HiveBox.reader);
    await Hive.openBox(HiveBox.extensions);
    await Hive.openBox(HiveBox.exceptions);
    await Hive.openBox(HiveBox.removedNovels);
  }
}
