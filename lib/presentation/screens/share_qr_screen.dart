import 'dart:math';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/utils/qr_share_helper.dart';
import '../../domain/entities/host_account.dart';
import '../controllers/settings_controller.dart';

class ShareQrScreen extends StatefulWidget {
  const ShareQrScreen({super.key});

  @override
  State<ShareQrScreen> createState() => _ShareQrScreenState();
}

class _ShareQrScreenState extends State<ShareQrScreen> {
  final GlobalKey _qrKey = GlobalKey();
  final SettingsController _settingsController = Get.find<SettingsController>();

  List<HostAccount> _accounts = [];
  String? _qrData;
  String? _pin;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _accounts = Get.arguments as List<HostAccount>? ?? [];
    _generateQrData();
  }

  Future<void> _generateQrData() async {
    final auth = LocalAuthentication();
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await auth.isDeviceSupported();

      if (!canAuthenticate) {
        Get.snackbar(
          'Error',
          'Device must support authentication to share accounts.',
        );
        Get.back();
        return;
      }

      final didAuth = await auth.authenticate(
        localizedReason: 'Authenticate to generate sharing QR Code',
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );

      if (!didAuth) {
        Get.back(); // User cancelled auth
        return;
      }

      // Generate a random 4-digit PIN
      final random = Random();
      final pin = (random.nextInt(9000) + 1000).toString();

      List<String> passwords = [];
      for (var account in _accounts) {
        final pass = await _settingsController.getPassword(account.email);
        if (pass == null) {
          throw Exception('Password missing for ${account.email}');
        }
        passwords.add(pass);
      }

      // Encrypt the payload!
      final qrData = QrShareHelper.encodeAndEncrypt(_accounts, passwords, pin);

      setState(() {
        _pin = pin;
        _qrData = qrData;
        _isLoading = false;
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate QR: $e');
      Get.back();
    }
  }

  Future<void> _shareQrImage() async {
    try {
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/accounts_qr.png').create();
      await file.writeAsBytes(pngBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'Scan this QR code in HostDeck to add these accounts!',
        ),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to share QR code image.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share Accounts')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Tell the receiver this 4-digit PIN:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  _pin!,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: RepaintBoundary(
                    key: _qrKey,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: QrImageView(
                        data: _qrData!,
                        version: QrVersions.auto,
                        size: 250.0,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _shareQrImage,
                  icon: const Icon(Icons.share),
                  label: const Text('Share as Image'),
                ),
              ],
            ),
    );
  }
}
