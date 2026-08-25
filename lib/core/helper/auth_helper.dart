import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:streak_battle/core/routes/app_routes.dart';

// ضيف مسار ملف الـ OnboardingPrefs هنا بناءً على مكانه في مشروعك
import '../../features/onboarding/view_model/onboarding_prefs.dart';

class AuthHelper {
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  static Future<void> saveUserData({required User user}) async {
    await storage.write(key: 'user_id', value: user.uid);
    await storage.write(key: 'user_email', value: user.email);

    String? token = await user.getIdToken();
    if (token != null) {
      await storage.write(key: 'auth_token', value: token);
    }
  }

  static Future<void> clearSession() async {
    await FirebaseAuth.instance.signOut();
    await storage.deleteAll();
  }

  static Future<String> getInitialRoute() async {
    bool isFirstTime = await OnboardingPrefs.isFirstTime();

    if (isFirstTime) {
      return AppRoutes.onboarding;
    }

    // 2. باقي الكود زي ما هو بالظبط
    String? token = await storage.read(key: 'auth_token');
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (token == null || token.isEmpty || currentUser == null) {
      await clearSession();
      return AppRoutes.login;
    }

    try {
      await currentUser.reload();
      currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        return AppRoutes.appSection;
      } else {
        await clearSession();
        return AppRoutes.login;
      }
    } catch (_) {
      await clearSession();
      return AppRoutes.login;
    }
  }
}