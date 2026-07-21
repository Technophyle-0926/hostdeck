import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostdeck/data/datasources/local/database_service.dart';
import 'package:hostdeck/data/datasources/local/secure_storage_service.dart';
import 'package:hostdeck/data/datasources/remote/firestore_sync_service.dart';
import 'package:hostdeck/data/datasources/remote/google_auth_service.dart';
import 'package:hostdeck/data/models/app_user_model.dart';
import 'package:hostdeck/domain/entities/app_user.dart';
import 'package:hostdeck/presentation/controllers/settings_controller.dart';
import 'package:hostdeck/routes/app_pages.dart';
import 'package:hostdeck/core/constants/app_strings.dart';
import 'package:hostdeck/core/constants/app_constants.dart';
import 'package:hostdeck/core/constants/app_keys.dart';

class AuthController extends GetxController {
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rxn<AppUser> appUser = Rxn<AppUser>();
  final RxBool isSigningIn = false.obs;

  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  Future<void> _setInitialScreen(User? user) async {
    if (user == null) {
      appUser.value = null; // Clear state on logout
      if (Get.currentRoute != Routes.login) {
        Get.offAllNamed(Routes.login);
      }
    } else {
      var doc = await FirebaseFirestore.instance
          .collection(FirestoreCollections.users)
          .doc(user.uid)
          .get();

      // Handle brand new accounts: Create the document if it doesn't exist yet!
      if (!doc.exists) {
        // 1. Check if the user is pre-authorized by an Admin
        final authDoc = await FirebaseFirestore.instance
            .collection(FirestoreCollections.preAuthorizedUsers)
            .doc(user.email?.toLowerCase())
            .get();

        if (authDoc.exists && authDoc.data() != null) {
          final data = authDoc.data()!;
          final newUser = AppUserModel()
            ..uid = user.uid
            ..email = user.email ?? ''
            ..displayName = user.displayName ?? ''
            ..role = data[AppKeys.role] ?? UserRole.client.name
            ..accessibleProjectIds = List<String>.from(data[AppKeys.accessibleProjectIds] ?? []);
            
          await FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(user.uid).set(newUser.toJson());
          doc = await FirebaseFirestore.instance.collection(FirestoreCollections.users).doc(user.uid).get();
        } else {
          // User is NOT authorized. Block them and log them out.
          await signOut();
          Get.snackbar(
            'Access Denied', 
            'Your email address is not authorized. Please ask an Admin for access.',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }

      if (doc.exists && doc.data() != null) {
        appUser.value = AppUserModel.fromJson(doc.data()!).toEntity();

        if (appUser.value!.role == UserRole.admin) {
          try {
            final secureStorage = Get.find<SecureStorageService>();
            final syncService = Get.find<FirestoreSyncService>();
            final remoteAccounts = await syncService.syncDown(secureStorage);
            await Get.find<DatabaseService>().saveHostAccounts(remoteAccounts);
            if (Get.isRegistered<SettingsController>()) {
              Get.find<SettingsController>().loadAccounts();
            }
          } catch (e) {
            Get.log('Failed to sync admin accounts: $e');
          }

           if (Get.currentRoute != Routes.dashboard) {
             Get.offAllNamed(Routes.dashboard);
           }
        } else {
           if (Get.currentRoute != Routes.dashboard) {
             Get.offAllNamed(Routes.dashboard);
           }
        }
      }
    }
  }

  Future<void> signInWithGoogle() async {
    isSigningIn.value = true;

    try {
      final user = await _googleAuthService.signInWithGoogle();
      if (user == null) {
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
