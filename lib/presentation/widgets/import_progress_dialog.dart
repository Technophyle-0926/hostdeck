import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostdeck/core/constants/app_keys.dart';
import '../../core/constants/app_enums.dart';
import '../controllers/settings_controller.dart';

class ImportProgressDialog extends StatefulWidget {
  final List<Map<String, String>> accounts;

  const ImportProgressDialog({super.key, required this.accounts});

  @override
  State<ImportProgressDialog> createState() => _ImportProgressDialogState();
}

class _ImportProgressDialogState extends State<ImportProgressDialog> {
  final Map<String, ProgressStatus> _statuses = {};
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    for (var acc in widget.accounts) {
      _statuses[acc[AppKeys.email]!] = ProgressStatus.pending;
    }
    _startImport();
  }

  Future<void> _startImport() async {
    final controller = Get.find<SettingsController>();
    await controller.addMultipleAccounts(
      widget.accounts,
      onProgress: (email, success) {
        if (mounted) {
          setState(() {
            _statuses[email] = success
                ? ProgressStatus.success
                : ProgressStatus.failed;
          });
        }
      },
    );

    if (mounted) {
      setState(() => _isFinished = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Importing Accounts...'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.accounts.length,
          itemBuilder: (context, index) {
            final email = widget.accounts[index][AppKeys.email]!;
            final status = _statuses[email];

            Widget trailingIcon;
            if (status == ProgressStatus.success) {
              trailingIcon = const Icon(
                Icons.check_circle,
                color: Colors.green,
              );
            } else if (status == ProgressStatus.failed) {
              trailingIcon = const Icon(Icons.error, color: Colors.red);
            } else {
              trailingIcon = const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              );
            }

            return ListTile(
              title: Text(widget.accounts[index][AppKeys.name]!),
              subtitle: Text(email),
              trailing: trailingIcon,
            );
          },
        ),
      ),
      actions: [
        if (_isFinished)
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(); // Close scanner screen
              int addedCount = _statuses.values
                  .where((status) => status == ProgressStatus.success)
                  .length;
              if (addedCount > 0) {
                Get.snackbar(
                  'Success',
                  'Added $addedCount accounts successfully!',
                );
              }
            },
            child: const Text('Done'),
          ),
      ],
    );
  }
}
