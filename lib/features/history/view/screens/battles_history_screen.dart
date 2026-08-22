import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_battle/core/theme/theme.dart';
import 'package:streak_battle/features/history/view/widgets/history_battle_card.dart';

import '../../../../core/constants/app_color_style.dart';
import '../../../../core/helper/get_category_icon_helper.dart';
import '../../view_model/history_cubit.dart';
import '../../view_model/history_state.dart';

class BattlesScreen extends StatelessWidget {
  const BattlesScreen({super.key});
  static const Map<String, IconData> categories = {
    'Fitness': Icons.directions_run,
    'Learning': Icons.menu_book,
    'Wellness': Icons.self_improvement,
    'Nutrition': Icons.apple,
    'Coding': Icons.code,
    'Custom': Icons.edit,
  };
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HistoryCubit()..fetchUserBattles(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          scrolledUnderElevation: 0,
          title: Text(
            "Battles history",
            style: Theme.of(context).textTheme.displayLarge
          ),
        ),
        body: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return  Center(
                child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
              );
            }

            if (state is HistoryError) {
              return Center(
                child: Text(
                  state.message,
                  style: Theme.of(context).textTheme.labelLarge
                ),
              );
            }

            if (state is HistorySuccess) {
              if (state.battles.isEmpty) {
                return Center(
                  child: Text(
                    "No battles found",
                    style: Theme.of(context).textTheme.bodyLarge
                  ),
                );
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.battles.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final battleData = state.battles[index];

                          return HistoryBattleCard(
                            battleId: battleData['id'],
                            title: battleData['title'],
                            duration: battleData['duration'],
                            symbol: getCategoryIcon(battleData['category']),
                            progress: battleData['progress'],
                            rank: battleData['rank'],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}