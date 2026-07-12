import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostdeck/presentation/widgets/import_progress_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/utils/qr_share_helper.dart';
import '../controllers/settings_controller.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  final MobileScannerController _scannerController = MobileScannerController();
  final SettingsController _settingsController = Get.find<SettingsController>();
  bool _isProcessing = false;

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _processQrData(String qrData) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    _scannerController.stop();

    // Prompt for 4-digit PIN
    final pin = await _promptForPin();
    if (pin == null || pin.isEmpty) {
      setState(() => _isProcessing = false);
      _scannerController.start();
      return; // User cancelled
    }

    try {
      // Decrypt the QR payload
      final accountsData = QrShareHelper.decryptAndDecode(qrData, pin);

      // Filter duplicates to avoid spamming the snackbar!
      final existingEmails = _settingsController.accounts
          .map((a) => a.email)
          .toSet();
      final newAccounts = accountsData
          .where((acc) => !existingEmails.contains(acc['email']))
          .toList();
      final skippedCount = accountsData.length - newAccounts.length;

      if (newAccounts.isEmpty) {
        Get.snackbar(
          'Notice',
          'All accounts in this QR code already exist on your device.',
        );
        Get.back();
        return;
      }

      // Show confirmation bottom sheet
      final shouldAdd = await _showConfirmationSheet(newAccounts, skippedCount);

      if (shouldAdd == true) {
        _scannerController.stop();
        Get.dialog(
          ImportProgressDialog(accounts: newAccounts),
          barrierDismissible: false,
        );
      } else {
        setState(() => _isProcessing = false);
        _scannerController.start();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to decrypt QR code. Are you sure the PIN is correct?',
      );
      setState(() => _isProcessing = false);
      _scannerController.start();
    }
  }

  Future<String?> _promptForPin() {
    final TextEditingController pinController = TextEditingController();
    return Get.defaultDialog<String>(
      title: 'Enter 4-Digit PIN',
      content: TextField(
        controller: pinController,
        keyboardType: TextInputType.number,
        maxLength: 4,
        obscureText: true,
        decoration: const InputDecoration(hintText: 'PIN'),
      ),
      textConfirm: 'Unlock',
      textCancel: 'Cancel',
      onConfirm: () => Get.back(result: pinController.text),
    );
  }

  Future<bool?> _showConfirmationSheet(
    List<Map<String, String>> accounts,
    int skippedCount,
  ) {
    return Get.bottomSheet<bool>(
      Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Found ${accounts.length} new accounts!',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (skippedCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  '($skippedCount skipped because they already exist)',
                ),
              ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(accounts[index]['name']!),
                    subtitle: Text(accounts[index]['email']!),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Get.back(result: true),
                  child: const Text('Add All'),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> _scanFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final BarcodeCapture? capture = await _scannerController.analyzeImage(
        image.path,
      );
      if (capture != null && capture.barcodes.isNotEmpty) {
        final String? qrData = capture.barcodes.first.rawValue;
        if (qrData != null) {
          _processQrData(qrData);
          return;
        }
      }
      Get.snackbar('Error', 'No valid QR code found in the image.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Accounts')),
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                _processQrData(barcodes.first.rawValue!);
              }
            },
          ),
          // A simple target overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _scanFromGallery,
        icon: const Icon(Icons.photo_library),
        label: const Text('Gallery'),
      ),
    );
  }
}
