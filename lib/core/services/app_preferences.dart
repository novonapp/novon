import 'package:novon/core/common/constants/hive_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Specialized orchestration layer for managing application-level persistent 
/// preferences and lifecycle parameters.
class AppPreferences {
  // Appearance
  // Downloads
  // Browse
  // Network & User-Agent
  // Notifications
  // Security & Privacy
  static const String keyAppLockType = 'app_lock_type'; // 'biometric' or 'pin'
  static const String keyAppLockPin = 'app_lock_pin';   // Hashed or encrypted PIN
  // Advanced
  // Data & Storage
  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(HiveBox.app);
  }

  // Getters/setters could go here but using `_box.get` directly is often easier for UI bindings via riverpod
  Box get box => _box;
}

/// Specialized orchestration layer for managing reader-specific aesthetic 
/// and environmental configurations.
class ReaderPreferences {
  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(HiveBox.reader);
  }

  Box get box => _box;
}
