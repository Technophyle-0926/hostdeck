import 'package:get/get.dart';
import '../presentation/screens/dashboard_screen.dart';
import '../presentation/screens/settings_screen.dart';
import '../presentation/bindings/dashboard_binding.dart';

abstract class Routes {
  static const dashboard = '/dashboard';
  static const settings = '/settings';
}

class AppPages {
  static const initial = Routes.dashboard;

  static final routes = [
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsScreen(),
    ),
  ];
}
