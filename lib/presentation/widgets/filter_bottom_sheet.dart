import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostdeck/core/constants/app_enums.dart';
import 'package:hostdeck/core/constants/app_strings.dart';
import '../controllers/dashboard_controller.dart';

class FilterBottomSheet {
  static void show(BuildContext context, DashboardController controller) {
    final localPlatforms = <BuildPlatform>[...controller.selectedPlatforms].obs;
    final localAccounts = <int>[...controller.selectedHostAccounts].obs;
    final localProjects = <String>[...controller.selectedProjects].obs;
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
                  AppStrings.filters,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    localPlatforms.clear();
                    localAccounts.clear();
                    localProjects.clear();
                  },
                  child: const Text(
                    AppStrings.clearAll,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              AppStrings.platform,
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
            if (controller.accounts.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                AppStrings.accounts,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Wrap(
                  spacing: 8,
                  children: controller.accounts.map((account) {
                    final isSelected = localAccounts.contains(account.id);
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
            ],
            if (controller.availableProjects.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Text(
                'Projects',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Wrap(
                  spacing: 8,
                  children: controller.availableProjects.map((project) {
                    final isSelected = localProjects.contains(project['id']);
                    return FilterChip(
                      label: Text(project['name']!),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          localProjects.add(project['id']!);
                        } else {
                          localProjects.remove(project['id']);
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.selectedPlatforms.assignAll(localPlatforms);
                  controller.selectedHostAccounts.assignAll(localAccounts);
                  controller.selectedProjects.assignAll(localProjects);
                  Get.back();
                },
                child: const Text(AppStrings.apply),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true, // Allows the sheet to size itself properly
    );
  }
}
