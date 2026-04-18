/// Centralized repository for application-level static configuration parameters 
/// and standardized versioning orchestration.
class AppConfig {
  /// The official canonical name of the application.
  static const String appName = 'Novon';
  
  static const String status = 'Alpha';
  
  static const int apiVersion = 1;

  static String formatVersion(String version, String buildNumber) {
    return 'v$version-$status (build $buildNumber)';
  }
}
