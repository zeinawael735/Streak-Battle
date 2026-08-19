import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:streak_battle/core/constants/app_color_style.dart';
import 'package:streak_battle/features/home/view/widgets/home_card.dart';

class BattleDetailsScreen extends StatelessWidget {
  const BattleDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorStyle.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            /// first part of the screen
            Container(
              color: Color(0xFF150050),
              child: Padding(
                padding:  EdgeInsets.only(top: 35,left: 17,right: 17),
                child: Column(
                  crossAxisAlignment: .start,
                  spacing: 10,
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios_new,),
                          padding: EdgeInsets.all(0),
                          alignment: .centerLeft,
                        ),
                        IconButton(
                          onPressed: () async {
                            await Share.share('Join my battle! Use code: the code');
                          },
                          icon: Icon(Icons.share),
                          padding: EdgeInsets.all(0),
                          alignment: .centerRight,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColorStyle
                                .primaryViolet,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 55,
                          width: 55,
                          child: Center(
                            child: Icon(Icons.directions_run,size: 25,)
                          ),
                        ),
                        Container(
                          width: 75,
                          height: 34,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: AppColorStyle.primaryText,width: 0.15),
                            color: AppColorStyle.primaryViolet,
                          ),
                          child: Center(child: Text("Active")),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text("Morning Run Club",style: TextStyle(fontWeight: .bold,fontSize: 25,color: AppColorStyle.primaryText),),
                        Text("Day 8 of 21 • 12 players",style: TextStyle(color: Color(0xFFCDC2D9)),),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 70*(1/100),
                            minHeight: 6,
                            backgroundColor: AppColorStyle.progressIndicatorBackgroundColor,
                            valueColor:  AlwaysStoppedAnimation<Color>(
                                AppColorStyle.progressIndicatorColor
                            ),
                          ),
                        ),
                        SizedBox(height: 20,)
                      ],
                    )
                  ],
                ),
              ),
            ),
            
            /// second part of the screen 
            Padding(
              padding: EdgeInsets.only(top: 20,left: 17),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  HomeCard(
                      child: Padding(
                        padding:  EdgeInsets.symmetric(vertical: 40,horizontal: 25),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text("TODAY'S GOAL"),
                            Text("Run 3 km",style: TextStyle(color: AppColorStyle.primaryText,fontSize: 23,fontWeight: .bold),),
                            Text("Check in before 11:59 PM",style: TextStyle(color:Color(0xFFCDC2D9) ),),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColorStyle.primaryViolet,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child:  Text(
                                "Log in",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
