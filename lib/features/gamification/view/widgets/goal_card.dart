import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class GoalCard extends StatelessWidget {
  final String title;
  final String goal;

  const GoalCard({
    super.key,
    required this.title,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onTertiaryContainer,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.tertiaryFixedDim,//Color(0xFF1E0140),
            ),
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,//const Color(0xFF4A0072),
                  border: Border.all(
                    color: const Color(0xFF9100E5),
                    width: 4.5,
                  ),
                ),
                child: Icon(
                  Icons.my_location,
                  size: 50,
                  color: Theme.of(context).textTheme.headlineSmall?.color,
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            goal,
            style: Theme.of(context).textTheme.headlineLarge
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall
          ),
        ],
      ),
    );
  }
}