import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_battle/core/constants/app_color_style.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../history/view/screens/battles_screen.dart';
import '../../../home/view/screens/home_screen.dart';
import '../../../leaderboard/view/screens/ranking_screen.dart';
import '../../../profile/view/screens/profile_screen.dart';
import '../../view_model/app_section_cubit.dart';
import '../../view_model/app_section_states.dart';
import '../widgets/nav_icon.dart';

class AppSection extends StatelessWidget {
  const AppSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppSectionCubit(),
      child: BlocBuilder<AppSectionCubit, AppSectionState>(
        builder: (context, state) {
          final cubit = context.read<AppSectionCubit>();

          int currentScreenIndex = cubit.currentIndex;
          if (state is AppSectionChangeTabState) {
            currentScreenIndex = state.index;
          }

          return Scaffold(
            backgroundColor: AppColorStyle.backgroundColor,
            body: IndexedStack(
              index: currentScreenIndex,
              children: const [
                HomeScreen(),
                BattlesScreen(),
                RankingScreen(),
                ProfileScreen(),
              ],
            ),
            bottomNavigationBar: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                 BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    type: BottomNavigationBarType.fixed,
                    currentIndex: cubit.getNavIndex(currentScreenIndex),
                    onTap: (value) => cubit.changeTab(value),
                    selectedItemColor: AppColorStyle.primaryGreen,
                    unselectedItemColor: AppColorStyle.inactiveGrey,
                    selectedLabelStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                    items: [
                      BottomNavigationBarItem(
                        icon: NavIcon(
                          path: AppAssets.homeIconSvg,
                          index: 0,
                          currentIndex: currentScreenIndex,
                          label: "Home",
                        ),
                        label: "",
                      ),
                      BottomNavigationBarItem(
                        icon: NavIcon(
                          path: AppAssets.battlesIconSvg,
                          index: 1,
                          currentIndex: currentScreenIndex,
                          label: "Battles",
                        ),
                        label: "",
                      ),
                      const BottomNavigationBarItem(
                        icon: SizedBox.shrink(),
                        label: "",
                      ),
                      BottomNavigationBarItem(
                        icon: NavIcon(
                          path: AppAssets.rankingIconSvg,
                          index: 3,
                          currentIndex: currentScreenIndex,
                          label: "Ranking",
                        ),
                        label: "",
                      ),
                      BottomNavigationBarItem(
                        icon: NavIcon(
                          path: AppAssets.profileIconSvg,
                          index: 4,
                          currentIndex: currentScreenIndex,
                          label: "Account",
                        ),
                        label: "",
                      ),
                    ],
                  ),
                Positioned(
                  top: -10,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.createBattle);
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColorStyle.primaryGreen,
                            Color(0xFF1A8C3A),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColorStyle.primaryGreen.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}