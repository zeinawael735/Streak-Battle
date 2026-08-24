import 'package:flutter/material.dart';
import '../../view_model/badge_model.dart';
import '../widgets/badge_card_item.dart';
import '../widgets/header_card.dart';
import '../widgets/next_milestone_card.dart';

class AchievementsScreen extends StatelessWidget {
  AchievementsScreen({Key? key}) : super(key: key);

  final List<BadgeModel> badges = [
    BadgeModel(
      title: 'Starter',
      isUnlocked: true,
      progress: 1.0,
      icon: Icons.local_fire_department,
    ),
    BadgeModel(
      title: 'Podium Pro',
      isUnlocked: true,
      progress: 1.0,
      icon: Icons.emoji_events,
    ),
    BadgeModel(
      title: 'Unbreakable',
      isUnlocked: false,
      progress: 0.7,
      icon: Icons.security,
    ),
    BadgeModel(
      title: 'Ten Wins',
      isUnlocked: true,
      progress: 1.0,
      icon: Icons.military_tech,
    ),
    BadgeModel(
      title: 'Crew Chief',
      isUnlocked: false,
      progress: 0.4,
      icon: Icons.group,
    ),
    BadgeModel(
      title: 'Century',
      isUnlocked: false,
      progress: 0.2,
      icon: Icons.star,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // الباك جراوند وحدها هي اللي بتتغير حسب الثيم العام
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Achievements',
          style: TextStyle(
            color: Colors.white, // ثابت دايماً
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white70),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AchievementsHeaderCard(),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.82,
              ),
              itemCount: badges.length,
              itemBuilder: (context, index) {
                return BadgeCardItem(badge: badges[index]);
              },
            ),
            const SizedBox(height: 28),
            const Text(
              'Next milestone',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const NextMilestoneCard(),
          ],
        ),
      ),
    );
  }
}
