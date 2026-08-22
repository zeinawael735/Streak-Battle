import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_battle/core/routes/app_routes.dart';
import 'package:streak_battle/core/utils/responsive_helper.dart';
import '../../view_model/profile_cubit.dart';
import '../../view_model/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final secondaryTextColor = textColor.withOpacity(0.5);
    final cardColor = isDark ? const Color(0xFF1C1C1C) : const Color(0xFFF5F5F5);
    final borderColor = textColor.withOpacity(0.08);
    final r = ResponsiveHelper(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(
                child: CircularProgressIndicator(color: theme.colorScheme.secondary),
              );
            }

            if (state is ProfileError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: textColor, fontSize: r.sp(14)),
                ),
              );
            }

            final profile = state as ProfileLoaded;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: r.w(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: r.h(10)),

                  // ================= HEADER =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Text(
                        'Profile',
                        style: TextStyle(
                          color: textColor,
                          fontSize: r.sp(18),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                        child: Icon(Icons.settings_outlined,
                            color: secondaryTextColor, size: r.w(22)),
                      ),
                    ],
                  ),

                  SizedBox(height: r.h(24)),

                  // ================= AVATAR =================
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: r.w(40),
                          backgroundColor: theme.colorScheme.secondary,
                          child: Text(
                            _initials(profile.name),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: r.sp(26),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(r.w(4)),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.edit,
                                size: r.w(12), color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: r.h(12)),

                  Center(
                    child: Text(
                      profile.name,
                      style: TextStyle(
                        color: textColor,
                        fontSize: r.sp(18),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  SizedBox(height: r.h(6)),

                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: r.w(12), vertical: r.h(4)),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(r.w(20)),
                      ),
                      child: Text(
                        profile.rankLabel,
                        style: TextStyle(
                          color: theme.colorScheme.tertiary,
                          fontSize: r.sp(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: r.h(20)),

                  // ================= STATS CARDS =================
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          value: '${profile.battlesCount}',
                          label: 'BATTLES',
                          color: textColor,
                          cardColor: cardColor,
                          borderColor: borderColor,
                          secondaryTextColor: secondaryTextColor,
                          r: r,
                        ),
                      ),
                      SizedBox(width: r.w(10)),
                      Expanded(
                        child: _statCard(
                          value: '${profile.wins}',
                          label: 'WINS',
                          color: theme.colorScheme.tertiary,
                          cardColor: cardColor,
                          borderColor: borderColor,
                          secondaryTextColor: secondaryTextColor,
                          r: r,
                        ),
                      ),
                      SizedBox(width: r.w(10)),
                      Expanded(
                        child: _statCard(
                          value: '${profile.currentStreak}d',
                          label: 'STREAK',
                          color: theme.colorScheme.error,
                          cardColor: cardColor,
                          borderColor: borderColor,
                          secondaryTextColor: secondaryTextColor,
                          r: r,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: r.h(24)),

                  // ================= ACTIVITY CHART =================
                  Text(
                    'Activity',
                    style: TextStyle(
                      color: textColor,
                      fontSize: r.sp(15),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Last 7 days',
                    style: TextStyle(color: secondaryTextColor, fontSize: r.sp(12)),
                  ),

                  SizedBox(height: r.h(12)),

                  SizedBox(
                    height: r.h(110),
                    child: BarChart(
                      BarChartData(
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        barTouchData: BarTouchData(enabled: false),
                        barGroups: List.generate(
                          profile.activityLastWeek.length,
                              (index) => BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: profile.activityLastWeek[index],
                                width: r.w(18),
                                borderRadius: BorderRadius.circular(r.w(4)),
                                color: index % 2 == 0
                                    ? theme.colorScheme.secondary
                                    : theme.colorScheme.tertiary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: r.h(24)),

                  // ================= FAVORITE HABITS =================
                  Text(
                    'Favorite Habits',
                    style: TextStyle(
                      color: textColor,
                      fontSize: r.sp(15),
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: r.h(12)),

                  Wrap(
                    spacing: r.w(8),
                    runSpacing: r.h(8),
                    children: profile.favoriteHabits.isEmpty
                        ? [
                      _habitChip('Fitness', Icons.fitness_center, theme,
                          cardColor, borderColor, r),
                      _habitChip('Learning', Icons.menu_book, theme,
                          cardColor, borderColor, r),
                      _habitChip('Wellness', Icons.spa, theme,
                          cardColor, borderColor, r),
                    ]
                        : profile.favoriteHabits
                        .map((h) => _habitChip(
                        h, Icons.check, theme, cardColor, borderColor, r))
                        .toList(),
                  ),

                  SizedBox(height: r.h(24)),

                  // ================= ACHIEVEMENTS CARD =================
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.achievements),
                    child: Container(
                      padding: EdgeInsets.all(r.w(14)),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(r.w(14)),
                        border: Border.all(color: borderColor),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(r.w(8)),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary
                                  .withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.emoji_events_outlined,
                                color: theme.colorScheme.secondary, size: r.w(20)),
                          ),
                          SizedBox(width: r.w(12)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Achievements',
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: r.sp(14),
                                  ),
                                ),
                                Text(
                                  '${profile.achievementsUnlocked} of ${profile.achievementsTotal} unlocked',
                                  style: TextStyle(
                                    color: secondaryTextColor,
                                    fontSize: r.sp(12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right, color: secondaryTextColor, size: r.w(24)),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: r.h(24)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return (parts.first[0] + parts.last[0]).toUpperCase();
    }
    return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
  }

  Widget _statCard({
    required String value,
    required String label,
    required Color color,
    required Color cardColor,
    required Color borderColor,
    required Color secondaryTextColor,
    required ResponsiveHelper r,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: r.h(14)),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(r.w(12)),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: r.sp(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: r.h(4)),
          Text(
            label,
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: r.sp(10),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _habitChip(String label, IconData icon, ThemeData theme,
      Color cardColor, Color borderColor, ResponsiveHelper r) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.w(12), vertical: r.h(8)),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(r.w(20)),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: r.w(14), color: theme.colorScheme.secondary),
          SizedBox(width: r.w(6)),
          Text(label,
              style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontSize: r.sp(12))),
        ],
      ),
    );
  }
}