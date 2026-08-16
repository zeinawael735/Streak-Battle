import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:streak_battle/core/routes/app_routes.dart';
import 'package:streak_battle/features/app_section/view/screens/app_section.dart';
import 'package:streak_battle/features/auth/login/view/screens/login_screen.dart';
import 'package:streak_battle/features/auth/signup/view/screens/signup_screen.dart';
import 'package:streak_battle/features/battle/view/screens/create_battle_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: defaultTargetPlatform == TargetPlatform.android
          ? null
          : DefaultFirebaseOptions.currentPlatform,
    );
  }

  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'auth_token');
  User? currentUser = FirebaseAuth.instance.currentUser;

  String initialRoute = AppRoutes.login;

  if (token != null && token.isNotEmpty && currentUser != null) {
    try {
      await currentUser.reload();
      currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        initialRoute = AppRoutes.appSection;
      } else {
        await storage.deleteAll();
      }
    } on FirebaseAuthException catch (_) {
      await FirebaseAuth.instance.signOut();
      await storage.deleteAll();
      initialRoute = AppRoutes.login;
    } catch (_) {
      await storage.deleteAll();
      initialRoute = AppRoutes.login;
    }
  } else {
    await storage.deleteAll();
    initialRoute = AppRoutes.login;
  }

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