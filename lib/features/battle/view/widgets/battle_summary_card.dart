import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_color_style.dart';

class BattleSummaryCard extends StatelessWidget {
  const BattleSummaryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.duration,
    required this.goal,
    required this.startDate,
  });

  final String icon;
  final String title;
  final String duration;
  final String goal;
  final String startDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColorStyle.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Row(
        children: [

          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: AppColorStyle.primaryViolet.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                width: 25,
                height: 25,
              ),
            ),
          ),
          const SizedBox(width: 15),


          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),


                Text(
                  "$duration • $goal",
                  style: TextStyle(
                    color: AppColorStyle.primaryText,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),


                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    startDate,
                    style: TextStyle(
                      color: AppColorStyle.primaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}