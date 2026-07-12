import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hostdeck/core/constants/app_constants.dart';
import 'package:hostdeck/core/constants/app_strings.dart';
import 'package:hostdeck/data/datasources/remote/firestore_sync_service.dart';
import 'package:hostdeck/firebase_options.dart';
import 'package:hostdeck/presentation/controllers/auth_controller.dart';
import 'package:hostdeck/presentation/controllers/network_controller.dart';
import 'core/theme/app_theme.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'data/datasources/local/settings_service.dart';
import 'data/datasources/local/database_service.dart';
import 'presentation/controllers/settings_controller.dart';
import 'package:dio/dio.dart';
import 'data/datasources/remote/api_client.dart';
import 'data/datasources/local/secure_storage_service.dart';
import 'domain/repositories/auth_repository.dart';
import 'data/repositories/auth_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await GoogleSignIn.instance.initialize(
    serverClientId: AppConstants.serverClientId,
  );

  // Initialize Global Services
  Get.put(NetworkController(), permanent: true);

  final settingsService = SettingsService();
  await settingsService.init();
  Get.put<SettingsService>(settingsService, permanent: true);

  final databaseService = DatabaseService();
  await databaseService.init();
  Get.put<DatabaseService>(databaseService, permanent: true);

  Get.put<ApiClient>(ApiClient(), permanent: true);
  Get.put<SecureStorageService>(SecureStorageService(), permanent: true);
  Get.put<AuthRepository>(AuthRepositoryImpl(Dio()), permanent: true);

  Get.put<AuthController>(AuthController(), permanent: true);
  Get.put<FirestoreSyncService>(FirestoreSyncService(), permanent: true);
  // Initialize SettingsController AFTER its dependencies are registered
  Get.put<SettingsController>(SettingsController(), permanent: true);

  runApp(const HostDeckApp());
}

class HostDeckApp extends StatelessWidget {
  const HostDeckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode:
          ThemeMode.system, // Will be overridden by SettingsController on init
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
