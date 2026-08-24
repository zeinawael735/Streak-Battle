class BadgesLogic {
  static Map<String, dynamic> checkBadgeConditions({
    required int currentStreak,
    required bool hasBrokenStreakBefore,
    required Map<String, dynamic> achievements,
  }) {
    List<String> newlyUnlocked = [];

    // First Flame
    final firstFlameUnlocked = achievements['first_flame_unlocked'] == true;

    if (currentStreak >= 1 && !firstFlameUnlocked) {
      achievements['first_flame_unlocked'] = true;
      newlyUnlocked.add('First Flame');
    }

    // Week Warrior
    final weekWarriorUnlocked = achievements['week_warrior_unlocked'] == true;

    if (currentStreak >= 7 && !weekWarriorUnlocked) {
      achievements['week_warrior_unlocked'] = true;
      newlyUnlocked.add('Week Warrior');
    }

    // Unbreakable
    final unbreakableUnlocked = achievements['unbreakable_unlocked'] == true;

    if (currentStreak >= 30 && !unbreakableUnlocked) {
      achievements['unbreakable_unlocked'] = true;
      newlyUnlocked.add('Unbreakable');
    }

    // Comeback King
    final comebackUnlocked = achievements['comeback_king_unlocked'] == true;

    if (hasBrokenStreakBefore && currentStreak >= 3 && !comebackUnlocked) {
      achievements['comeback_king_unlocked'] = true;
      newlyUnlocked.add('Comeback King');
    }

    return {'achievements': achievements, 'newlyUnlocked': newlyUnlocked};
  }

  static Map<String, dynamic> checkBattleAchievements({
    required bool isWin,
    required int userRank,
    required int totalWins,
    required Map<String, dynamic> achievements,
  }) {
    List<String> newlyUnlocked = [];

    final championUnlocked = achievements['champion_unlocked'] == true;

    if (isWin && !championUnlocked) {
      achievements['champion_unlocked'] = true;
      newlyUnlocked.add('Champion');
    }

    final podiumUnlocked = achievements['podium_pro_unlocked'] == true;

    if (userRank <= 3 && userRank > 0 && !podiumUnlocked) {
      achievements['podium_pro_unlocked'] = true;
      newlyUnlocked.add('Podium Pro');
    }

    final battleMasterUnlocked = achievements['battle_master_unlocked'] == true;

    if (totalWins >= 5 && !battleMasterUnlocked) {
      achievements['battle_master_unlocked'] = true;
      newlyUnlocked.add('Battle Master');
    }

    return {'achievements': achievements, 'newlyUnlocked': newlyUnlocked};
  }
}
