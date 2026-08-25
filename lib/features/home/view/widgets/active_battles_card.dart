import 'package:flutter/material.dart';
import 'package:streak_battle/core/theme/theme.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                            color: Theme.of(context).colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 55,
                          width: 55,
                          child: Center(
                            child: Icon(icon, size: 25,color: isDark? Color(0xFFFFBF00):Color(0xFF9368D1),),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.headlineMedium ,
                            ),
                            Text(
                              "$category • Day $currentDay of $durationDays",
                              style: Theme.of(context).textTheme.bodySmall
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.onTertiary,
                        border: Border.all(color: Colors.white.withOpacity(0.05), width: 0.5),
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
                                  Text(goal,style: Theme.of(context).textTheme.bodySmall,),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: progress / 100.0,
                                      minHeight: 6,
                                      backgroundColor: AppColors.progressIndicatorBackgroundColor,
                                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
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
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.battleDetails,
                                    arguments: battleId,
                                  );
                                },
                                icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
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