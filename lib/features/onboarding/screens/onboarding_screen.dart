import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/services/storage_path_service.dart';
import '../../../core/services/exception_logger_service.dart';
import '../../../core/common/constants/hive_constants.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../runtime/app_runtime.dart';
import '../../../core/theme/novon_colors.dart';
import '../widgets/onboarding_widgets.dart';

import '../widgets/steps/onboarding_welcome_step.dart';
import '../widgets/steps/onboarding_tour_step.dart';
import '../widgets/steps/onboarding_permissions_step.dart';
import '../widgets/steps/onboarding_storage_step.dart';
import '../widgets/steps/onboarding_language_step.dart';
import '../widgets/steps/onboarding_appearance_step.dart';
import '../widgets/steps/onboarding_finish_step.dart';

/// A multi-stage orchestration interface for initial application configuration,
/// facilitating environmental appraisal, data persistence anchoring, and aesthetic personalization.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const int _totalSteps = 7;

  final PageController _pageController = PageController();
  int _currentPage = 0;

  bool _storageGranted = false;
  bool _notificationsGranted = false;

  String? _selectedFolderPath;
  bool _storageValid = false;
  String _storageMessage = '';

  final Set<String> _selectedLanguages = {'en'};
  static const List<LanguageOption> _languages = [
    LanguageOption(code: 'all', name: 'All Languages', emoji: ''),
    LanguageOption(code: 'en', name: 'English', emoji: '🇺🇸'),
    LanguageOption(code: 'ar', name: 'Arabic', emoji: '🇸🇦'),
    LanguageOption(code: 'ja', name: 'Japanese', emoji: '🇯🇵'),
    LanguageOption(code: 'ko', name: 'Korean', emoji: '🇰🇷'),
    LanguageOption(code: 'zh-Hans', name: 'Chinese', emoji: '🇨🇳'),
    LanguageOption(code: 'fr', name: 'French', emoji: '🇫🇷'),
    LanguageOption(code: 'es', name: 'Spanish', emoji: '🇪🇸'),
  ];

  String _selectedTheme = 'dark';
  int _selectedAccent = 0xFF6C63FF;

  @override
  void initState() {
    super.initState();
    _checkInitialPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) => setState(() => _currentPage = index),
          children: [
            OnboardingWelcomeStep(
              currentStep: 1,
              totalSteps: _totalSteps,
              onNext: _nextPage,
            ),
            OnboardingTourStep(
              currentStep: 2,
              totalSteps: _totalSteps,
              onNext: _nextPage,
              onPrev: _prevPage,
            ),
            OnboardingPermissionsStep(
              currentStep: 3,
              totalSteps: _totalSteps,
              storageGranted: _storageGranted,
              notificationsGranted: _notificationsGranted,
              onNext: _nextPage,
              onPrev: _prevPage,
              onRequestStorage: _requestStoragePermission,
              onRequestNotifications: _requestNotificationPermission,
            ),
            OnboardingStorageStep(
              currentStep: 4,
              totalSteps: _totalSteps,
              selectedFolderPath: _selectedFolderPath,
              storageValid: _storageValid,
              storageMessage: _storageMessage,
              onNext: _nextPage,
              onPrev: _prevPage,
              onPickFolder: _pickStorageFolder,
            ),
            OnboardingLanguageStep(
              currentStep: 5,
              totalSteps: _totalSteps,
              selectedLanguages: _selectedLanguages,
              languages: _languages,
              onNext: _nextPage,
              onPrev: _prevPage,
              onLanguageSelected: _onLanguageSelected,
            ),
            OnboardingAppearanceStep(
              currentStep: 6,
              totalSteps: _totalSteps,
              selectedTheme: _selectedTheme,
              selectedAccent: _selectedAccent,
              onNext: _nextPage,
              onPrev: _prevPage,
              onThemeChanged: (val) {
                setState(() => _selectedTheme = val);
                ref.read(themeProvider.notifier).updateTheme(val);
              },
              onAccentChanged: (val) {
                setState(() => _selectedAccent = val);
                ref.read(themeProvider.notifier).updateAccentColor(Color(val));
              },
            ),
            OnboardingFinishStep(
              currentStep: 7,
              totalSteps: _totalSteps,
              onFinish: _completeOnboarding,
              onPrev: _prevPage,
            ),
          ],
        ),
      ),
    );
  }

  void _onLanguageSelected(String code, bool isSelected) {
    setState(() {
      if (code == 'all') {
        if (isSelected) {
          _selectedLanguages
            ..clear()
            ..add('all');
        } else {
          _selectedLanguages.remove('all');
        }
      } else {
        _selectedLanguages.remove('all');
        if (isSelected) {
          _selectedLanguages.add(code);
        } else {
          _selectedLanguages.remove(code);
        }
      }
    });
  }

  void _nextPage() {
    if (_currentPage >= _totalSteps - 1) return;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _prevPage() {
    if (_currentPage <= 0) return;
    _pageController.previousPage(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _checkInitialPermissions() async {
    final storageStatus = await Permission.storage.isGranted;
    final manageStorageStatus =
        await Permission.manageExternalStorage.isGranted;
    final notificationsStatus = await Permission.notification.isGranted;
    if (!mounted) return;
    setState(() {
      _storageGranted = storageStatus || manageStorageStatus;
      _notificationsGranted = notificationsStatus;
    });
  }

  Future<void> _requestStoragePermission() async {
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();
    }
    if (!mounted) return;
    setState(() => _storageGranted = status.isGranted);
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.request();
    if (!mounted) return;
    setState(() => _notificationsGranted = status.isGranted);
  }

  Future<void> _pickStorageFolder() async {
    try {
      final selected = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select your Novon folder',
      );
      if (!mounted) return;
      if (selected == null) {
        setState(() {
          _storageValid = false;
          _storageMessage = 'Folder selection canceled.';
        });
        return;
      }
      setState(() {
        _selectedFolderPath = selected;
        _storageValid = true;
        _storageMessage = 'Folder selected. Novon will use this location now.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _storageValid = false;
        _storageMessage = 'Error selecting folder: $e';
      });
    }
  }

  Future<void> _completeOnboarding() async {
    final sps = StoragePathService.instance;
    final box = Hive.box(HiveBox.app);
    try {
      if (_selectedFolderPath != null) {
        await sps.setStoragePath(_selectedFolderPath!);
        await sps.ensureDirectoriesExist();
      }
      await sps.setOnboardingComplete();

      await box.put(HiveKeys.onboardingComplete, true);
      await box.put(HiveKeys.storageUri, _selectedFolderPath);
      await box.put(HiveKeys.preferredLanguages, _selectedLanguages.toList());
      await box.put(HiveKeys.appTheme, _selectedTheme);
      await box.put(HiveKeys.accentColor, _selectedAccent);

      await AppRuntime.reinitialize();

      if (!mounted) return;
      context.go('/');
    } catch (e, st) {
      if (!mounted) return;

      ExceptionLoggerService.instance.log(e, st);

      await sps.resetOnboarding();
      try {
        final resetBox = Hive.isBoxOpen(HiveBox.app)
            ? Hive.box(HiveBox.app)
            : await Hive.openBox(HiveBox.app);
        await resetBox.clear();
      } catch (_) {}
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Setup failed: $e\nSettings reset. Please try again or report on GitHub.',
          ),
          backgroundColor: NovonColors.error,
          duration: const Duration(seconds: 8),
          action: SnackBarAction(
            label: 'RETRY',
            textColor: Colors.white,
            onPressed: () => _pageController.jumpToPage(0),
          ),
        ),
      );
    }
  }
}
