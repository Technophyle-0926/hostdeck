import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostdeck/presentation/controllers/auth_controller.dart';
import 'package:hostdeck/domain/entities/app_user.dart';
import 'package:hostdeck/presentation/widgets/filter_bottom_sheet.dart';
import 'package:hostdeck/presentation/widgets/shimmer_loading.dart';
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
        Get.find<SettingsController>()
            .themeMode
            .value; // Force rebuild on theme change
        final customTheme = Theme.of(context).extension<AppThemeExtension>()!;
        if (controller.isInitialLoading.value) {
          return const DashboardShimmerLoading();
        }

        final isAdmin = Get.find<AuthController>().appUser.value?.role == UserRole.admin;

        if (!controller.isLoading.value) {
          if (isAdmin && controller.accounts.isEmpty) {
            return _buildEmptyState(context, customTheme);
          } else if (!isAdmin && controller.groupedBuilds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_off, size: 64, color: Colors.grey.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  const Text('No builds assigned yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 8),
                  const Text('An admin needs to assign projects to your account.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
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
                    _buildSearchBar(context),
                    _buildWarningBanner(customTheme),
                    const SizedBox(height: 16),
                    if (isAdmin) ...[
                      _buildAccountOverviews(customTheme),
                      const SizedBox(height: 24),
                    ],
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
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
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

        final androidBuilds = group
            .where(
              (b) =>
                  BuildPlatform.fromString(b.platform) == BuildPlatform.android,
            )
            .toList();
        final iosBuilds = group
            .where(
              (b) => BuildPlatform.fromString(b.platform) == BuildPlatform.ios,
            )
            .toList();

        final androidVersion = androidBuilds.isNotEmpty
            ? 'Android v${androidBuilds.first.version}'
            : '';
        final iosVersion = iosBuilds.isNotEmpty
            ? 'iOS v${iosBuilds.first.version}'
            : '';
        final versionText = [
          androidVersion,
          iosVersion,
        ].where((v) => v.isNotEmpty).join('\n');

        Widget appIcon;
        if (latestBuild.appIconUrl.isNotEmpty) {
          appIcon = ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              latestBuild.appIconUrl,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: customTheme.iconBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.rocket_launch,
                    color: customTheme.primaryIconColor,
                  ),
                );
              },
            ),
          );
        } else {
          appIcon = Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: customTheme.iconBackgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.rocket_launch,
              color: customTheme.primaryIconColor,
            ),
          );
        }

        final mainCard = Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appIcon,
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
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
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
                              versionText,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              DateFormatterUtils.formatBuildDate(
                                latestBuild.uploadDate,
                              ),
                              style: const TextStyle(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      if (latestBuild.downloadUrl.isNotEmpty) ...[
                        IconButton(
                          icon: const Icon(Icons.download, size: 20),
                          onPressed: () =>
                              _handleDownload(latestBuild.downloadUrl),
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

        int tabIndex = 0;
        if (controller.selectedPlatforms.length == 1 &&
            controller.selectedPlatforms.first == BuildPlatform.ios) {
          tabIndex = 1;
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              title: mainCard,
              children: [
                _BuildHistoryTabs(
                  androidBuilds: androidBuilds,
                  iosBuilds: iosBuilds,
                  initialIndex: tabIndex,
                ),
              ],
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
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        Get.snackbar(AppStrings.error, 'Could not launch download link');
      }
    } catch (e) {
      Get.snackbar(AppStrings.error, 'Could not launch download link');
    }
  }

  void _handleShare(dynamic build) {
    final String shareMessage = AppStrings.shareMessageTemplate
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
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              AppStrings.welcomeDesc,
              style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
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

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: controller.searchFocusNode.value,
              onTapOutside: (event) =>
                  controller.searchFocusNode.value.unfocus(),
              onEditingComplete: () =>
                  controller.searchFocusNode.value.unfocus(),
              onChanged: (value) => controller.searchQuery.value = value,
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Obx(
                () => Badge(
                  isLabelVisible:
                      controller.selectedPlatforms.isNotEmpty ||
                      controller.selectedHostAccounts.isNotEmpty,
                  child: const Icon(Icons.filter_list),
                ),
              ),
              onPressed: () => FilterBottomSheet.show(context, controller),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildHistoryTabs extends StatefulWidget {
  final List<AggregatedBuild> androidBuilds;
  final List<AggregatedBuild> iosBuilds;
  final int initialIndex;

  const _BuildHistoryTabs({
    required this.androidBuilds,
    required this.iosBuilds,
    this.initialIndex = 0,
  });

  @override
  State<_BuildHistoryTabs> createState() => _BuildHistoryTabsState();
}

class _BuildHistoryTabsState extends State<_BuildHistoryTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {}); // Re-render the list below
      }
    });
  }

  @override
  void didUpdateWidget(covariant _BuildHistoryTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      _tabController.animateTo(widget.initialIndex);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeBuilds = _tabController.index == 0
        ? widget.androidBuilds
        : widget.iosBuilds;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'Android'),
            Tab(text: 'iOS'),
          ],
        ),
        if (activeBuilds.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                'No builds available',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ...activeBuilds.asMap().entries.map((entry) {
            final index = entry.key;
            final oldBuild = entry.value;
            final isActive = index == 0;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(
                      context,
                    ).dividerColor.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 48), // Indent
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
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.green.withValues(alpha: 0.1)
                                    : Colors.grey.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: isActive
                                      ? Colors.green.withValues(alpha: 0.5)
                                      : Colors.grey.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Text(
                                isActive ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isActive ? Colors.green : Colors.grey,
                                ),
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
                                DateFormatterUtils.formatBuildDate(
                                  oldBuild.uploadDate,
                                ),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
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
          }),
      ],
    );
  }
}
