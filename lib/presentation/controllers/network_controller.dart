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
        isDismissible: false,
        duration: const Duration(
          days: 999,
        ), // Stay open indefinitely until online
        backgroundColor: Colors.red[800]!,
        icon: const Icon(Icons.wifi_off, color: Colors.white, size: 24),
        margin: EdgeInsets.zero,
        snackPosition:
            SnackPosition.TOP, // Top looks like a native system alert
        snackStyle: SnackStyle.GROUNDED,
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
          margin: EdgeInsets.zero,
          snackPosition: SnackPosition.TOP,
          snackStyle: SnackStyle.GROUNDED,
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
