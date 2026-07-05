import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  late SharedPreferences _prefs;
  
  static const String _themeModeKey = 'theme_mode';
  static const int _defaultThemeMode = 0; // 0 = System, 1 = Light, 2 = Dark

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int getThemeMode() {
    return _prefs.getInt(_themeModeKey) ?? _defaultThemeMode;
  }

  Future<void> setThemeMode(int value) async {
    await _prefs.setInt(_themeModeKey, value);
  }
}
