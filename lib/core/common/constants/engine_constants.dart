/// Bridge definition layer containing contractual method identifiers and communication 
/// channels required for the extension host environment.
class EngineConstants {
  EngineConstants._();

  // requiredMethods
  static const String methodFetchPopular = 'fetchPopular';
  static const String methodFetchLatestUpdates = 'fetchLatestUpdates';
  static const String methodSearch = 'search';
  static const String methodFetchNovelDetail = 'fetchNovelDetail';
  static const String methodFetchChapterList = 'fetchChapterList';
  static const String methodFetchChapterContent = 'fetchChapterContent';

  static const List<String> requiredMethods = [
    methodFetchPopular,
    methodFetchLatestUpdates,
    methodSearch,
    methodFetchNovelDetail,
    methodFetchChapterList,
    methodFetchChapterContent,
  ];

  // Channels
  static const String channelHttpGet = 'http_get';
  static const String channelConsoleLog = 'console_log';
  static const String channelMethodResult = 'method_result';
  static const String channelGetBridgeData = 'get_bridge_data';

  // Assets
  static const String htmlParserAsset = 'assets/js/htmlparser2.bundle.js';

  // JS Properties
  static const String propertyExtension = '__novonExtension';
}
