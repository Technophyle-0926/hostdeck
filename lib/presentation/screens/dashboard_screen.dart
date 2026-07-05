import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_enums.dart';
import '../../core/utils/date_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme/app_theme.dart';
import 'package:hostdeck/presentation/controllers/settings_controller.dart';
import '../controllers/dashboard_controller.dart';
import '../../routes/app_pages.dart';
import '../../domain/entities/aggregated_build.dart';
import '../widgets/add_account_sheet.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.appName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed(Routes.settings),
          ),
        ],
      ),
      body: Obx(() {
        Get.find<SettingsController>().themeMode.value; // Force rebuild on theme change
        final customTheme = Theme.of(context).extension<AppThemeExtension>()!;
        if (controller.isLoading.value && controller.accounts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.isLoading.value && controller.accounts.isEmpty) {
          return _buildEmptyState(context, customTheme);
        }

        return RefreshIndicator(
          onRefresh: controller.refreshAllAccounts,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (controller.isLoading.value)
                const SliverToBoxAdapter(
                  child: LinearProgressIndicator(minHeight: 2),
                ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildWarningBanner(customTheme),
                    const SizedBox(height: 16),
                    _buildAccountOverviews(customTheme),
                    const SizedBox(height: 24),
                    const Text(
                      AppStrings.aggregatedBuilds,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: _buildBuildsList(customTheme),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildWarningBanner(AppThemeExtension customTheme) {
    if (controller.isWarningDismissed.value) return const SizedBox.shrink();

    final critical = controller.criticalAccounts;
    if (critical.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: customTheme.warningBannerBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: customTheme.warningBannerBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: customTheme.warningBannerIcon,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.capacityCritical,
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${critical.length} ${AppStrings.capacityWarningDesc}',
                  style: TextStyle(color: customTheme.warningBannerText),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey, size: 20),
            onPressed: () {
              controller.isWarningDismissed.value = true;
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountOverviews(AppThemeExtension customTheme) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.accounts.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final account = controller.accounts[index];
          final progress = account.usagePercentage;
          final isCritical = controller.criticalAccounts.contains(account);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              width: 220,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    account.accountName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${account.appsCount} / ${account.maxAppsLimit} ${AppStrings.appsLabel}',
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      color: isCritical ? Colors.red : Colors.blue,
                      minHeight: 8,
                    ),
                  ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBuildsList(AppThemeExtension customTheme) {
    final groupedBuilds = controller.groupedBuilds;
    if (groupedBuilds.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(32),
          alignment: Alignment.center,
          child: const Text(
            AppStrings.noBuildsFound,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final group = groupedBuilds[index];
        final latestBuild = group.first;
        final historicalBuilds = group.length > 1 ? group.sublist(1) : <AggregatedBuild>[];

        Widget platformIcon;
        final platformEnum = BuildPlatform.fromString(latestBuild.platform);
        if (platformEnum == BuildPlatform.ios) {
          platformIcon = Icon(Icons.apple, color: Theme.of(context).iconTheme.color);
        } else if (platformEnum == BuildPlatform.android) {
          platformIcon = const Icon(Icons.android, color: Color(0xFF3DDC84));
        } else {
          platformIcon = Icon(Icons.rocket_launch, color: customTheme.primaryIconColor);
        }

        final mainCard = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: customTheme.iconBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: platformIcon,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          latestBuild.projectName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppStrings.versionPrefix}${latestBuild.version} • ${latestBuild.sizeMb.toStringAsFixed(1)} MB',
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              DateFormatterUtils.formatBuildDate(latestBuild.uploadDate),
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      if (latestBuild.downloadUrl.isNotEmpty) ...[
                        IconButton(
                          icon: const Icon(Icons.download, size: 20),
                          onPressed: () => _handleDownload(latestBuild.downloadUrl),
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                          tooltip: AppStrings.download,
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.share, size: 20),
                          onPressed: () => _handleShare(latestBuild),
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(),
                          tooltip: AppStrings.share,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        );

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: historicalBuilds.isEmpty
              ? Padding(padding: const EdgeInsets.all(16), child: mainCard)
              : Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: mainCard,
                    children: historicalBuilds.map((oldBuild) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 60), // Indent past icon (12+24+12+16)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'v${oldBuild.version} • ${oldBuild.sizeMb.toStringAsFixed(1)} MB',
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          DateFormatterUtils.formatBuildDate(oldBuild.uploadDate),
                                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
        );
      }, childCount: groupedBuilds.length),
    );
  }

  Future<void> _handleDownload(String url) async {
    String finalUrl = url;
    if (!finalUrl.startsWith('http://') && !finalUrl.startsWith('https://')) {
      finalUrl = 'https://$finalUrl';
    }
    final uri = Uri.parse(finalUrl);
    
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        Get.snackbar(AppStrings.error, 'Could not launch download link');
      }
    } catch (e) {
      Get.snackbar(AppStrings.error, 'Could not launch download link');
    }
  }

  void _handleShare(dynamic build) {
    final String shareMessage = AppStrings.shareMessageTemplate
        .replaceAll('{env}', BuildEnvironment.fromString(build.environment).displayName)
        .replaceAll('{app}', build.projectName)
        .replaceAll('{version}', build.version)
        .replaceAll('{url}', build.downloadUrl);
        
    SharePlus.instance.share(ShareParams(text: shareMessage));
  }

  Widget _buildEmptyState(BuildContext context, AppThemeExtension theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.dashboard_customize_rounded,
                size: 64,
                color: theme.primaryIconColor,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              AppStrings.welcomeTitle,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              AppStrings.welcomeDesc,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  final settingsController = Get.find<SettingsController>();
                  AddAccountSheet.show(context, settingsController);
                },
                icon: const Icon(Icons.add_circle_outline, size: 24),
                label: const Text(
                  AppStrings.getStarted,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
