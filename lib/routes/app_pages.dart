import 'package:get/get.dart';
import 'package:hostdeck/presentation/screens/login_screen.dart';
import '../presentation/widgets/main_layout.dart';
import '../presentation/screens/scan_qr_screen.dart';
import '../presentation/screens/settings_screen.dart';
import '../presentation/screens/invite_redemption_screen.dart';
import '../presentation/bindings/dashboard_binding.dart';
import '../presentation/screens/share_qr_screen.dart';

abstract class Routes {
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const settings = '/settings';
  static const shareQr = '/share-qr';
  static const scanQr = '/scan-qr';
  static const invite = '/invite';
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
      page: () => const MainLayout(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsScreen(),
    ),
    GetPage(
      name: Routes.shareQr,
      page: () => const ShareQrScreen(),
    ),
    GetPage(
      name: Routes.scanQr,
      page: () => const ScanQrScreen(),
    ),
    GetPage(
      name: Routes.invite,
      page: () => InviteRedemptionScreen(),
    ),
  ];
}
