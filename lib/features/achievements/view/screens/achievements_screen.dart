import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/acheivements_cubit.dart';
import '../cubit/achievement_state.dart';
import '../widgets/bade_card_item.dart';
import '../widgets/header_card.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AchievementsCubit(),
      child: Builder(
        builder: (context) {
          context.read<AchievementsCubit>().loadBadges(context);

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                'Achievements',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.white70),
                  onPressed: () {},
                ),
              ],
            ),
            body: BlocBuilder<AchievementsCubit, AchievementsState>(
              builder: (context, state) {
                final cubit = context.read<AchievementsCubit>();

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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.3,
                            ),
                        itemCount: cubit.badges.length,
                        itemBuilder: (context, index) {
                          return BadgeCardItem(badge: cubit.badges[index]);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
