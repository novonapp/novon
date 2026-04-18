import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database/database.dart';
import 'storage_path_service.dart';
import 'app_initializer.dart';
import '../../app.dart';

/// Orchestrates the high-level bootstrapping and state reinitialization sequences 
/// for the Novon application.
/// 
/// This component centralizes lifecycle management logic, ensuring a stable
/// transition between distinct operational states such as cold starts and
/// environment-specific reinitializations.
class AppBootstrapper {
  AppBootstrapper._();
  static final AppBootstrapper instance = AppBootstrapper._();

  AppDatabase? _currentDatabase;
  bool _isReinitializing = false;

  /// Entry point for the application lifecycle flow, orchestrating the 
  /// transition to the primary operational state.
  Future<void> bootstrap({bool reinitialize = false}) async {
    if (reinitialize) {
      if (_isReinitializing) return;
      _isReinitializing = true;
    }

    try {
      // Orchestrates the lifecycle of core singleton services including 
      // localized persistence and migration layers.
      await AppInitializer.initCoreServices(reinitialize: reinitialize);

      // Facilitates the appraisal and potential decommissioning of the current 
      // database instance during environmental refreshes.
      if (reinitialize) {
        await _currentDatabase?.close();
        _currentDatabase = null;
      }

      final sps = StoragePathService.instance;
      final dbPath = sps.isConfigured ? sps.storagePath! : await sps.getFallbackPath();

      final database = AppDatabase(dbPath);
      _currentDatabase = database;

      // Orchestrates the launch of the root application widget within a 
      // uniquely keyed provider scope to facilitate reactive state refreshes.
      runApp(
        ProviderScope(
          key: ValueKey('novon-scope-${DateTime.now().microsecondsSinceEpoch}'),
          overrides: AppInitializer.getProviderOverrides(database),
          child: const NovonApp(),
        ),
      );
    } finally {
      if (reinitialize) {
        _isReinitializing = false;
      }
    }
  }

  /// Decommissions active resources and closes persistent connections.
  Future<void> dispose() async {
    await _currentDatabase?.close();
  }
}
