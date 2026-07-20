import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkController extends GetxController {
  final InternetConnection _internetConnection = InternetConnection();
  late StreamSubscription<InternetStatus> _internetSubscription;

  final RxBool isOnline = true.obs;
  bool _hasLostConnection =
      false; // Prevents showing "Back online" on initial launch

  @override
  void onInit() {
    super.onInit();

    // This securely pings Cloudflare/Google DNS to verify real internet access
    // instead of just checking if Wi-Fi is connected to a local router!
    _internetSubscription = _internetConnection.onStatusChange.listen((
      InternetStatus status,
    ) {
      _updateConnectionStatus(status == InternetStatus.connected);
    });
  }

  void _updateConnectionStatus(bool hasInternet) {
    if (isOnline.value == hasInternet) return; // Prevent duplicate triggers

    isOnline.value = hasInternet;

    if (!hasInternet) {
      _hasLostConnection = true;

      // Close any existing snackbars before showing the persistent offline one
      if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

      Get.rawSnackbar(
        messageText: const Text(
          'You are offline. Please check your connection.',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        isDismissible: true, // Allow user to dismiss if it blocks UI
        duration: const Duration(
          days: 999,
        ), // Stay open indefinitely until online or dismissed
        backgroundColor: Colors.red[800]!,
        icon: const Icon(Icons.wifi_off, color: Colors.white, size: 24),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        snackPosition: SnackPosition.BOTTOM, 
        snackStyle: SnackStyle.FLOATING,
      );
    } else {
      if (_hasLostConnection) {
        // Close the offline snackbar
        if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

        Get.rawSnackbar(
          messageText: const Text(
            'Back online!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          isDismissible: true,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green[700]!,
          icon: const Icon(Icons.wifi, color: Colors.white, size: 24),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          snackPosition: SnackPosition.BOTTOM,
          snackStyle: SnackStyle.FLOATING,
        );
      }
    }
  }

  @override
  void onClose() {
    _internetSubscription.cancel();
    super.onClose();
  }
}
