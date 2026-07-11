import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostdeck/data/datasources/local/database_service.dart';
import 'package:hostdeck/data/datasources/local/secure_storage_service.dart';
import 'package:hostdeck/data/datasources/remote/firestore_sync_service.dart';
import 'package:hostdeck/data/datasources/remote/google_auth_service.dart';
import 'package:hostdeck/presentation/controllers/settings_controller.dart';
import 'package:hostdeck/routes/app_pages.dart';
import 'package:hostdeck/core/constants/app_strings.dart';

class AuthController extends GetxController {
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  final Rx<User?> firebaseUser = Rx<User?>(null);
  final RxBool isSigningIn = false.obs;

  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (isSigningIn.value) return;

    if (user == null) {
      if (Get.currentRoute != Routes.login) {
        Get.offAllNamed(Routes.login);
      }
    } else {
      if (Get.currentRoute != Routes.dashboard) {
        Get.offAllNamed(Routes.dashboard);
      }
    }
  }

  Future<void> signInWithGoogle() async {
    isSigningIn.value = true;

    try {
      final user = await _googleAuthService.signInWithGoogle();
      if (user != null) {
        final secureStorage = Get.find<SecureStorageService>();
        final syncService = Get.find<FirestoreSyncService>();
        final remoteAccounts = await syncService.syncDown(secureStorage);
        await Get.find<DatabaseService>().saveHostAccounts(remoteAccounts);
        Get.find<SettingsController>().loadAccounts();
        Get.offAllNamed(Routes.dashboard);
      } else {
        Get.snackbar(
          AppStrings.signInCancelled,
          AppStrings.signInCancelledDesc,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
          colorText: Colors.red,
          margin: const EdgeInsets.all(16),
        );
      }
    } finally {
      isSigningIn.value = false;
    }
  }

  Future<void> signOut() async {
    await Get.find<DatabaseService>().saveHostAccounts([]);
    await Get.find<DatabaseService>().saveBuilds([]);
    await Get.find<SecureStorageService>().clearAll();
    Get.find<SettingsController>().accounts.clear();
    await _googleAuthService.signOut();
  }
}
