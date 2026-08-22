import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class GoalCard extends StatelessWidget {
  // ضفنا المتغيرات دي عشان نستقبل الداتا الحقيقية
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
        color: AppColors.indigo, // تأكد إن AppColors موجودة في مسارها الصح
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
                  'assets/images/Margin.png', // لو عندك أيقونة ديناميكية لكل باتل ممكن تباصيها هنا بعدين
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          // عرض الهدف الحقيقي بدل 'Run 3 km'
          Text(
            goal,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // عرض اسم التحدي الحقيقي بدل 'Morning Run Club'
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}