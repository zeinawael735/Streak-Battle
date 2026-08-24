class BadgesLogic {
  static Map<String, dynamic> checkBadgeConditions({
    required int currentStreak,
    required bool hasBrokenStreakBefore,
    required Map<String, dynamic> achievements,
  }) {
    List<String> newlyUnlocked = [];

    if (currentStreak < 1) {
      achievements['first_flame_unlocked'] = false;
    } else {
      bool isUnlocked = achievements['first_flame_unlocked'] ?? false;
      if (!isUnlocked) {
        achievements['first_flame_unlocked'] = true;
        newlyUnlocked.add('First Flame');
      }
    }

    bool isWeekWarriorUnlocked = achievements['week_warrior_unlocked'] ?? false;
    if (currentStreak >= 7 && !isWeekWarriorUnlocked) {
      achievements['week_warrior_unlocked'] = true;
      newlyUnlocked.add('Week Warrior');
    }

    bool isPerfectWeekUnlocked = achievements['perfect_week_unlocked'] ?? false;
    if (currentStreak >= 7 && !isPerfectWeekUnlocked) {
      achievements['perfect_week_unlocked'] = true;
      newlyUnlocked.add('Perfect Week');
    }

    bool isUnbreakableUnlocked = achievements['unbreakable_unlocked'] ?? false;
    if (currentStreak >= 30 && !isUnbreakableUnlocked) {
      achievements['unbreakable_unlocked'] = true;
      newlyUnlocked.add('Unbreakable');
    }

    bool isComebackUnlocked = achievements['comeback_king_unlocked'] ?? false;
    if (hasBrokenStreakBefore && currentStreak >= 3 && !isComebackUnlocked) {
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

    bool isChampionUnlocked = achievements['champion_unlocked'] ?? false;
    if (isWin && !isChampionUnlocked) {
      achievements['champion_unlocked'] = true;
      newlyUnlocked.add('Champion');
    }

    bool isPodiumUnlocked = achievements['podium_pro_unlocked'] ?? false;
    if (userRank <= 3 && userRank > 0 && !isPodiumUnlocked) {
      achievements['podium_pro_unlocked'] = true;
      newlyUnlocked.add('Podium Pro');
    }

    bool isBattleMasterUnlocked =
        achievements['battle_master_unlocked'] ?? false;
    if (totalWins >= 3 && !isBattleMasterUnlocked) {
      achievements['battle_master_unlocked'] = true;
      newlyUnlocked.add('Battle Master');
    }

    return {'achievements': achievements, 'newlyUnlocked': newlyUnlocked};
  }
}
