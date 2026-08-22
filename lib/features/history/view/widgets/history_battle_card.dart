import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_battle/core/theme/theme.dart';

import '../../../../core/constants/app_color_style.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../home/view/widgets/home_card.dart';
import '../../view_model/history_cubit.dart';

class HistoryBattleCard extends StatelessWidget {
  const HistoryBattleCard({
    super.key,
    required this.title,
    required this.duration,
    required this.symbol,
    required this.progress,
    required this.rank,
    required this.battleId,
  });

  final String title;
  final String duration;
  final IconData symbol;
  final int progress;
  final int rank;
  final String battleId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(
          context,
          AppRoutes.battleDetails,
          arguments: battleId,
        );

        if (context.mounted) {
          context.read<HistoryCubit>().fetchUserBattles();
        }
      },
      child: HomeCard(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            spacing: 14,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 10,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.circleAvatarIconBackground,
                    child: Icon(
                      symbol,
                      color: AppColors.primaryGreen,
                      size: 30,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: AppColorStyle.primaryText,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        duration,
                        style: TextStyle(
                          color: AppColorStyle.primaryText,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress / 100.0,
                  minHeight: 6,
                  backgroundColor: AppColors.progressIndicatorBackgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.progressIndicatorColor,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "$progress%",
                    style: TextStyle(color: AppColors.primaryGreen),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}