import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:streak_battle/core/theme/theme.dart';
import 'package:streak_battle/features/onboarding/view_model/onboarding_prefs.dart';
import 'features/onboarding/view/screens/onboarding.dart';
import 'firebase_options.dart';

import 'package:streak_battle/core/routes/app_routes.dart';
import 'package:streak_battle/features/app_section/view/screens/app_section.dart';
import 'package:streak_battle/features/battle/view/screens/create_battle_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isFirstTime = await OnboardingPrefs.isFirstTime();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: defaultTargetPlatform == TargetPlatform.android
          ? null
          : DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(BattleStreakApp(isFirstTime: isFirstTime));
}

class BattleStreakApp extends StatelessWidget {
  final bool isFirstTime;
  const BattleStreakApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Streak Battle',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      initialRoute: isFirstTime ? '/onboarding' : AppRoutes.appSection,

      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        AppRoutes.appSection: (context) => const AppSection(),
        AppRoutes.createBattle: (context) => const CreateBattleScreen(),
      },

      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text(
                'Page not found',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
