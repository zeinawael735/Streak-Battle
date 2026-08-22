import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_battle/features/leaderboard/view/widgets/podium_widget.dart';
import 'package:streak_battle/features/leaderboard/view/widgets/user_rank_tile_widget.dart';
import 'package:streak_battle/features/leaderboard/view_model/leader_board_state.dart';

import '../../../../core/constants/app_color_style.dart';
import '../../view_model/leader_board_cubit.dart';

class RankingScreen extends StatelessWidget {
  RankingScreen({super.key, required this.battleId});
  String battleId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LeaderboardCubit()
            ..fetchLeaderboard(battleId: battleId),
      child: Scaffold(
        backgroundColor: AppColorStyle.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "LeaderBoard",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: BlocBuilder<LeaderboardCubit, LeaderBoardState>(
          builder: (context, state) {
            if (state is LeaderBoardLoading) {
              return Center(
                child: CircularProgressIndicator(color: Colors.purple),
              );
            }

            if (state is LeaderBoardError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 16),
                ),
              );
            }
            if (state is LeaderBoardSuccess) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: PodiumWidget(top3: state.top3),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Rankings",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),

                          Expanded(
                            child: ListView.builder(
                              itemCount: state.remainingUsers.length,
                              itemBuilder: (context, index) {
                                final user = state.remainingUsers[index];
                                return UserRankTile(
                                  rank: "${user.rank}",
                                  name: user.displayName,
                                  checkIns: "${user.currentStreak}",
                                  points: "${user.xp}",
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (state.currentUser != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 16,
                        top: 8,
                      ),
                      child: UserRankTile(
                        rank: "${state.currentUser!.rank}",
                        name: state.currentUser!.displayName,
                        checkIns: "${state.currentUser!.currentStreak}",
                        points: "${state.currentUser!.xp}",
                        isSticky: true,
                      ),
                    ),
                  ],
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
