import 'package:flutter/material.dart';
import 'package:streak_battle/features/history/view/widgets/history_battle_card.dart';

import '../../../../core/constants/app_color_style.dart';

class BattlesScreen extends StatelessWidget {
  const BattlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColorStyle.scaffoldBackgroundColor,scrolledUnderElevation: 0,title: Text("Battles history",style: TextStyle(fontWeight: .bold,fontSize: 33,color: AppColorStyle.primaryText),),),
      backgroundColor: AppColorStyle.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 16,
            crossAxisAlignment: .start,
            children: [
              Text("August 2026",style: TextStyle(fontSize: 20,color: AppColorStyle.primaryText),),
              HistoryBattleCard(
                  title: "Reading sprint",
                  duration: "Jul 10 - Aug 8",
                  symbol: Icons.book_outlined,
                  progress: 94,
                  rank: 1
              ),
              HistoryBattleCard(
                  title: "Hydration Crew",
                  duration: "Jul 1 - Jul 21",
                  symbol: Icons.water_drop_outlined,
                  progress: 86,
                  rank: 3
              ),
              HistoryBattleCard(
                  title: "Morning Yoga",
                  duration: "Jun 3 - Jun 24",
                  symbol: Icons.self_improvement,
                  progress: 94,
                  rank: 1
              ),
              HistoryBattleCard(
                  title: "Code Every Day",
                  duration: "May 1 - May 30",
                  symbol: Icons.code_outlined,
                  progress: 78,
                  rank: 5
              ),

            ],
          ),
        ),
      )
    );
  }
}
