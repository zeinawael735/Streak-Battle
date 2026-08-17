import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:streak_battle/core/routes/app_routes.dart';
import 'package:streak_battle/features/app_section/view/screens/app_section.dart';
import 'package:streak_battle/features/create_battle/view/screens/create_battle_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      print(' Firebase already initialized');
    } else {
      print(' Firebase init error: $e');
      rethrow;
    }
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
