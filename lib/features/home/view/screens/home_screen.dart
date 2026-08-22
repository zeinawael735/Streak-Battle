import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:streak_battle/core/constants/app_assets.dart';
import 'package:streak_battle/core/constants/app_color_style.dart';
import 'package:streak_battle/core/theme/theme.dart';
import 'package:streak_battle/features/home/view/widgets/Next_up_card.dart';
import 'package:streak_battle/features/home/view/widgets/active_battles_card.dart';
import 'package:streak_battle/features/home/view/widgets/home_card.dart';

import '../../../../core/routes/app_routes.dart';
import '../widgets/weekly_days_row.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // first row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi,",
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          "Alex",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 23,
                      child: Text("AM"),
                    ),
                  ],
                ),
                SizedBox(height: 7),


                // second row
                SizedBox(
                  height: 150,
                  child: Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: HomeCard(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 30,
                              left: 30,
                              top: 25,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.fireIconSvg,
                                  width: 27,
                                  height: 27,
                                ),
                                Text(
                                  "3 days",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Current streak",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: HomeCard(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 25,
                              top: 24,
                              bottom: 24,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("⭐", style: TextStyle(fontSize: 25)),
                                Text("2,450", style: TextStyle(fontSize: 22)),
                                Text(
                                  "Total points",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),

                // third row
                SizedBox(
                  height: 170,
                  child: Row(
                    children: [
                      Expanded(
                        child: HomeCard(
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "This week",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    Text(
                                      "4/7 Days",
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                WeeklyDaysRow(
                                  completedDays: [true, false, false, true, true,true],
                                  currentDayIndex: 6,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),

                // fourth row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Active Battles",
                      style: TextStyle(
                        fontSize: 25,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.joinBattle);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Color(0xFF4B4456),
                            width: 1.5,
                          ),
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text("join"),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                //fifth row
                Column(
                  spacing: 15,
                  children: [
                    ActiveBattlesCard(icon: AppAssets.fitnessIconSvg, title:"Morning Run Club", category: "Fitness", goal: "Run 3 km", progress: 50,),
                    ActiveBattlesCard(icon: AppAssets.bookIconSvg, title: "Studying", category: "learning", goal: "Read 20 pages", progress: 70,)
                  ],
                ),

                SizedBox(height: 15),

                //sixth row
                Text(
                  "Next Up",
                  style: TextStyle(
                    fontSize: 25,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),

                //seventh row
                Column(
                  spacing: 15,
                  children: [
                    NextUpCard(icon: AppAssets.bookIconSvg, goal: "Read 20 pages"),
                    NextUpCard(icon: AppAssets.fitnessIconSvg, goal: "Run 3 km"),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}