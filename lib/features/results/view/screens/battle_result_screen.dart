import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_battle/core/theme/theme.dart';
import '../../view_model/battle_result_cubit.dart';
import '../../view_model/battle_result_state.dart';

class BattleResultScreen extends StatelessWidget {
  const BattleResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BattleResultCubit(),
      child: const _BattleResultView(),
    );
  }
}

class _BattleResultView extends StatelessWidget {
  const _BattleResultView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: BlocBuilder<BattleResultCubit, BattleResultState>(
          builder: (context, state) {
            if (state is BattleResultCalculating) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.violetFocus),
              );
            }

            if (state is BattleResultError) {
              return Center(
                child: Text(state.message,
                    style: const TextStyle(color: AppColors.white)),
              );
            }

            final result = state as BattleResultLoaded;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // ================= HEADER =================
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_awesome,
                          color: AppColors.violetFocus, size: 14),
                      SizedBox(width: 8),
                      Text(
                        'BATTLE COMPLETE',
                        style: TextStyle(
                          color: AppColors.violetFocus,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.auto_awesome,
                          color: AppColors.violetFocus, size: 14),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ================= WINNER CIRCLE =================
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.indigo,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.violetFocus.withOpacity(0.35),
                              blurRadius: 30,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: -22,
                        child: Icon(Icons.emoji_events,
                            color: AppColors.warning, size: 34),
                      ),
                      Positioned(
                        bottom: -6,
                        right: 30,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.black, width: 2),
                          ),
                          child: const Center(
                            child: Text('1',
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    '${result.winnerName} wins!',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    result.battleTitle,
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ================= YOUR RESULT CARD =================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.indigo,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColors.success.withOpacity(0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.bar_chart,
                                color: AppColors.success, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              'YOUR RESULT',
                              style: TextStyle(
                                color: AppColors.success,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          result.userRankLabel,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${result.points} points',
                          style: const TextStyle(
                            color: AppColors.violetFocus,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: result.completionPercent,
                            minHeight: 8,
                            backgroundColor: AppColors.black,
                            valueColor: const AlwaysStoppedAnimation(
                                AppColors.success),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${(result.completionPercent * 100).round()}% completion',
                              style: TextStyle(
                                  color: AppColors.success, fontSize: 12),
                            ),
                            Row(
                              children: [
                                Icon(Icons.check_circle_outline,
                                    color: AppColors.white.withOpacity(0.5),
                                    size: 13),
                                const SizedBox(width: 4),
                                Text(
                                  '${result.checkIns} check-ins',
                                  style: TextStyle(
                                      color: AppColors.white.withOpacity(0.5),
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ================= STATS CARDS =================
                  Row(
                    children: [
                      Expanded(
                        child: _statCard(
                          icon: Icons.local_fire_department,
                          iconColor: AppColors.warning,
                          value: '${result.bestStreak} days',
                          label: 'Best streak',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _statCard(
                          icon: Icons.directions_run,
                          iconColor: AppColors.violetFocus,
                          value: '${result.totalDistanceKm} km',
                          label: 'Total distance',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ================= SHARE BUTTON =================
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: implement Share Results (share_plus already in pubspec)
                      },
                      icon: const Icon(Icons.ios_share, size: 18),
                      label: const Text('Share result'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  TextButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: Text(
                      'Back to home',
                      style: TextStyle(
                        color: AppColors.white.withOpacity(0.6),
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.indigo,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  color: AppColors.white.withOpacity(0.5), fontSize: 11)),
        ],
      ),
    );
  }
}