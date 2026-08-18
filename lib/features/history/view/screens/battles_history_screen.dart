import 'package:flutter/material.dart';
import 'package:streak_battle/features/home/view/widgets/home_card.dart';

import '../../../../core/constants/app_color_style.dart';

class BattlesScreen extends StatelessWidget {
  const BattlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Battles history",style: TextStyle(fontWeight: .bold,fontSize: 33,color: AppColorStyle.primaryText),),),
      backgroundColor: AppColorStyle.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text("August 2026",style: TextStyle(fontSize: 20,color: AppColorStyle.primaryText),),
              HomeCard(
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
                              child: Icon(Icons.self_improvement,color: AppColorStyle.primaryGreen,size: 30,),
                            ),
                            Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text("Morning Yoga",style: TextStyle(color: AppColorStyle.primaryText,fontSize: 22,fontWeight: .bold),),
                                Text("Jun 3 - Jun 24",style: TextStyle(color: AppColorStyle.primaryText,fontSize: 15),),
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
                              child: Center(child: Text("Rank #1",style: TextStyle(color: AppColorStyle.primaryGreen),)),
                            )
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 94*(1/100),
                            minHeight: 6,
                            backgroundColor: AppColorStyle.progressIndicatorBackgroundColor,
                            valueColor:  AlwaysStoppedAnimation<Color>(
                                AppColorStyle.progressIndicatorColor
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: .end,
                            children: [Text("94%",style: TextStyle(color: AppColorStyle.primaryGreen),)]
                        )
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      )
    );
  }
}
