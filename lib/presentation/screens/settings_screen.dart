import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/settings_controller.dart';
import '../widgets/add_account_sheet.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AddAccountSheet.show(context, controller),
        icon: const Icon(Icons.add),
        label: const Text('Add Account'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Preferences',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildThemeSection(context),
                  const SizedBox(height: 32),
                  const Text(
                    'Manage Accounts',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Obx(() {
            controller.themeMode.value; // Force rebuild
            final customTheme = Theme.of(context).extension<AppThemeExtension>()!;
            if (controller.accounts.isEmpty) {
              return const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(AppStrings.noAccountsFound, style: TextStyle(color: Colors.grey)),
                  ),
                ),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final account = controller.accounts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: customTheme.iconBackgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.cloud_done, color: customTheme.primaryIconColor),
                        ),
                        title: Text(account.accountName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(account.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => AddAccountSheet.show(context, controller, existingAccount: account),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => _confirmDelete(context, account),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: controller.accounts.length,
                ),
              ),
            );
          }),
          const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
        ],
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.appTheme,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 0, icon: Icon(Icons.brightness_auto), label: Text(AppStrings.system)),
                  ButtonSegment(value: 1, icon: Icon(Icons.light_mode), label: Text(AppStrings.light)),
                  ButtonSegment(value: 2, icon: Icon(Icons.dark_mode), label: Text(AppStrings.dark)),
                ],
                selected: {controller.themeMode.value},
                onSelectionChanged: (Set<int> newSelection) {
                  controller.updateThemeMode(newSelection.first);
                },
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, dynamic account) {
    Get.dialog(
      AlertDialog(
        title: const Text(AppStrings.deleteAccount),
        content: Text('${AppStrings.deleteAccountConfirm} ${account.accountName}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              controller.removeAccount(account);
              Get.back();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
