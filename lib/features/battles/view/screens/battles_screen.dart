import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_style.dart';

class BattlesScreen extends StatelessWidget {
  const BattlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorStyle.scaffoldBackgroundColor,
      body: Center(child: Text("Battles Screen"),),
    );
  }
}
