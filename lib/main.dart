import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:streak_battle/features/battle/view/screens/battle_details_screen.dart';

import 'core/helper/auth_helper.dart';
import 'core/routes/app_routes.dart';
import 'features/app_section/view/screens/app_section.dart';
import 'features/auth/login/view/screens/login_screen.dart';
import 'features/auth/signup/view/screens/signup_screen.dart';
import 'features/battle/view/screens/create_battle_screen.dart';
import 'firebase_options.dart';
import 'features/notification/view_model/notification_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  final String initialRoute = await AuthHelper.getInitialRoute();

  runApp(BattleStreakApp(initialRoute: initialRoute));
}

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
        AppRoutes.battleDetails: (context) => const BattleDetailsScreen(),
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