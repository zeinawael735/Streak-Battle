import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../view_model/badge_model.dart';
import 'achievement_state.dart';
import 'achievements_service.dart';
import 'badge_logic.dart';

class AchievementsCubit extends Cubit<AchievementsState> {
  final AchievementsService _service = AchievementsService();

  AchievementsCubit() : super(AchievementsInitial()) {
    loadBadges();
  }

  List<BadgeModel> badges = [
    BadgeModel(
      title: 'First Flame',
      isUnlocked: false,
      progress: 0.0,
      icon: Icons.local_fire_department,
    ), // 0
    BadgeModel(
      title: 'Week Warrior',
      isUnlocked: false,
      progress: 0.0,
      icon: Icons.bolt,
    ), // 1
    BadgeModel(
      title: 'Perfect Week',
      isUnlocked: false,
      progress: 0.0,
      icon: Icons.verified,
    ), // 2
    BadgeModel(
      title: 'Unbreakable',
      isUnlocked: false,
      progress: 0.0,
      icon: Icons.security,
    ), // 3
    BadgeModel(
      title: 'Champion',
      isUnlocked: false,
      progress: 0.0,
      icon: Icons.workspace_premium,
    ), // 4
    BadgeModel(
      title: 'Podium Pro',
      isUnlocked: false,
      progress: 0.0,
      icon: Icons.emoji_events,
    ), // 5
    BadgeModel(
      title: 'Battle Master',
      isUnlocked: false,
      progress: 0.0,
      icon: Icons.military_tech,
    ), // 6
    BadgeModel(
      title: 'Comeback King',
      isUnlocked: false,
      progress: 0.0,
      icon: Icons.refresh,
    ), // 7
  ];

  Future<void> loadBadges([BuildContext? context]) async {
    try {
      final data = await _service.fetchUserData();
      if (data != null) {
        int currentStreak = data['currentStreak'] ?? 0;
        bool hasBrokenStreakBefore = data['hasBrokenStreakBefore'] ?? false;

        Map<String, dynamic> achievements = {};
        if (data.containsKey('achievements') && data['achievements'] is Map) {
          achievements = Map<String, dynamic>.from(data['achievements']);
        }

        final result = BadgesLogic.checkBadgeConditions(
          currentStreak: currentStreak,
          hasBrokenStreakBefore: hasBrokenStreakBefore,
          achievements: achievements,
        );

        Map<String, dynamic> updatedAchievements = result['achievements'];
        List<String> newlyUnlocked = result['newlyUnlocked'];

        await _service.updateAchievementsInDb(updatedAchievements);

        _updateLocalBadgeStatus(
          0,
          'First Flame',
          updatedAchievements['first_flame_unlocked'] ?? false,
        );
        _updateLocalBadgeStatus(
          1,
          'Week Warrior',
          updatedAchievements['week_warrior_unlocked'] ?? false,
        );
        _updateLocalBadgeStatus(
          2,
          'Perfect Week',
          updatedAchievements['perfect_week_unlocked'] ?? false,
        );
        _updateLocalBadgeStatus(
          3,
          'Unbreakable',
          updatedAchievements['unbreakable_unlocked'] ?? false,
        );
        _updateLocalBadgeStatus(
          4,
          'Champion',
          updatedAchievements['champion_unlocked'] ?? false,
        );
        _updateLocalBadgeStatus(
          5,
          'Podium Pro',
          updatedAchievements['podium_pro_unlocked'] ?? false,
        );
        _updateLocalBadgeStatus(
          6,
          'Battle Master',
          updatedAchievements['battle_master_unlocked'] ?? false,
        );
        _updateLocalBadgeStatus(
          7,
          'Comeback King',
          updatedAchievements['comeback_king_unlocked'] ?? false,
        );

        badges.sort(
          (a, b) => (b.isUnlocked ? 1 : 0).compareTo(a.isUnlocked ? 1 : 0),
        );

        if (context != null) {
          for (String badgeTitle in newlyUnlocked) {
            _showCongratulationsDialog(context, badgeTitle);
          }
        }
      }
    } catch (e) {
      print("Error loading badges: $e");
    }

    emit(AchievementsUpdated(badges));
  }

  Future<void> checkBattleFinish({
    required bool isWin,
    required int userRank,
    required BuildContext context,
  }) async {
    try {
      final data = await _service.fetchUserData();
      if (data != null) {
        int totalWins = (data['totalWins'] ?? 0) + (isWin ? 1 : 0);

        Map<String, dynamic> achievements = {};
        if (data.containsKey('achievements') && data['achievements'] is Map) {
          achievements = Map<String, dynamic>.from(data['achievements']);
        }

        final result = BadgesLogic.checkBattleAchievements(
          isWin: isWin,
          userRank: userRank,
          totalWins: totalWins,
          achievements: achievements,
        );

        Map<String, dynamic> updatedAchievements = result['achievements'];
        List<String> newlyUnlocked = result['newlyUnlocked'];

        if (newlyUnlocked.isNotEmpty) {
          await _service.updateAchievementsInDb(updatedAchievements);

          _updateLocalBadgeStatus(
            4,
            'Champion',
            updatedAchievements['champion_unlocked'] ?? false,
          );
          _updateLocalBadgeStatus(
            5,
            'Podium Pro',
            updatedAchievements['podium_pro_unlocked'] ?? false,
          );
          _updateLocalBadgeStatus(
            6,
            'Battle Master',
            updatedAchievements['battle_master_unlocked'] ?? false,
          );

          badges.sort(
            (a, b) => (b.isUnlocked ? 1 : 0).compareTo(a.isUnlocked ? 1 : 0),
          );
          emit(AchievementsUpdated(badges));

          for (String badgeTitle in newlyUnlocked) {
            _showCongratulationsDialog(context, badgeTitle);
          }
        }
      }
    } catch (e) {
      print("Error updating battle achievements: $e");
    }
  }

  void _updateLocalBadgeStatus(int index, String title, bool isUnlocked) {
    badges[index] = BadgeModel(
      title: title,
      isUnlocked: isUnlocked,
      progress: isUnlocked ? 1.0 : 0.0,
      icon: badges[index].icon,
    );
  }

  void _showCongratulationsDialog(BuildContext context, String badgeTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF191724),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 60),
              const SizedBox(height: 16),
              const Text(
                'Congratulations!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'You unlocked "$badgeTitle"',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Awesome',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int get unlockedCount => badges.where((badge) => badge.isUnlocked).length;
  int get totalCount => badges.length;
  double get overallProgress =>
      totalCount == 0 ? 0.0 : unlockedCount / totalCount;
}
