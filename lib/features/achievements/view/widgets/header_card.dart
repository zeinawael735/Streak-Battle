import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_style.dart';
import '../../../../core/theme/theme.dart';

class AchievementsHeaderCard extends StatelessWidget {
  final int unlockedCount;
  final int totalCount;
  final double progress;

  const AchievementsHeaderCard({
    Key? key,
    required this.unlockedCount,
    required this.totalCount,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient:  isDark?LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF2E1065)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ):LinearGradient(
          colors: [
            Color(0xFF7C16FF), // لون الـ Primary بتاعك
            Color(0xFFC77DFF), // لون الـ Violet Focus
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark? Colors.blueAccent.withOpacity(0.2):Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.amber,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$unlockedCount of $totalCount unlocked',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
           Text(
            'You are halfway to Badge Master',
            style: TextStyle(color: isDark? Colors.white60:Colors.white.withOpacity(0.8), fontSize: 13),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: isDark? Colors.white.withOpacity(0.1):Colors.black.withOpacity(0.2),
              valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFF00FF87)),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
