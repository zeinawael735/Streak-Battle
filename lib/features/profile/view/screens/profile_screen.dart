import 'package:flutter/material.dart';
import '../../../../core/constants/app_color_style.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorStyle.scaffoldBackgroundColor,
      body: Center(child: Text("Profile Screen"),),
    );
  }
}
