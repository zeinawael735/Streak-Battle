class BadgesLogic {
  // ================================
  // STREAK ACHIEVEMENTS
  // ================================

  static Map<String, dynamic> checkBadgeConditions({
    required int currentStreak,
    required bool hasBrokenStreakBefore,
    required Map<String, dynamic> achievements,
  }) {
    List<String> newlyUnlocked = [];

    // -------------------------------
    // FIRST FLAME
    // -------------------------------
    final firstFlameUnlocked = achievements['first_flame_unlocked'] == true;

    if (currentStreak >= 1 && !firstFlameUnlocked) {
      achievements['first_flame_unlocked'] = true;
      newlyUnlocked.add('First Flame');
    }

    // -------------------------------
    // WEEK WARRIOR
    // -------------------------------
    final weekWarriorUnlocked = achievements['week_warrior_unlocked'] == true;

    if (currentStreak >= 7 && !weekWarriorUnlocked) {
      achievements['week_warrior_unlocked'] = true;
      newlyUnlocked.add('Week Warrior');
    }

    // -------------------------------
    // UNBREAKABLE
    // -------------------------------
    final unbreakableUnlocked = achievements['unbreakable_unlocked'] == true;

    if (currentStreak >= 30 && !unbreakableUnlocked) {
      achievements['unbreakable_unlocked'] = true;
      newlyUnlocked.add('Unbreakable');
    }

    // -------------------------------
    // COMEBACK KING
    // -------------------------------
    final comebackUnlocked = achievements['comeback_king_unlocked'] == true;

    if (hasBrokenStreakBefore && currentStreak >= 3 && !comebackUnlocked) {
      achievements['comeback_king_unlocked'] = true;
      newlyUnlocked.add('Comeback King');
    }

    return {'achievements': achievements, 'newlyUnlocked': newlyUnlocked};
  }

  // ================================
  // BATTLE ACHIEVEMENTS
  // ================================
  static Map<String, dynamic> checkBattleAchievements({
    required int totalWins,
    required Map<String, dynamic> achievements,
  }) {
    List<String> newlyUnlocked = [];

    // Champion - 1 Win
    final championUnlocked = achievements['champion_unlocked'] == true;

    if (totalWins >= 1 && !championUnlocked) {
      achievements['champion_unlocked'] = true;
      newlyUnlocked.add('Champion');
    }

    // Battle Master - 5 Wins
    final battleMasterUnlocked = achievements['battle_master_unlocked'] == true;

    if (totalWins >= 5 && !battleMasterUnlocked) {
      achievements['battle_master_unlocked'] = true;
      newlyUnlocked.add('Battle Master');
    }

    return {'achievements': achievements, 'newlyUnlocked': newlyUnlocked};
  }
}
