import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:streak_battle/core/constants/app_assets.dart';
import 'package:streak_battle/core/constants/app_color_style.dart';
import 'package:streak_battle/features/home/view/widgets/home_card.dart';

import '../widgets/battle_details_screen_widgets.dart';

class BattleDetailsScreen extends StatelessWidget {
  const BattleDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Participant> participants = [
      const Participant(
        initials: 'AM',
        name: 'Ahmed Mohamed',
      ),
      const Participant(
        initials: 'MK',
        name: 'Mohamed Khaled',
      ),
      const Participant(
        initials: 'NJ',
        name: 'Nour John',
      ),
      const Participant(
        initials: 'SA',
        name: 'Sara Ahmed',
      ),
      const Participant(
        initials: 'MA',
        name: 'Mostafa Ali',
      ),
      const Participant(
        initials: 'YO',
        name: 'Youssef Omar',
      ),
      const Participant(
        initials: 'HA',
        name: 'Hassan Ahmed',
      ),
      const Participant(
        initials: 'KM',
        name: 'Karim Mohamed',
      ),
      const Participant(
        initials: 'AA',
        name: 'Ali Ahmed',
      ),
      const Participant(
        initials: 'OM',
        name: 'Omar Mohamed',
      ),
      const Participant(
        initials: 'MA',
        name: 'Mahmoud Ali',
      ),
      const Participant(
        initials: 'YA',
        name: 'Yassin Ahmed',
      ),
    ];
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            /// first part of the screen
            Container(
              color: Color(0xFF150050),
              child: Padding(
                padding: EdgeInsets.only(top: 35, left: 17, right: 17),
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
                          icon: Icon(Icons.arrow_back_ios_new),
                          padding: EdgeInsets.all(0),
                          alignment: .centerLeft,
                        ),
                        IconButton(
                          onPressed: () async {
                            await Share.share(
                              'Join my battle! Use code: the code',
                            );
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
                            color: AppColorStyle.primaryViolet,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 55,
                          width: 55,
                          child: Center(
                            child: Icon(Icons.directions_run, size: 25),
                          ),
                        ),
                        Container(
                          width: 75,
                          height: 34,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: AppColorStyle.primaryText,
                              width: 0.15,
                            ),
                            color: AppColorStyle.primaryViolet,
                          ),
                          child: Center(child: Text("Active",style: TextStyle(color: AppColorStyle.primaryGreen),)),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          "Morning Run Club",
                          style: TextStyle(
                            fontWeight: .bold,
                            fontSize: 25,
                            color: AppColorStyle.primaryText,
                          ),
                        ),
                        Text(
                          "Day 8 of 21 • 12 players",
                          style: TextStyle(color: Color(0xFFCDC2D9)),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 70 * (1 / 100),
                            minHeight: 6,
                            backgroundColor:
                                AppColorStyle.progressIndicatorBackgroundColor,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColorStyle.progressIndicatorColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /// second part of the screen
            Padding(
              padding: EdgeInsets.only(top: 20, left: 17, right: 24),
              child: Column(
                spacing: 16,
                crossAxisAlignment: .start,
                children: [
                  SizedBox(
                    width: .infinity,
                    child: HomeCard(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 40,
                          horizontal: 25,
                        ),
                        child: Column(
                          spacing: 40,
                          crossAxisAlignment: .start,
                          children: [
                            Column(
                              mainAxisAlignment: .spaceBetween,
                              crossAxisAlignment: .start,
                              children: [
                                Text("TODAY'S GOAL"),
                                Text(
                                  "Run 3 km",
                                  style: TextStyle(
                                    color: AppColorStyle.primaryText,
                                    fontSize: 24,
                                    fontWeight: .bold,
                                  ),
                                ),
                                Text(
                                  "Check in before 11:59 PM",
                                  style: TextStyle(
                                    color: Color(0xFFCDC2D9),
                                    fontSize: 17,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 7),
                                  child: Container(
                                    width: 160,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF3E354F),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: .spaceEvenly,
                                      children: [
                                        SvgPicture.asset(
                                          AppAssets.fireIconSvg,
                                          width: 15,
                                          height: 15,
                                        ),
                                        Text(
                                          "12-day battle streak",
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: .infinity,
                              height: 47,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColorStyle.primaryViolet,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: .center,
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: AppColorStyle.primaryGreen,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Check in",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
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
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text("Participants",style: TextStyle(fontWeight: .bold,color: AppColorStyle.primaryText,fontSize: 20),),
                      Text("8 of 12 checked in",style: TextStyle(color: AppColorStyle.primaryGreen,fontSize: 15),),
                    ],
                  ),
                  Row(
                    children: [
                      for (final participant in participants.take(4))
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () {
                              ParticipantsDialog.showParticipant(
                                context,
                                participant,
                              );
                            },
                            child: ParticipantCircle(
                              initials: participant.initials,
                              size: 50,
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: () {
                          ParticipantsDialog.showMoreParticipants(
                            context,
                            participants.skip(4).toList(),
                          );
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:  Color(0xFF30283A),
                          ),
                          alignment: Alignment.center,
                          child:  Text(
                            '+8',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  CheckedInCard(name: 'Maya', initials: 'MK', goal: 'Run 3.4 km', time: '16 min',),
                  CheckedInCard(name: 'Nate', initials: 'NJ', goal: 'Run 3.0 km', time: '45 min',),
                  SizedBox(height: 50,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
