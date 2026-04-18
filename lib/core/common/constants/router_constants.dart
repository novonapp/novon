/// Centralized registry for the application's navigational paths and URI 
/// construction logic, facilitating decoupled route management.
class RouterConstants {
  RouterConstants._();

  // Root Routes
  static const String pathSplash = '/splash';
  static const String pathOnboarding = '/onboarding';
  
  // Tab Routes
  static const String pathLibrary = '/';
  static const String pathUpdates = '/updates';
  static const String pathHistory = '/history';
  static const String pathBrowse = '/browse';
  static const String pathMore = '/more';
  
  // Browse Sub-Routes
  static const String pathGlobalSearch = 'search';
  
  // More Sub-Routes
  static const String pathStatistics = 'statistics';
  static const String pathAbout = 'about';
  static const String pathReport = 'report';
  static const String pathSettings = 'settings';
  static const String pathDownloads = 'downloads';
  
  // Settings Sub-Routes
  static const String pathAppearanceSettings = 'appearance';
  static const String pathReaderSettings = 'reader';
  static const String pathDownloadsSettings = 'downloads';
  static const String pathTrackingSettings = 'tracking';
  static const String pathBrowseSettings = 'browse';
  static const String pathNetworkSettings = 'network';
  static const String pathNotificationsSettings = 'notifications';
  static const String pathSecuritySettings = 'security';
  static const String pathAdvancedSettings = 'advanced';
  static const String pathDeveloperLogs = 'logs';
  static const String pathDataSettings = 'data';
  
  // Deep Settings
  static const String pathPinSetup = 'pin-setup';
  static const String pathBackup = 'backup';

  // Full Screen Routes (Outside Shell)
  static const String pathNovelDetail = '/novel/:sourceId/:novelId';
  static const String pathReader = '/novel/:sourceId/:novelId/chapter/:chapterId';
  static const String pathSourceBrowse = '/source/:sourceId/browse';
  static const String pathSourceSearch = '/source/:sourceId/search';
  static const String pathManageRepos = '/browse/repos';
  static const String pathChapterWebview = '/chapter/webview';
  static const String pathCookieWebview = '/cookie/webview';
  static const String pathAppUpdate = '/app-update';

  // More Navigation Full Paths
  static const String moreDownloads = '$pathMore/$pathDownloads';
  static const String moreSettings = '$pathMore/$pathSettings';
  static const String moreBackup = '$pathMore/$pathSettings/$pathDataSettings/$pathBackup';
  static const String moreStatistics = '$pathMore/$pathStatistics';
  static const String moreTracking = '$pathMore/$pathSettings/$pathTrackingSettings';
  static const String moreAbout = '$pathMore/$pathAbout';
  static const String moreReport = '$pathMore/$pathReport';
  static const String moreSecurity = '$pathMore/$pathSettings/$pathSecuritySettings';
  static const String moreAppearance = '$pathMore/$pathSettings/$pathAppearanceSettings';
  static const String moreReader = '$pathMore/$pathSettings/$pathReaderSettings';
  static const String moreBrowseSettings = '$pathMore/$pathSettings/$pathBrowseSettings';
  static const String moreNetwork = '$pathMore/$pathSettings/$pathNetworkSettings';
  static const String moreNotifications = '$pathMore/$pathSettings/$pathNotificationsSettings';
  static const String moreAdvanced = '$pathMore/$pathSettings/$pathAdvancedSettings';
  static const String moreDeveloperLogs = '$moreAdvanced/$pathDeveloperLogs';
  static const String moreData = '$pathMore/$pathSettings/$pathDataSettings';

  // Full Path Helpers
  static String novelDetail(String sourceId, String novelId, {String? title, String? coverUrl}) {
    final encodedId = Uri.encodeComponent(novelId);
    final baseUrl = '/novel/$sourceId/$encodedId';
    final params = <String>[];
    if (title != null) params.add('title=${Uri.encodeComponent(title)}');
    if (coverUrl != null) params.add('cover=${Uri.encodeComponent(coverUrl)}');
    return params.isEmpty ? baseUrl : '$baseUrl?${params.join('&')}';
  }

  static String reader(String sourceId, String novelId, String chapterId) =>
      '/novel/$sourceId/${Uri.encodeComponent(novelId)}/chapter/${Uri.encodeComponent(chapterId)}';

  static String sourceBrowse(String sourceId) => '/source/$sourceId/browse';

  static String sourceSearch(String sourceId, {String? query}) {
    final path = '/source/$sourceId/search';
    return query != null ? '$path?query=${Uri.encodeComponent(query)}' : path;
  }

  static String pinSetup({bool isChangeMode = false}) =>
      '/more/settings/security/pin-setup${isChangeMode ? '?isChangeMode=true' : ''}';

  static String chapterWebview(String url, String sourceId) =>
      '$pathChapterWebview?url=${Uri.encodeComponent(url)}&sourceId=$sourceId';

  static String cookieWebview(String url, String sourceId) =>
      '$pathCookieWebview?url=${Uri.encodeComponent(url)}&sourceId=$sourceId';
}

