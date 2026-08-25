import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'badge_logic.dart';
import 'badge_model.dart';
import 'achievement_state.dart';
import 'achievements_service.dart';

class AchievementsCubit extends Cubit<AchievementsState> {
  final AchievementsService _service = AchievementsService();

  StreamSubscription<Map<String, dynamic>?>? _userSubscription;

  AchievementsCubit() : super(AchievementsInitial()) {
    watchAchievements();
  }

  List<BadgeModel> badges = [
    BadgeModel(
      title: 'First Flame',
      isUnlocked: false,
      progress: 0.0,
      icon: Icons.local_fire_department,
    ),
    BadgeModel(
      title: 'Week Warrior',
      isUnlocked: false,
      progress: 0.0,
      icon: Icons.bolt,
    ),
    BadgeModel(
      title: 'Unbreakable',
      isUnlocked: false,
      progress: 0.0,
      icon: Icons.security,
    ),
    BadgeModel(
      title: 'Champion',
      isUnlocked: false,
      progress: 0.0,
      icon: Icons.workspace_premium,
    ),
    BadgeModel(
      title: 'Battle Master',
      isUnlocked: false,
      progress: 0.0,
      icon: Icons.military_tech,
    ),
    BadgeModel(
      title: 'Comeback King',
      isUnlocked: false,
      progress: 0.0,
      icon: Icons.refresh,
    ),
  ];

  void watchAchievements() {
    emit(AchievementsLoading());

    _userSubscription?.cancel();

    _userSubscription = _service.watchUserData().listen(
      (data) async {
        if (data == null) {
          emit(AchievementsUpdated(List.from(badges)));
          return;
        }

        // --------------------------------
        // Get achievements from Firestore
        // --------------------------------

        Map<String, dynamic> achievements = {};

        if (data['achievements'] is Map) {
          achievements = Map<String, dynamic>.from(data['achievements']);
        }

        // --------------------------------
        // Get current streak
        // --------------------------------

        final int currentStreak = (data['currentStreak'] as num?)?.toInt() ?? 0;

        // --------------------------------
        // Get broken streak status
        // --------------------------------

        final bool hasBrokenStreakBefore =
            data['hasBrokenStreakbefore'] == true;

        // --------------------------------
        // Get total wins
        // --------------------------------

        final int totalWins = (data['wins'] as num?)?.toInt() ?? 0;

        // --------------------------------
        // Check STREAK achievements
        // --------------------------------

        final badgeResult = BadgesLogic.checkBadgeConditions(
          currentStreak: currentStreak,
          hasBrokenStreakBefore: hasBrokenStreakBefore,
          achievements: achievements,
        );

        final Map<String, dynamic> updatedAchievements =
            Map<String, dynamic>.from(badgeResult['achievements'] as Map);

        final List<String> newlyUnlocked = List<String>.from(
          badgeResult['newlyUnlocked'] ?? [],
        );

        // --------------------------------
        // Check BATTLE achievements
        // --------------------------------

        final battleResult = BadgesLogic.checkBattleAchievements(
          totalWins: totalWins,
          achievements: updatedAchievements,
        );

        final Map<String, dynamic> finalAchievements =
            Map<String, dynamic>.from(battleResult['achievements'] as Map);

        newlyUnlocked.addAll(
          List<String>.from(battleResult['newlyUnlocked'] ?? []),
        );

        // --------------------------------
        // Save achievements if changed
        // --------------------------------

        if (newlyUnlocked.isNotEmpty) {
          await _service.updateAchievementsInDb(finalAchievements);
        }

        // --------------------------------
        // Build UI
        // --------------------------------

        badges = _buildBadges(
          achievements: finalAchievements,
          currentStreak: currentStreak,
        );

        emit(AchievementsUpdated(List.from(badges)));
      },
      onError: (error) {
        emit(AchievementsUpdated(List.from(badges)));
      },
    );
  }

  // ==========================================
  // BUILD BADGES
  // ==========================================

  List<BadgeModel> _buildBadges({
    required Map<String, dynamic> achievements,
    required int currentStreak,
  }) {
    final List<BadgeModel> updatedBadges = [
      // --------------------------------
      // FIRST FLAME
      // --------------------------------
      BadgeModel(
        title: 'First Flame',
        isUnlocked: achievements['first_flame_unlocked'] == true,
        progress: currentStreak >= 1 ? 1.0 : 0.0,
        icon: Icons.local_fire_department,
      ),

      // --------------------------------
      // WEEK WARRIOR
      // --------------------------------
      BadgeModel(
        title: 'Week Warrior',
        isUnlocked: achievements['week_warrior_unlocked'] == true,
        progress: (currentStreak / 7).clamp(0.0, 1.0),
        icon: Icons.bolt,
      ),

      // --------------------------------
      // UNBREAKABLE
      // --------------------------------
      BadgeModel(
        title: 'Unbreakable',
        isUnlocked: achievements['unbreakable_unlocked'] == true,
        progress: (currentStreak / 30).clamp(0.0, 1.0),
        icon: Icons.security,
      ),

      // --------------------------------
      // CHAMPION
      // --------------------------------
      BadgeModel(
        title: 'Champion',
        isUnlocked: achievements['champion_unlocked'] == true,
        progress: achievements['champion_unlocked'] == true ? 1.0 : 0.0,
        icon: Icons.workspace_premium,
      ),

      // --------------------------------
      // BATTLE MASTER
      // --------------------------------
      BadgeModel(
        title: 'Battle Master',
        isUnlocked: achievements['battle_master_unlocked'] == true,
        progress: achievements['battle_master_unlocked'] == true ? 1.0 : 0.0,
        icon: Icons.military_tech,
      ),

      // --------------------------------
      // COMEBACK KING
      // --------------------------------
      BadgeModel(
        title: 'Comeback King',
        isUnlocked: achievements['comeback_king_unlocked'] == true,
        progress: achievements['comeback_king_unlocked'] == true ? 1.0 : 0.0,
        icon: Icons.refresh,
      ),
    ];

    // --------------------------------
    // Unlocked badges first
    // --------------------------------

    updatedBadges.sort(
      (a, b) => (b.isUnlocked ? 1 : 0).compareTo(a.isUnlocked ? 1 : 0),
    );

    return updatedBadges;
  }

  // ==========================================
  // GETTERS
  // ==========================================

  int get unlockedCount => badges.where((badge) => badge.isUnlocked).length;

  int get totalCount => badges.length;

  double get overallProgress =>
      totalCount == 0 ? 0.0 : unlockedCount / totalCount;

  // ==========================================
  // CLOSE
  // ==========================================

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
