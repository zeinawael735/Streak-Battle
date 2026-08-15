import 'package:flutter/material.dart';
import '../../../../core/constants/app_color_style.dart';
import '../../../history/view/widgets/custom_stepper.dart';
class CreateBattleScreen extends StatelessWidget {
  const CreateBattleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorStyle.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColorStyle.backgroundColor,
        title: const Text(
          'Create Battle',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          CustomStepperHeader(currentStep: 0),
        ],
      )
    );
  }
}