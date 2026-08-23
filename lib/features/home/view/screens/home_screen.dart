import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:streak_battle/core/constants/app_assets.dart';
import 'package:streak_battle/core/theme/theme.dart';
import 'package:streak_battle/features/home/view/widgets/Next_up_card.dart';
import 'package:streak_battle/features/home/view/widgets/active_battles_card.dart';
import 'package:streak_battle/features/home/view/widgets/home_card.dart';
import '../../../../core/helper/get_category_icon_helper.dart';
import '../../../../core/routes/app_routes.dart';
import '../../view_model/home_cubit.dart';
import '../../view_model/home_state.dart';
import '../widgets/weekly_days_row.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..loadHomeData(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading || state is HomeInitial) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (state is HomeError) {
                return Center(
                  child: Text(
                    "Error: ${state.message}",
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              if (state is HomeLoaded) {
                final activeBattlesToShow = state.showAllBattles
                    ? state.activeBattles
                    : state.activeBattles.take(2).toList();

                final nextUpBattlesToShow = state.showAllNextUpBattles
                    ? state.nextUpBattles
                    : state.nextUpBattles.take(2).toList();

                int completedCount = state.completedDays.where((e) => e).length;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                  style: Theme.of(context).textTheme.headlineMedium
                                ),
                                Text(
                                  state.userName,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: .bold,fontSize: 22)
                                ),
                              ],
                            ),
                            CircleAvatar(
                              backgroundColor: AppColors.primary,
                              radius: 23,
                              child: Text(
                                state.initials,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),

                        // second row (Streak & Points)
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
                                      crossAxisAlignment: .start,
                                      spacing: 4,
                                      children: [
                                        SvgPicture.asset(
                                          AppAssets.fireIconSvg,
                                          width: 27,
                                          height: 27,
                                        ),
                                        Text(
                                          "${state.currentStreak} days",
                                          style: Theme.of(context).textTheme.headlineLarge
                                        ),
                                         Text(
                                          "Current streak",
                                          style: Theme.of(context).textTheme.bodySmall
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
                                      spacing: 3,
                                      crossAxisAlignment: .start,
                                      children: [
                                        const Text(
                                          "⭐",
                                          style: TextStyle(fontSize: 25),
                                        ),
                                        Text(
                                          "${state.totalPoints}",
                                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22)
                                        ),
                                         Text(
                                          "Total points",
                                          style: Theme.of(context).textTheme.bodySmall
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),

                        // third row (This Week)
                        SizedBox(
                          height: 170,
                          child: Row(
                            children: [
                              Expanded(
                                child: HomeCard(
                                  child: Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                             Text(
                                              "This week",
                                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: .normal),
                                            ),
                                            Text(
                                              "$completedCount/7 Days",
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14)
                                            ),
                                          ],
                                        ),
                                        WeeklyDaysRow(
                                          completedDays: state.completedDays,
                                          currentDayIndex:
                                          state.currentDayIndex,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),

                        // fourth row (Active Battles Header)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text(
                              "Active Battles",
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 25)
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.joinBattle,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: AppColors.textPrimary,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
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
                        const SizedBox(height: 15),

                        // fifth row (Active Battles List)
                        if (state.activeBattles.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                "You haven't joined any battles yet.",
                                style: Theme.of(context).textTheme.bodySmall
                              ),
                            ),
                          )
                        else
                          Column(
                            spacing: 15,
                            children: activeBattlesToShow.map((battle) {
                              return ActiveBattlesCard(
                                battleId: battle['id'],
                                icon: getCategoryIcon(battle['category']),
                                title: battle['title'],
                                category: battle['category'],
                                goal: battle['goal'],
                                progress: battle['progress'],
                                currentDay: battle['currentDay'],
                                durationDays: battle['durationDays'],
                              );
                            }).toList(),
                          ),

                        // Show More / Show Less Button for Active Battles
                        if (state.activeBattles.length > 2)
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () => context
                                  .read<HomeCubit>()
                                  .toggleShowAllBattles(),
                              child: Text(
                                state.showAllBattles
                                    ? "Show less"
                                    : "Show more",
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color)
                              ),
                            ),
                          ),

                        const SizedBox(height: 15),

                        // Next Up Section
                        if (state.nextUpBattles.isNotEmpty) ...[
                           Text(
                            "Next Up",
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 25)
                          ),
                          const SizedBox(height: 10),
                          Column(
                            spacing: 15,
                            children: nextUpBattlesToShow.map((battle) {
                              return NextUpCard(
                                battleId: battle['id'],
                                icon: getCategoryIcon(battle['category']),
                                goal: battle['goal'],
                                participantsCount: battle['participantsCount'],
                              );
                            }).toList(),
                          ),

                          // Show More / Show Less Button for Next Up
                          if (state.nextUpBattles.length > 2)
                            Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () => context
                                    .read<HomeCubit>()
                                    .toggleShowAllNextUpBattles(),
                                child: Text(
                                  state.showAllNextUpBattles
                                      ? "Show less"
                                      : "Show more",
                                  style:Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color)
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                        ],
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}