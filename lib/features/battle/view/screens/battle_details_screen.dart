import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:streak_battle/core/constants/app_assets.dart';
import 'package:streak_battle/core/constants/app_color_style.dart';
import 'package:streak_battle/features/home/view/widgets/home_card.dart';

import '../../../../core/helper/get_category_icon_helper.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../view_model/battle_details_cubit.dart';
import '../widgets/battle_details_screen_widgets.dart';

class BattleDetailsScreen extends StatelessWidget {
  const BattleDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String battleId = (ModalRoute.of(context)?.settings.arguments as String?) ?? '';

    return BlocProvider(
      create: (context) => BattleDetailsCubit()..loadBattleDetails(battleId),
      child: Scaffold(
        body: BlocBuilder<BattleDetailsCubit, BattleDetailsState>(
          builder: (context, state) {
            if (state is BattleDetailsInitial || state is BattleDetailsLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.purple));
            }

            if (state is BattleDetailsError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.white)));
            }

            if (state is BattleDetailsLoaded) {
              return _buildContent(context, state, battleId);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, BattleDetailsLoaded state, String battleId) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color:  Theme.of(context).colorScheme.tertiaryFixed,
            child: Padding(
              padding: const EdgeInsets.only(top: 35, left: 17, right: 17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon:  Icon(Icons.arrow_back_ios_new, color: Theme.of(context).textTheme.headlineMedium?.color),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),
                      IconButton(
                        onPressed: () async {
                          await Share.share('Join my battle! Use code: ${state.battleCode}');
                        },
                        icon:  Icon(Icons.share, color: Theme.of(context).textTheme.headlineMedium?.color),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerRight,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 55,
                        width: 55,
                        child:  Center(//
                          child: Icon(getCategoryIcon(state.category),size: 33,color: Colors.white,),
                        ),
                      ),
                      Container(
                        width: 85,
                        height: 34,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: AppColorStyle.primaryText, width: 0.15),
                          color: AppColorStyle.primaryViolet,
                        ),
                        child: Center(
                          child: Text(
                            state.isFinished ? "Finished" : "Active",
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: state.isFinished ? Colors.redAccent : AppColorStyle.primaryGreen,)
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.title,
                    style: Theme.of(context).textTheme.headlineLarge
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Day ${state.currentDay} of ${state.durationDays} • ${state.participantsCount} players",
                    style: Theme.of(context).textTheme.bodyMedium // TextStyle(color: Color(0xFFCDC2D9)),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: state.progressValue,
                      minHeight: 6,
                      backgroundColor: AppColors.progressIndicatorBackgroundColor,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          /// Part 2: Body
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 17, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: HomeCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text("TODAY'S GOAL", style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(height: 10),
                          Text(
                            state.goal,
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 23),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Check in before ${state.formattedEndDate}",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)//Color(0xFFCDC2D9)
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3E354F),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(AppAssets.fireIconSvg, width: 15, height: 15),
                                const SizedBox(width: 8),
                                Text(
                                  "${state.myCheckInsCount}-day battle streak",
                                  style: const TextStyle(fontSize: 13, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 47,
                            child: ElevatedButton(
                              onPressed: state.isFinished
                                  ? null
                                  : () => Navigator.pushNamed(context, AppRoutes.checkIn, arguments: battleId),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: state.isFinished ? Colors.grey : AppColors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle, color: state.isFinished ? Colors.white38 : AppColorStyle.primaryGreen),
                                  const SizedBox(width: 8),
                                  Text(
                                    state.isFinished ? "Battle Ended" : "Check in",
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Participants", style: Theme.of(context).textTheme.headlineMedium),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.ranking,
                          arguments: battleId,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: AppColors.textPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 9,
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
                      child: Text("LeaderBoard",style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12),),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    for (final participant in state.participants.take(state.displayCount))
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () => ParticipantsDialog.showParticipant(context, participant),
                          child: ParticipantCircle(initials: participant.initials, size: 50),
                        ),
                      ),
                    if (state.remainingCount > 0)
                      GestureDetector(
                        onTap: () => ParticipantsDialog.showMoreParticipants(context, state.participants.skip(state.displayCount).toList()),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF30283A)),
                          alignment: Alignment.center,
                          child: Text('+${state.remainingCount}', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    "${state.todayCheckIns.length} of ${state.participantsCount} checked in",
                    style: TextStyle(color: AppColorStyle.primaryGreen, fontSize: 15),
                  ),
                ),
                ...state.todayCheckIns.map((checkIn) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: CheckedInCard(
                      name: checkIn.name,
                      initials: checkIn.initials,
                      goal: checkIn.goal,
                      time: checkIn.timeAgo,
                    ),
                  );
                }),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}