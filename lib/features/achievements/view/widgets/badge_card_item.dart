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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            badge.icon,
            color: badge.isUnlocked ? Colors.amber : Colors.white38,
            size: 32,
          ),
          const SizedBox(height: 10),
          Text(
            badge.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          badge.isUnlocked
              ? const Text(
                  'Unlocked',
                  style: TextStyle(
                    color: Color(0xFF00E676),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: badge.progress,
                    backgroundColor: Colors.white10,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.purpleAccent,
                    ),
                    minHeight: 4,
                  ),
                ),
        ],
      ),
    );
  }
}
