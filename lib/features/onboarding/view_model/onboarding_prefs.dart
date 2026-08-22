import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPrefs {
  static const String _keyIsFirstTime = 'isFirstTime';

  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_keyIsFirstTime) ?? true;
  }

  static Future<void> setNotFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsFirstTime, false);
  }
}
