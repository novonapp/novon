/// A centralized repository for global application defaults, environmental
/// constants, and external resource identifiers.
class AppConstants {
  AppConstants._();

  static const String appName = 'Novon';
  static const String appVersion =
      '0.0.1'; // Should ideally be fetched from package_info

  // Storage
  static const String defaultStoragePath = 'Novon';

  // Extension Repository
  static const String defaultRepoUrl =
      'https://raw.githubusercontent.com/NovonApp/novon-extensions/main/index.json';

  // External Links
  static const String linkReleases =
      'https://github.com/novonapp/novon/releases';
  static const String linkLatestRelease =
      'https://github.com/novonapp/novon/releases/latest';
  static const String linkWebsite = 'https://novon.iprog.dev';
  static const String linkDocumentation =
      'https://novon.iprog.dev/docs/guides/getting-started';
  static const String linkDiscord = 'https://discord.gg/novon';
  static const String linkSourceCode = 'https://github.com/novonapp/novon';
  static const String linkApi =
      'https://api.github.com/repos/novonapp/novon/releases/latest';

  // Timeouts
  static const int defaultRequestTimeout = 30;
  static const int globalSearchTimeout = 60;

  // UI
  static const double defaultFontSize = 16.0;
  static const double defaultLineHeight = 1.6;

  // Filenames
  static const String filenameManifest = 'manifest.json';
  static const String filenameSource = 'source.js';
  static const String filenameIcon = 'icon.png';

  // Directory Names
  static const String dirDatabase = 'database';
  static const String dirSettings = 'settings';
  static const String dirBackups = 'backups';
  static const String dirDownloads = 'downloads';
  static const String dirCovers = 'covers';
  static const String dirCache = 'cache';
  static const String dirExtensions = 'extensions';

  // SharedPreferences / Preferences Keys
  static const String prefStoragePath = 'novon_storage_path';
  static const String prefOnboardingComplete = 'novon_onboarding_complete';

  // App Defaults
  static const String defaultTheme = 'dark';
  static const int defaultAccentColor = 0xFF6C63FF;
  static const String defaultLibraryDisplayMode = 'grid';
  static const int defaultLibraryGridColumns = 3;
  static const String defaultReaderFont = 'System';
  static const double defaultReaderFontSize = 17.0;
  static const double defaultReaderLineHeight = 1.8;
}
