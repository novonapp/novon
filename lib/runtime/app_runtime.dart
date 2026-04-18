/// A centralized registry for managing the application's runtime re-initialization 
/// orchestration, allowing for the execution of global environmental refreshes.
class AppRuntime {
  /// Internal registrar for the re-initialization orchestration logic.
  static Future<void> Function()? _reinitializer;

  static void registerReinitializer(Future<void> Function() reinitializer) {
    _reinitializer = reinitializer;
  }

  static Future<void> reinitialize() async {
    final fn = _reinitializer;
    if (fn == null) return;
    await fn();
  }
}
