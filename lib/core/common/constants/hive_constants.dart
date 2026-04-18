/// Registry for persistent localized storage containers, demarcating logical
/// segments for settings, extension metadata, and diagnostic archives.
class HiveBox {
  HiveBox._();

  static const String app = 'novon_settings';
  static const String reader = 'novon_reader';
  static const String extensions = 'novon_extensions';

  /// Persistent exception logs — excluded from backups, pruned after 14 days.
  static const String exceptions = 'novon_exceptions';

  /// Tracks novels removed from library with removal timestamps for 3-day grace period cleanup.
  static const String removedNovels = 'novon_removed_novels';
}

/// Centralized schema definition for key-value persistence, facilitating the
/// granular orchestration of application state, user preferences, and reader parameters.
class HiveKeys {
  HiveKeys._();

  static const String onboardingComplete = 'onboarding_complete';
  static const String storageUri = 'storage_uri';
  static const String preferredLanguages = 'preferred_languages';

  // Appearance
  static const String appTheme = 'app_theme';
  static const String accentColor = 'accent_color';
  static const String appLocale = 'app_locale';
  static const String dateFormat = 'date_format';
  static const String navLabelMode = 'nav_label_mode';
  static const String showUpdateBadge = 'show_update_badge';
  static const String libraryGridColumns = 'library_grid_columns';
  static const String coverAspectRatio = 'cover_aspect_ratio';
  static const String showGridTitle = 'show_grid_title';
  static const String libraryDisplayMode = 'library_display_mode';
  static const String librarySort = 'library_sort';
  static const String libraryAscending = 'library_ascending';
  static const String libraryFilters = 'library_filters';
  static const String customBgColor = 'custom_bg_color';
  static const String customSurfaceColor = 'custom_surface_color';
  static const String globalChapterSortAscending = 'global_chapter_sort_ascending';

  // Downloads
  static const String downloadConcurrent = 'download_concurrent';
  static const String downloadRetryAttempts = 'download_retry_attempts';
  static const String downloadRetryInterval = 'download_retry_interval';
  static const String downloadIncludeImages = 'download_include_images';
  static const String downloadImageQuality = 'download_image_quality';
  static const String downloadWifiOnly = 'download_wifi_only';
  static const String downloadAutoDelete = 'download_auto_delete';
  static const String downloadAutoNew = 'download_auto_new';
  static const String downloadTaskState = 'download_task_state';

  // Browse
  static const String showNsfwExtensions = 'show_nsfw_extensions';
  static const String globalSearchTimeoutSec = 'global_search_timeout_sec';
  static const String globalSearchPerSource = 'global_search_per_source';
  static const String extensionRepos = 'extension_repos';
  static const String extensionAutoUpdate = 'extension_auto_update';

  // Network & User-Agent
  static const String globalUserAgent = 'global_user_agent';
  static const String sourceUserAgents = 'source_user_agents';
  static const String sourceCookies = 'source_cookies';
  static const String chapterHtmlCache = 'chapter_html_cache';
  static const String chapterProgress = 'chapter_progress';
  static const String novelLastChapter = 'novel_last_chapter';
  static const String updatesSeenChapterIds = 'updates_seen_chapter_ids';
  static const String dohProvider = 'doh_provider';
  static const String requestTimeoutSec = 'request_timeout_sec';
  static const String defaultRateLimitRps = 'default_rate_limit_rps';
  static const String httpCacheEnabled = 'http_cache_enabled';
  static const String httpCacheMaxMb = 'http_cache_max_mb';
  static const String proxyEnabled = 'proxy_enabled';
  static const String cfBypassMode = 'cf_bypass_mode';
  static const String cfWebviewTimeoutSec = 'cf_webview_timeout_sec';

  // Notifications
  static const String notifChapterUpdates = 'notif_chapter_updates';
  static const String notifDownloads = 'notif_downloads';
  static const String updateCheckInterval = 'update_check_interval';
  static const String updateCheckWifiOnly = 'update_check_wifi_only';
  static const String notifSound = 'notif_sound';
  static const String notifVibrate = 'notif_vibrate';

  // Security & Privacy
  static const String appLockEnabled = 'app_lock_enabled';
  static const String appLockType = 'app_lock_type';
  static const String appLockPin = 'app_lock_pin';
  static const String appLockTimeout = 'app_lock_timeout';
  static const String blurRecents = 'blur_recents';
  static const String incognitoMode = 'incognito_mode';
  static const String allowScreenshots = 'allow_screenshots';
  static const String extensionVerifySignatures = 'extension_verify_signatures';

  // Advanced
  static const String jsInjectEnabled = 'js_inject_enabled';
  static const String jsInjectCode = 'js_inject_code';
  static const String forceSoftwareRender = 'force_software_render';
  static const String debugLogging = 'debug_logging';
  static const String logLevel = 'log_level';
  static const String developerMode = 'developer_mode';

  // Data & Storage
  static const String autoBackupEnabled = 'auto_backup_enabled';
  static const String autoBackupInterval = 'auto_backup_interval';
  static const String autoBackupKeepCount = 'auto_backup_keep_count';
  static const String webdavEnabled = 'webdav_enabled';
  static const String webdavUrl = 'webdav_url';
  static const String webdavUsername = 'webdav_username';

  // Extension Repository
  static const String extRepos = 'ext_repos';
  static const String extRepoIndexPrefix = 'ext_repo_index_';
  static const String extTrustedPrefix = 'ext_trusted_';
  static const String extEnabledPrefix = 'ext_enabled_';

  // Reader Specific
  static const String defaultReadingMode = 'default_reading_mode';
  static const String readerFontFamily = 'reader_font_family';
  static const String readerFontSize = 'reader_font_size';
  static const String readerLineHeight = 'reader_line_height';
  static const String readerParagraphSpacing = 'reader_paragraph_spacing';
  static const String readerLetterSpacing = 'reader_letter_spacing';
  static const String readerHorizontalMargin = 'reader_horizontal_margin';
  static const String readerTextAlign = 'reader_text_align';
  static const String readerTheme = 'reader_theme';
  static const String readerCustomBg = 'reader_custom_bg';
  static const String readerCustomText = 'reader_custom_text';
  static const String readerKeepScreenOn = 'reader_keep_screen_on';
  static const String readerFullscreen = 'reader_fullscreen';
  static const String readerShowProgressBar = 'reader_show_progress_bar';
  static const String readerShowChapterTitle = 'reader_show_chapter_title';
  static const String readerTapZones = 'reader_tap_zones';
  static const String readerVolumeButtons = 'reader_volume_buttons';
  static const String readerAutoscrollSpeed = 'reader_autoscroll_speed';
  static const String readerSafeAreaPadding = 'reader_safe_area_padding';
  static const String readerImageDisplay = 'reader_image_display';
  static const String readerFootnoteMode = 'reader_footnote_mode';

  // Novel Removal Grace Period
  /// Map of novelId -> ISO timestamp when the novel was removed from library.
  static const String removedNovelsIndex = 'removed_novels_index';

  // Exception Logs
  static const String excId = 'id';
  static const String excTimestamp = 'timestamp';
  static const String excErrorType = 'errorType';
  static const String excMessage = 'message';
  static const String excStackSummary = 'stackSummary';
}
