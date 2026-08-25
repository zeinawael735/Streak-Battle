import 'package:flutter/material.dart';
import '../../view_model/badge_model.dart';

class BadgeCardItem extends StatelessWidget {
  final BadgeModel badge;

  const BadgeCardItem({Key? key, required this.badge}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF191724),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: badge.isUnlocked ? Colors.greenAccent : Colors.white12,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            badge.icon,
            size: 36,
            color: badge.isUnlocked ? Colors.amber : Colors.grey,
          ),
          const SizedBox(height: 8),

          Text(
            badge.title,
            style: TextStyle(
              color: badge.isUnlocked ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),

          badge.isUnlocked
              ? const Text(
                  'Unlocked',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : const Text(
                  'Locked',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ],
      ),
    );
  }
}
