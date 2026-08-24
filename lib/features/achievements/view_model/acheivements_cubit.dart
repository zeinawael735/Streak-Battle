import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

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
      title: 'Podium Pro',
      isUnlocked: false,
      progress: 0.0,
      icon: Icons.emoji_events,
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
      (data) {
        if (data == null) {
          emit(AchievementsUpdated(badges));
          return;
        }

        final Map<String, dynamic> achievements = data['achievements'] is Map
            ? Map<String, dynamic>.from(data['achievements'])
            : {};

        final int currentStreak = data['currentStreak'] ?? 0;

        badges = _buildBadges(
          achievements: achievements,
          currentStreak: currentStreak,
        );

        emit(AchievementsUpdated(List.from(badges)));
      },
      onError: (error) {
        emit(AchievementsUpdated(badges));
      },
    );
  }

  List<BadgeModel> _buildBadges({
    required Map<String, dynamic> achievements,
    required int currentStreak,
  }) {
    final List<BadgeModel> updatedBadges = [
      BadgeModel(
        title: 'First Flame',
        isUnlocked: achievements['first_flame_unlocked'] == true,
        progress: achievements['first_flame_unlocked'] == true
            ? 1.0
            : currentStreak >= 1
            ? 1.0
            : 0.0,
        icon: Icons.local_fire_department,
      ),

      BadgeModel(
        title: 'Week Warrior',
        isUnlocked: achievements['week_warrior_unlocked'] == true,
        progress: achievements['week_warrior_unlocked'] == true
            ? 1.0
            : (currentStreak / 7).clamp(0.0, 1.0),
        icon: Icons.bolt,
      ),

      BadgeModel(
        title: 'Unbreakable',
        isUnlocked: achievements['unbreakable_unlocked'] == true,
        progress: achievements['unbreakable_unlocked'] == true
            ? 1.0
            : (currentStreak / 30).clamp(0.0, 1.0),
        icon: Icons.security,
      ),

      BadgeModel(
        title: 'Champion',
        isUnlocked: achievements['champion_unlocked'] == true,
        progress: achievements['champion_unlocked'] == true ? 1.0 : 0.0,
        icon: Icons.workspace_premium,
      ),

      BadgeModel(
        title: 'Podium Pro',
        isUnlocked: achievements['podium_pro_unlocked'] == true,
        progress: achievements['podium_pro_unlocked'] == true ? 1.0 : 0.0,
        icon: Icons.emoji_events,
      ),

      BadgeModel(
        title: 'Battle Master',
        isUnlocked: achievements['battle_master_unlocked'] == true,
        progress: achievements['battle_master_unlocked'] == true ? 1.0 : 0.0,
        icon: Icons.military_tech,
      ),

      BadgeModel(
        title: 'Comeback King',
        isUnlocked: achievements['comeback_king_unlocked'] == true,
        progress: achievements['comeback_king_unlocked'] == true ? 1.0 : 0.0,
        icon: Icons.refresh,
      ),
    ];

    updatedBadges.sort(
      (a, b) => (b.isUnlocked ? 1 : 0).compareTo(a.isUnlocked ? 1 : 0),
    );

    return updatedBadges;
  }

  int get unlockedCount => badges.where((badge) => badge.isUnlocked).length;

  int get totalCount => badges.length;

  double get overallProgress =>
      totalCount == 0 ? 0.0 : unlockedCount / totalCount;

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
