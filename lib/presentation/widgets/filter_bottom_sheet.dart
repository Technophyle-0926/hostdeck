import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostdeck/core/constants/app_enums.dart';
import '../controllers/dashboard_controller.dart';

class FilterBottomSheet {
  static void show(BuildContext context, DashboardController controller) {
    final localPlatforms = <BuildPlatform>[...controller.selectedPlatforms].obs;
    final localAccounts = <int>[...controller.selectedHostAccounts].obs;
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    localPlatforms.clear();
                    localAccounts.clear();
                  },
                  child: const Text(
                    'Clear All',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Platform',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Wrap(
                spacing: 8,
                children: [BuildPlatform.ios, BuildPlatform.android].map((platform) {
                  final isSelected = localPlatforms.contains(platform);
                  return FilterChip(
                    label: Text(platform.displayName),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        localPlatforms.add(platform);
                      } else {
                        localPlatforms.remove(platform);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Accounts',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Wrap(
                spacing: 8,
                children: controller.accounts.map((account) {
                  final isSelected = localAccounts.contains(
                    account.id,
                  );
                  return FilterChip(
                    label: Text(account.accountName),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        localAccounts.add(account.id);
                      } else {
                        localAccounts.remove(account.id);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.selectedPlatforms.assignAll(localPlatforms);
                  controller.selectedHostAccounts.assignAll(localAccounts);
                  Get.back();
                },
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true, // Allows the sheet to size itself properly
    );
  }
}
