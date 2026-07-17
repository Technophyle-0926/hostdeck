import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostdeck/core/constants/app_enums.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/entities/host_account.dart';
import '../../domain/entities/aggregated_build.dart';
import 'project_controller.dart';

class DashboardController extends GetxController {
  final DashboardRepository _repository = Get.find<DashboardRepository>();

  final Rx<FocusNode> searchFocusNode = Rx<FocusNode>(FocusNode());

  final RxList<HostAccount> accounts = <HostAccount>[].obs;
  final RxList<AggregatedBuild> builds = <AggregatedBuild>[].obs;

  final RxString searchQuery = ''.obs;
  final RxList<BuildPlatform> selectedPlatforms = <BuildPlatform>[].obs;
  final RxList<int> selectedHostAccounts = <int>[].obs;
  final RxList<String> selectedProjects = <String>[].obs;

  final RxBool isLoading = true.obs;
  final RxBool isWarningDismissed = false.obs;
  final RxBool isInitialLoading = true.obs;
  
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    _fetchData();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  Future<void> _fetchData() async {
    isLoading.value = true;
    await _subscription?.cancel();
    _subscription = _repository.getDashboardData().listen((data) {
      accounts.assignAll(data['accounts'] as List<HostAccount>);
      builds.assignAll(data['builds'] as List<AggregatedBuild>);
      if (data['isFromCache'] == false) {
        isLoading.value = false;
        isInitialLoading.value = false;
      }
    }, onError: (e) {
      isLoading.value = false;
      isInitialLoading.value = false;
      Get.log('Dashboard stream error: $e');
    });
  }

  Future<void> refreshAllAccounts() async {
    await _fetchData();
  }

  // Computed reactive variable for accounts needing cleanup
  List<HostAccount> get criticalAccounts {
    return accounts.where((account) => account.isCapacityCritical()).toList();
  }

  // Get a unique list of available projects based on the currently loaded builds
  List<Map<String, String>> get availableProjects {
    final map = <String, String>{};
    final projectCtrl = Get.put(ProjectController()); // Ensure it exists and track it

    for (var b in builds) {
      if (b.projectId.isNotEmpty) {
        final actualProject = projectCtrl.projects.firstWhereOrNull((p) => p.id == b.projectId);
        map[b.projectId] = actualProject?.name ?? b.projectName;
      }
    }
    return map.entries.map((e) => {'id': e.key, 'name': e.value}).toList();
  }

  // Group builds by project name, sorting the latest to the top
  List<List<AggregatedBuild>> get groupedBuilds {
    final map = <String, List<AggregatedBuild>>{};

    final search = searchQuery.value.toLowerCase();

    for (var build in builds) {
      if(searchQuery.isNotEmpty && !build.projectName.toLowerCase().contains(search) && !build.version.toLowerCase().contains(search)) {
        continue;
      }

      if (selectedPlatforms.isNotEmpty) {
        final currentPlatform = BuildPlatform.fromString(build.platform);
        if (!selectedPlatforms.contains(currentPlatform)) {
          continue;
        }
      }

      if(selectedHostAccounts.isNotEmpty && !selectedHostAccounts.contains(build.hostAccountId)) {
        continue;
      }

      if (selectedProjects.isNotEmpty && !selectedProjects.contains(build.projectId)) {
        continue;
      }

      final key = build.projectName;
      if (!map.containsKey(key)) {
        map[key] = [];
      }
      map[key]!.add(build);
    }
    
    // Sort each group so newest upload is first
    for (var group in map.values) {
      group.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
    }
    
    final groupsList = map.values.toList();
    // Sort the overall list of groups so groups with the newest builds appear first
    groupsList.sort((a, b) => b.first.uploadDate.compareTo(a.first.uploadDate));
    
    return groupsList;
  }
}
