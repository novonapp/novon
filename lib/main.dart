import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'core/services/app_bootstrapper.dart';
import 'core/services/app_initializer.dart';
import 'core/services/exception_logger_service.dart';
import 'runtime/app_runtime.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Orchestrates global exception interception and persistence.
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    ExceptionLoggerService.instance.log(details.exception, details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    ExceptionLoggerService.instance.log(error, stack);
    return true;
  };

  // Initializes low-level subsystems including background orchestration and notifications.
  AppInitializer.initBackgroundWorkers();
  AppInitializer.initDownloadNotifications();
  
  // Registers the runtime re-initialization hook for environmental updates.
  AppRuntime.registerReinitializer(() => AppBootstrapper.instance.bootstrap(reinitialize: true));

  // Executes the final application bootstrap sequence and launches the root widget.
  await AppBootstrapper.instance.bootstrap();
}
