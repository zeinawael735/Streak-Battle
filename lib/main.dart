import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:streak_battle/core/theme/theme.dart';
import 'package:streak_battle/features/auth/forget_password/view/screens/forget_password_screen.dart';
import 'package:streak_battle/features/battle/view/screens/battle_details_screen.dart';
import 'package:streak_battle/features/gamification/view/screens/daily_check_in_screen.dart';
import 'package:streak_battle/features/leaderboard/view/screens/ranking_screen.dart';

import 'core/helper/auth_helper.dart';
import 'core/routes/app_routes.dart';
import 'features/app_section/view/screens/app_section.dart';
import 'features/auth/login/view/screens/login_screen.dart';
import 'features/auth/signup/view/screens/signup_screen.dart';
import 'features/battle/view/screens/create_battle_screen.dart';
import 'features/settings/view/screens/setting_screen.dart';
import 'features/battle/view/screens/join_battle_screen.dart';
import 'features/notification/view_model/push_notification_service.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  PushNotificationService notificationService = PushNotificationService();
  await notificationService.initialize();

  final String initialRoute = await AuthHelper.getInitialRoute();

  runApp(BattleStreakApp(initialRoute: initialRoute));
}

class BattleStreakApp extends StatelessWidget {
  final String initialRoute;

   BattleStreakApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: PushNotificationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Streak Battle',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: SettingsScreen(),
     // initialRoute: initialRoute,
      routes: {
        AppRoutes.appSection: (context) => const AppSection(),
        AppRoutes.createBattle: (context) => const CreateBattleScreen(),
        AppRoutes.signUp: (context) => const SignupScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.battleDetails: (context) => const BattleDetailsScreen(),
        AppRoutes.joinBattle: (context) => const JoinBattleScreen(),
        AppRoutes.checkIn: (context) => const DailyCheckInScreen(),
        AppRoutes.forgotPassword: (context) => const ForgetPasswordScreen(),
      },

  onGenerateRoute: (settings) {
      if (settings.name == AppRoutes.ranking) {
        final String battleId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => RankingScreen(battleId: battleId),
        );
      }
      return null;
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