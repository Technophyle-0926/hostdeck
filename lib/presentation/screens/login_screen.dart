import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostdeck/core/constants/app_strings.dart';
import 'package:hostdeck/presentation/controllers/auth_controller.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Icon(Icons.rocket_launch, size: 80, color: Colors.blue),
            ClipOval(
              child: Image.asset('assets/icon/app_icon.png', height: 80),
            ),
            const SizedBox(height: 24),
            const Text(
              AppStrings.welcomeTitle,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),
            SignInButton(
              Buttons.google,
              text: AppStrings.signInWithGoogle,
              onPressed: () => controller.signInWithGoogle(),
            ),
          ],
        ),
      ),
    );
  }
}
