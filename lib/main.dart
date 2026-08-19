import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:streak_battle/core/routes/app_routes.dart';
import 'package:streak_battle/features/app_section/view/screens/app_section.dart';
import 'package:streak_battle/features/auth/login/view/screens/login_screen.dart';
import 'package:streak_battle/features/auth/signup/view/screens/signup_screen.dart';
import 'package:streak_battle/features/battle/view/screens/create_battle_screen.dart';

import 'core/helper/auth_helper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  if (Firebase.apps.isEmpty) {
      options: defaultTargetPlatform == TargetPlatform.android
          ? null
          : DefaultFirebaseOptions.currentPlatform;
  final String initialRoute = await AuthHelper.getInitialRoute();

  runApp(BattleStreakApp(initialRoute: initialRoute));
}}

class BattleStreakApp extends StatelessWidget {
  final String initialRoute;

  const BattleStreakApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Streak Battle',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF131313),
      ),
      initialRoute: initialRoute,
      routes: {
        AppRoutes.appSection: (context) => const AppSection(),
        AppRoutes.createBattle: (context) => const CreateBattleScreen(),
        AppRoutes.signUp: (context) => const SignupScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
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
