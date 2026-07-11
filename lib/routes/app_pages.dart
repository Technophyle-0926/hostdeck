import 'package:get/get.dart';
import 'package:hostdeck/presentation/screens/login_screen.dart';
import '../presentation/screens/dashboard_screen.dart';
import '../presentation/screens/settings_screen.dart';
import '../presentation/bindings/dashboard_binding.dart';

abstract class Routes {
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const settings = '/settings';
}

class AppPages {
  static const initial = Routes.login;

  static final routes = [
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
    ),
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
