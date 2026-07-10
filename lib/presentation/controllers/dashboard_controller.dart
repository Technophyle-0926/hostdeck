import 'dart:async';
import 'package:get/get.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../domain/entities/host_account.dart';
import '../../domain/entities/aggregated_build.dart';

class DashboardController extends GetxController {
  final DashboardRepository _repository = Get.find<DashboardRepository>();


  final RxList<HostAccount> accounts = <HostAccount>[].obs;
  final RxList<AggregatedBuild> builds = <AggregatedBuild>[].obs;
  
  final RxBool isLoading = true.obs;
  final RxBool isWarningDismissed = false.obs;
  
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
      }
    }, onError: (e) {
      isLoading.value = false;
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

  // Group builds by project name, sorting the latest to the top
  List<List<AggregatedBuild>> get groupedBuilds {
    final map = <String, List<AggregatedBuild>>{};
    for (var build in builds) {
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
