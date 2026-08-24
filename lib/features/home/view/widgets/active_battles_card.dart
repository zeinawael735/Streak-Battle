import 'package:flutter/material.dart';
import '../../../../core/constants/app_color_style.dart';
import '../../../../core/routes/app_routes.dart';
import 'home_card.dart';

class ActiveBattlesCard extends StatelessWidget {
  const ActiveBattlesCard({
    super.key,
    required this.icon,
    required this.title,
    required this.category,
    required this.goal,
    required this.progress,
    required this.battleId,
    required this.currentDay,
    required this.durationDays,
  });

  final IconData icon;
  final String title;
  final String category;
  final String goal;
  final int progress;
  final String battleId;
  final int currentDay;
  final int durationDays;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(
            child: HomeCard(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 15,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColorStyle.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 55,
                          width: 55,
                          child: Center(
                            child: Icon(
                              icon,
                              size: 25,
                              color: Color(0xFFD2BBFF),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            Text(
                              "$category • Day $currentDay of $durationDays",
                              style: TextStyle(
                                color: AppColorStyle.primaryText,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColorStyle.scaffoldBackgroundColor,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(goal),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value:
                                          progress /
                                          100.0, // تم التصحيح هنا للقسمة صحيحة
                                      minHeight: 6,
                                      backgroundColor: AppColorStyle
                                          .progressIndicatorBackgroundColor,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColorStyle.progressIndicatorColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: AppColorStyle.primaryViolet,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.battleDetails,
                                    arguments: battleId, // نرسل الـ ID
                                  );
                                },
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
