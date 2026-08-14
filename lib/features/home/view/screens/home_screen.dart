import 'package:flutter/material.dart';
import 'package:streak_battle/core/constants/app_color_style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorStyle.scaffoldBackgroundColor,
      body: Center(child: Text("Home Screen"),),
    );
  }
}
