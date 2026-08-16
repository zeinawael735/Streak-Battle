import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:streak_battle/core/routes/app_routes.dart';
import 'package:streak_battle/features/app_section/view/screens/app_section.dart';
import 'package:streak_battle/features/battle/view/screens/create_battle_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: defaultTargetPlatform == TargetPlatform.android
          ? null
          : DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const BattleStreakApp());
}

class BattleStreakApp extends StatelessWidget {
  const BattleStreakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Streak Battle',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF131313),
      ),
      initialRoute: AppRoutes.appSection,
      routes: {
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