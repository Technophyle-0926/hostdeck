import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/datasources/local/settings_service.dart';
import '../../data/datasources/local/database_service.dart';
import '../../data/datasources/local/secure_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/host_account.dart';
import '../controllers/dashboard_controller.dart';
import '../../data/datasources/remote/api_client.dart';

import 'package:local_auth/local_auth.dart';

class SettingsController extends GetxController {
  final SettingsService _settingsService = Get.find<SettingsService>();
  final _databaseService = Get.find<DatabaseService>();
  final _authRepository = Get.find<AuthRepository>();
  final _secureStorageService = Get.find<SecureStorageService>();

  final themeMode = 0.obs; // 0=system, 1=light, 2=dark
  final accounts = <HostAccount>[].obs;
  final isAddingAccount = false.obs;

  @override
  void onInit() {
    super.onInit();
    themeMode.value = _settingsService.getThemeMode();
    _applyTheme();
    _loadAccounts();
  }

  void updateThemeMode(int newMode) {
    themeMode.value = newMode;
    _settingsService.setThemeMode(newMode);
    _applyTheme();
  }

  void _applyTheme() {
    ThemeMode mode;
    switch (themeMode.value) {
      case 1:
        mode = ThemeMode.light;
        break;
      case 2:
        mode = ThemeMode.dark;
        break;
      default:
        mode = ThemeMode.system;
    }
    Get.changeThemeMode(mode);
  }

  Future<void> _loadAccounts() async {
    accounts.value = await _databaseService.getHostAccounts();
  }

  Future<bool> addAccount(String name, String email, String password) async {
    isAddingAccount.value = true;
    try {
      final authData = await _authRepository.authenticateAccount(email, password);
      final idToken = authData['idToken'] as String;
      final localId = authData['localId'] as String;
      
      // 2. Save securely
      await _secureStorageService.savePassword(email, password);
      
      final currentAccounts = await _databaseService.getHostAccounts();
      if (currentAccounts.any((a) => a.email == email)) {
        isAddingAccount.value = false;
        Get.snackbar('Error', 'An account with this email already exists.', snackPosition: SnackPosition.BOTTOM);
        return false;
      }
      
      // Fetch real capacity data to avoid dummy defaults
      final apiClient = Get.find<ApiClient>();
      final profileDoc = await apiClient.fetchAccountProfile(localId, idToken);
      int maxApps = 5;
      if (profileDoc.containsKey('fields')) {
        final fields = profileDoc['fields'] as Map<String, dynamic>;
        for (var key in ['max_apps', 'max_apps_limit', 'limit', 'plan_limit', 'app_limit']) {
          if (fields.containsKey(key)) {
            final field = fields[key];
            if (field.containsKey('integerValue')) {
              maxApps = int.tryParse(field['integerValue'].toString()) ?? maxApps;
              break;
            }
          }
        }
      }
      final appDocs = await apiClient.fetchAppsForAccount(localId, idToken);

      // 3. Save to database
      final newAccount = HostAccount(
        id: 0,
        accountName: name,
        email: email,
        maxAppsLimit: maxApps,
        appsCount: appDocs.length,
      );
      
      currentAccounts.add(newAccount);
      await _databaseService.saveHostAccounts(currentAccounts);
      
      await _loadAccounts();
      
      // Refresh dashboard
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().refreshAllAccounts();
      }
      
      isAddingAccount.value = false;
      return true;
    } catch (e) {
      isAddingAccount.value = false;
      Get.snackbar('Authentication Failed', e.toString(), snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<bool> updateAccount(HostAccount oldAccount, String name, String email, String password) async {
    isAddingAccount.value = true;
    try {
      final authData = await _authRepository.authenticateAccount(email, password);
      final idToken = authData['idToken'] as String;
      final localId = authData['localId'] as String;
      
      if (oldAccount.email != email) {
        await _secureStorageService.deletePassword(oldAccount.email);
      }
      await _secureStorageService.savePassword(email, password);
      
      final apiClient = Get.find<ApiClient>();
      final profileDoc = await apiClient.fetchAccountProfile(localId, idToken);
      int maxApps = 5;
      if (profileDoc.containsKey('fields')) {
        final fields = profileDoc['fields'] as Map<String, dynamic>;
        for (var key in ['max_apps', 'max_apps_limit', 'limit', 'plan_limit', 'app_limit']) {
          if (fields.containsKey(key)) {
            final field = fields[key];
            if (field.containsKey('integerValue')) {
              maxApps = int.tryParse(field['integerValue'].toString()) ?? maxApps;
              break;
            }
          }
        }
      }
      final appDocs = await apiClient.fetchAppsForAccount(localId, idToken);

      final currentAccounts = await _databaseService.getHostAccounts();
      if (oldAccount.email != email && currentAccounts.any((a) => a.email == email)) {
        isAddingAccount.value = false;
        Get.snackbar('Error', 'An account with this email already exists.', snackPosition: SnackPosition.BOTTOM);
        return false;
      }
      
      final index = currentAccounts.indexWhere((a) => a.id == oldAccount.id);
      
      if (index != -1) {
        currentAccounts[index] = HostAccount(
          id: oldAccount.id,
          accountName: name,
          email: email,
          maxAppsLimit: maxApps,
          appsCount: appDocs.length,
        );
        await _databaseService.saveHostAccounts(currentAccounts);
      }
      
      await _loadAccounts();
      
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().refreshAllAccounts();
      }
      
      isAddingAccount.value = false;
      return true;
    } catch (e) {
      isAddingAccount.value = false;
      Get.snackbar('Authentication Failed', e.toString(), snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<void> removeAccount(HostAccount account) async {
    await _secureStorageService.deletePassword(account.email);
    final currentAccounts = await _databaseService.getHostAccounts();
    currentAccounts.removeWhere((a) => a.id == account.id);
    await _databaseService.saveHostAccounts(currentAccounts);
    await _loadAccounts();
    
    // Refresh dashboard
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().refreshAllAccounts();
    }
  }

  Future<String?> getPassword(String email) async {
    return await _secureStorageService.getPassword(email);
  }

  Future<String?> retrievePassword(String email) async {
    final auth = LocalAuthentication();
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
      
      if (!canAuthenticate) {
        Get.snackbar('Error', 'Authentication not supported on this device');
        return null;
      }
      
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Authenticate to access your password',
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
      
      if (didAuthenticate) {
        return await _secureStorageService.getPassword(email);
      }
    } catch (e) {
      Get.snackbar('Authentication Failed', e.toString());
    }
    return null;
  }
}
