import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../../data/repositories/dashboard_repository_impl.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardRepository>(
      () => DashboardRepositoryImpl(Get.find(), Get.find(), Get.find(), Get.find(), Get.find()),
    );
    
    Get.lazyPut<DashboardController>(
      () => DashboardController(),
    );
  }
}
