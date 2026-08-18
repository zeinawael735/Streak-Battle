import 'package:flutter/material.dart';

import '../../../../core/constants/app_color_style.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../home/view/widgets/home_card.dart';

class HistoryBattleCard extends StatelessWidget {
  const HistoryBattleCard({super.key, required this.title, required this.duration, required this.symbol, required this.progress, required this.rank});

  final String title;
  final String duration;
  final IconData symbol;
  final int progress;
  final int rank;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.battleDetails);
      },
      child: HomeCard(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              spacing: 14,
              crossAxisAlignment: .start,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    CircleAvatar(
                      radius:25,
                      backgroundColor: Color(0xFF2E263F),
                      child: Icon(symbol,color: AppColorStyle.primaryGreen,size: 30,),
                    ),
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(title,style: TextStyle(color: AppColorStyle.primaryText,fontSize: 22,fontWeight: .bold),),
                        Text(duration,style: TextStyle(color: AppColorStyle.primaryText,fontSize: 15),),
                      ],
                    ),
                    Container(
                      width: 75,
                      height: 34,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppColorStyle.primaryText,width: 0.15),
                        color: Color(0xFF2E263F),
                      ),
                      child: Center(child: Text("Rank #$rank",style: TextStyle(color: AppColorStyle.primaryGreen),)),
                    )
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress*(1/100),
                    minHeight: 6,
                    backgroundColor: AppColorStyle.progressIndicatorBackgroundColor,
                    valueColor:  AlwaysStoppedAnimation<Color>(
                        AppColorStyle.progressIndicatorColor
                    ),
                  ),
                ),
                Row(
                    mainAxisAlignment: .end,
                    children: [Text("$progress%",style: TextStyle(color: AppColorStyle.primaryGreen),)]
                )
              ],
            ),
          )
      )
    );
  }
}
