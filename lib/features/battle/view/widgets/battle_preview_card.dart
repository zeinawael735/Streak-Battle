import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:streak_battle/core/theme/theme.dart';

import '../../view_model/battle_entity.dart';

class BattlePreviewCard extends StatelessWidget {
  final BattleEntity battle;
  final VoidCallback onJoinPressed;

  const BattlePreviewCard({
    super.key,
    required this.battle,
    required this.onJoinPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF333333),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF333333), width: 1),
              ),
            ),
          ),
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF333333), width: 1),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFD900),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'BATTLE FOUND',
                      style: TextStyle(
                        color: Color(0xFFFFD900),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  battle.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),


                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(battle.creatorId)
                      .get(),
                  builder: (context, snapshot) {
                    String hostName = 'Loading...';

                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData && snapshot.data!.exists) {
                        hostName = snapshot.data!.get('name') ?? 'Unknown';
                      } else {
                        hostName = 'Unknown User';
                      }
                    }

                    return Text(
                      'Hosted by $hostName • ${battle.members.length} players joined',
                      style: const TextStyle(
                        color: Color(0xFFAAAAAA),
                        fontSize: 14,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151515),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.directions_run_rounded,
                        color: Color(0xFFCDB5FF),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${battle.durationDays} days • ${battle.dailyGoal}',
                        style: const TextStyle(
                          color: Color(0xFFE0E0E0),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: onJoinPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: const Text(
                      'JOIN',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}