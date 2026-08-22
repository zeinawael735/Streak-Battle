import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.indigo,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.deepPurple, width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.deepPurple,
              border: Border.all(color: AppColors.purple, width: 2),
            ),
            child: ClipOval(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/images/Margin.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Run 3 km',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Morning Run Club',
            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 15),
          ),
        ],
      ),
    );
  }
}
