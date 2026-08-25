import 'package:flutter/material.dart';
import '../../view_model/onboarding_model.dart';
import 'onboarding_cards.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingModel item;
  final int index;

  const OnboardingPage({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // اختيار الكارت المناسب حسب ترتيب الصفحة
    Widget heroCard;
    if (index == 0) {
      heroCard = const OnboardingCardOne();
    } else if (index == 1) {
      heroCard = const OnboardingCardTwo();
    } else {
      heroCard = const OnboardingCardThree();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Center(child: heroCard),
          ),

          const SizedBox(height: 20),

          Text(
            item.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          Text(
            item.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.white60 : Colors.black54,
              fontSize: 14,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}