import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostdeck/presentation/controllers/auth_controller.dart';
import 'package:hostdeck/routes/app_pages.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/settings_controller.dart';
import '../widgets/add_account_sheet.dart';
import '../widgets/shimmer_loading.dart';
import '../../domain/entities/app_user.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = Get.find<AuthController>().appUser.value;
    final bool canManageAccounts = authUser?.role == UserRole.admin;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.settingsTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          if (canManageAccounts)
            IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              tooltip: 'Scan QR Code',
              onPressed: () => Get.toNamed(Routes.scanQr),
            ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: AppStrings.logOut,
            onPressed: () => Get.find<AuthController>().signOut(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: canManageAccounts 
        ? FloatingActionButton.extended(
            onPressed: () => AddAccountSheet.show(context, controller),
            icon: const Icon(Icons.add),
            label: const Text(AppStrings.addAccount),
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
          )
        : null,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.preferences,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildThemeSection(context),
                  if (canManageAccounts) ...[
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          AppStrings.manageAccounts,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            if (controller.accounts.isEmpty) {
                              Get.snackbar('Notice', 'No accounts to share!');
                              return;
                            }
                            Get.toNamed(
                              Routes.shareQr,
                              arguments: controller.accounts,
                            ); // Pass ALL accounts!
                          },
                          icon: const Icon(Icons.qr_code),
                          label: const Text('Share All'),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (canManageAccounts)
            Obx(() {
              controller.themeMode.value; // Force rebuild
              final customTheme = Theme.of(
                context,
              ).extension<AppThemeExtension>()!;
              if (controller.isLoading.value) {
                return const SettingsShimmerLoading();
              }
              if (controller.accounts.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text(
                        AppStrings.noAccountsFound,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final account = controller.accounts[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: customTheme.iconBackgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.cloud_done,
                            color: customTheme.primaryIconColor,
                          ),
                        ),
                        title: Text(
                          account.accountName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(account.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.qr_code),
                              onPressed: () => Get.toNamed(
                                Routes.shareQr,
                                arguments: [account],
                              ), // Pass just THIS account!
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => AddAccountSheet.show(
                                context,
                                controller,
                                existingAccount: account,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () => _confirmDelete(context, account),
                            ),
                          ],
                        ),
                      ),
                    );
                  }, childCount: controller.accounts.length),
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
                    ButtonSegment(
                      value: 0,
                      icon: Icon(Icons.brightness_auto),
                      label: Text(AppStrings.system),
                    ),
                    ButtonSegment(
                      value: 1,
                      icon: Icon(Icons.light_mode),
                      label: Text(AppStrings.light),
                    ),
                    ButtonSegment(
                      value: 2,
                      icon: Icon(Icons.dark_mode),
                      label: Text(AppStrings.dark),
                    ),
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
        content: Text(
          '${AppStrings.deleteAccountConfirm} ${account.accountName}?',
        ),
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
            child: const Text(AppStrings.remove),
          ),
        ],
      ),
    );
  }
}
