import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';

class SettingsService {
  late SharedPreferences _prefs;
  
  static const int _defaultThemeMode = 0; // 0 = System, 1 = Light, 2 = Dark

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int getThemeMode() {
    return _prefs.getInt(PrefsKeys.themeMode) ?? _defaultThemeMode;
  }

  Future<void> setThemeMode(int value) async {
    await _prefs.setInt(PrefsKeys.themeMode, value);
  }
}
