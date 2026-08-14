import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_style.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorStyle.scaffoldBackgroundColor,
      body: Center(child: Text("Ranking Screen"),),
    );
  }
}
