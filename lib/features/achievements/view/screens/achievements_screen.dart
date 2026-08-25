import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/acheivements_cubit.dart';
import '../../view_model/achievement_state.dart';
import '../widgets/bade_card_item.dart';
import '../widgets/header_card.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title:  Text(
          'Achievements',
          style: Theme.of(context).textTheme.headlineLarge
        ),
      ),
      body: BlocBuilder<AchievementsCubit, AchievementsState>(
        builder: (context, state) {
          final cubit = context.read<AchievementsCubit>();

          if (state is AchievementsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final currentBadges =
              state is AchievementsUpdated ? state.badges : cubit.badges;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AchievementsHeaderCard(
                  unlockedCount: cubit.unlockedCount,
                  totalCount: cubit.totalCount,
                  progress: cubit.overallProgress,
                ),
                const SizedBox(height: 24),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: currentBadges.length,
                  itemBuilder: (context, index) {
                    return BadgeCardItem(badge: currentBadges[index]);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
