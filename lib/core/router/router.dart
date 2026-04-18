import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'shell_scaffold.dart';
import '../../features/library/screens/library_screen.dart';
import '../../features/updates/screens/updates_screen.dart';
import '../../features/updates/screens/app_update_screen.dart';
import '../../features/history/screens/history_screen.dart';
import '../../features/browse/screens/browse_screen.dart';
import '../../features/browse/screens/source_browse_screen.dart';
import '../../features/browse/screens/source_search_screen.dart';
import '../../features/browse/screens/global_search_screen.dart';
import '../../features/browse/screens/manage_repositories_screen.dart';
import '../../features/more/screens/more_screen.dart';
import '../../features/more/screens/settings_screen.dart';
import '../../features/more/screens/downloads_screen.dart';
import '../../features/settings/screens/appearance_settings.dart';
import '../../features/settings/screens/reader_settings.dart';
import '../../features/settings/screens/downloads_settings.dart';
import '../../features/settings/screens/browse_settings.dart';
import '../../features/settings/screens/network_settings.dart';
import '../../features/settings/screens/notifications_settings.dart';
import '../../features/settings/screens/security_settings.dart';
import '../../features/settings/screens/advanced_settings.dart';
import '../../features/settings/screens/developer_logs_screen.dart';
import '../../features/settings/screens/data_settings.dart';
import '../../features/settings/screens/backup/backup_screen.dart';
import '../../features/settings/screens/tracking_settings.dart';
import '../../features/statistics/screens/statistics_screen.dart';
import '../../features/about/screens/about_screen.dart';
import '../../features/about/screens/report_issue_screen.dart';
import '../common/models/app_update_info.dart';
import '../../features/novel_detail/screens/novel_detail_screen.dart';
import '../../features/reader/screens/reader_screen.dart';
import '../../features/reader/screens/chapter_webview_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../../features/security/screens/pin_setup_screen.dart';
import '../common/screens/cookie_webview_screen.dart';
import '../services/storage_path_service.dart';
import '../common/constants/router_constants.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Primary navigation orchestration layer, defining the application's routing
/// topology, redirection policies, and stateful shell architecture.
final GoRouter novonRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouterConstants.pathSplash,
  redirect: (context, state) {
    // Appraises onboarding status and orchestrates redirection to the
    // setup workflow if environmental parameters are not yet initialized.
    final completed = StoragePathService.instance.isOnboardingComplete;

    if (!completed &&
        state.matchedLocation != RouterConstants.pathOnboarding &&
        state.matchedLocation != RouterConstants.pathSplash) {
      return RouterConstants.pathOnboarding;
    }
    return null;
  },
  routes: [
    GoRoute(
      path: RouterConstants.pathSplash,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouterConstants.pathOnboarding,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RouterConstants.pathAppUpdate,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final info = state.extra as AppUpdateInfo;
        return AppUpdateScreen(updateInfo: info);
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ShellScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Library tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouterConstants.pathLibrary,
              builder: (context, state) => const LibraryScreen(),
            ),
          ],
        ),
        // Updates tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouterConstants.pathUpdates,
              builder: (context, state) => const UpdatesScreen(),
            ),
          ],
        ),
        // History tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouterConstants.pathHistory,
              builder: (context, state) => const HistoryScreen(),
            ),
          ],
        ),
        // Browse tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouterConstants.pathBrowse,
              builder: (context, state) => const BrowseScreen(),
              routes: [
                GoRoute(
                  path: RouterConstants.pathGlobalSearch,
                  builder: (context, state) => const GlobalSearchScreen(),
                ),
              ],
            ),
          ],
        ),
        // More tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: RouterConstants.pathMore,
              builder: (context, state) => const MoreScreen(),
              routes: [
                GoRoute(
                  path: RouterConstants.pathStatistics,
                  builder: (context, state) => const StatisticsScreen(),
                ),
                GoRoute(
                  path: RouterConstants.pathAbout,
                  builder: (context, state) => const AboutScreen(),
                ),
                GoRoute(
                  path: RouterConstants.pathReport,
                  builder: (context, state) => const ReportIssueScreen(),
                ),
                GoRoute(
                  path: RouterConstants.pathSettings,
                  builder: (context, state) => const SettingsScreen(),
                  routes: [
                    GoRoute(
                      path: RouterConstants.pathAppearanceSettings,
                      builder: (context, state) =>
                          const AppearanceSettingsScreen(),
                    ),
                    GoRoute(
                      path: RouterConstants.pathReaderSettings,
                      builder: (context, state) => const ReaderSettingsScreen(),
                    ),
                    GoRoute(
                      path: RouterConstants.pathDownloadsSettings,
                      builder: (context, state) =>
                          const DownloadsSettingsScreen(),
                    ),
                    GoRoute(
                      path: RouterConstants.pathTrackingSettings,
                      builder: (context, state) =>
                          const TrackingSettingsScreen(),
                    ),
                    GoRoute(
                      path: RouterConstants.pathBrowseSettings,
                      builder: (context, state) => const BrowseSettingsScreen(),
                    ),
                    GoRoute(
                      path: RouterConstants.pathNetworkSettings,
                      builder: (context, state) =>
                          const NetworkSettingsScreen(),
                    ),
                    GoRoute(
                      path: RouterConstants.pathNotificationsSettings,
                      builder: (context, state) =>
                          const NotificationsSettingsScreen(),
                    ),
                    GoRoute(
                      path: RouterConstants.pathSecuritySettings,
                      builder: (context, state) =>
                          const SecuritySettingsScreen(),
                      routes: [
                        GoRoute(
                          path: RouterConstants.pathPinSetup,
                          builder: (context, state) {
                            final isChangeMode =
                                state.uri.queryParameters['isChangeMode'] ==
                                'true';
                            return PinSetupScreen(isChangeMode: isChangeMode);
                          },
                        ),
                      ],
                    ),
                    GoRoute(
                      path: RouterConstants.pathAdvancedSettings,
                      builder: (context, state) =>
                          const AdvancedSettingsScreen(),
                      routes: [
                        GoRoute(
                          path: RouterConstants.pathDeveloperLogs,
                          builder: (context, state) =>
                              const DeveloperLogsScreen(),
                        ),
                      ],
                    ),
                    GoRoute(
                      path: RouterConstants.pathDataSettings,
                      builder: (context, state) => const DataSettingsScreen(),
                      routes: [
                        GoRoute(
                          path: RouterConstants.pathBackup,
                          builder: (context, state) => const BackupScreen(),
                        ),
                      ],
                    ),
                  ],
                ),
                GoRoute(
                  path: RouterConstants.pathDownloads,
                  builder: (context, state) => const DownloadsScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    // Full-screen routes (outside shell)
    GoRoute(
      path: RouterConstants.pathNovelDetail,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => NovelDetailScreen(
        sourceId: state.pathParameters['sourceId']!,
        novelId: state.pathParameters['novelId']!,
        initialTitle: state.uri.queryParameters['title'],
        initialCoverUrl: state.uri.queryParameters['cover'],
      ),
    ),
    GoRoute(
      path: RouterConstants.pathReader,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => ReaderScreen(
        sourceId: state.pathParameters['sourceId']!,
        novelId: state.pathParameters['novelId']!,
        chapterId: state.pathParameters['chapterId']!,
      ),
    ),
    GoRoute(
      path: RouterConstants.pathSourceBrowse,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          SourceBrowseScreen(sourceId: state.pathParameters['sourceId']!),
    ),
    GoRoute(
      path: RouterConstants.pathSourceSearch,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          SourceSearchScreen(sourceId: state.pathParameters['sourceId']!),
    ),
    GoRoute(
      path: RouterConstants.pathManageRepos,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ManageRepositoriesScreen(),
    ),
    GoRoute(
      path: RouterConstants.pathChapterWebview,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final url = state.uri.queryParameters['url'] ?? '';
        final sourceId = state.uri.queryParameters['sourceId'] ?? '';
        return ChapterWebViewScreen(
          initialUrl: Uri.decodeComponent(url),
          sourceId: sourceId,
        );
      },
    ),
    GoRoute(
      path: RouterConstants.pathCookieWebview,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final url = state.uri.queryParameters['url'] ?? '';
        final sourceId = state.uri.queryParameters['sourceId'] ?? '';
        // In this specific flow, we are allowing cover picking. We don't have manifest domains here though,
        // so we'll pass empty list or fetch it if needed. For now empty is fine for cookie extraction.
        return CookieWebViewScreen(
          initialUrl: Uri.decodeComponent(url),
          sourceId: sourceId,
          domains: const [],
          enableCoverPicker: true,
        );
      },
    ),
  ],
);
