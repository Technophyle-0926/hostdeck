import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostdeck/data/datasources/remote/google_auth_service.dart';
import 'package:hostdeck/routes/app_pages.dart';

class AuthController extends GetxController {
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  final Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
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
    final user = await _googleAuthService.signInWithGoogle();
    if (user == null) {
      Get.snackbar(
        'Sign-in Cancelled',
        'Could not complete Google Sign-In.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
        colorText: Colors.red,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Future<void> signOut() async {
    await _googleAuthService.signOut();
  }
}
