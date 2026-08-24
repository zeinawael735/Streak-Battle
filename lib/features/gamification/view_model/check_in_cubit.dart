import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:streak_battle/features/achievements/view_model/achievements_service.dart';
import 'package:streak_battle/features/achievements/view_model/badge_logic.dart';

import 'check_in_repository.dart';
import 'check_in_state.dart';

class CheckInCubit extends Cubit<CheckInState> {
  final CheckInRepository _repository;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final AchievementsService _achievementsService = AchievementsService();

  CheckInCubit(this._repository) : super(CheckInInitial());

  Future<void> confirmCheckIn({
    required String battleId,
    required String note,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      emit(CheckInError("User not logged in"));
      return;
    }

    emit(CheckInLoading());

    try {
      final result = await _repository.submitDailyCheckIn(
        userId: user.uid,
        battleId: battleId,
        note: note,
      );

      final int newStreak = result['newStreak'] ?? 0;

      final userData = await _achievementsService.fetchUserData();

      List<String> newlyUnlockedBadges = [];

      if (userData != null) {
        Map<String, dynamic> achievements = {};

        if (userData['achievements'] is Map) {
          achievements = Map<String, dynamic>.from(userData['achievements']);
        }

        final bool hasBrokenStreakBefore =
            userData['hasBrokenStreakBefore'] ?? false;

        final badgeResult = BadgesLogic.checkBadgeConditions(
          currentStreak: newStreak,
          hasBrokenStreakBefore: hasBrokenStreakBefore,
          achievements: achievements,
        );

        newlyUnlockedBadges = List<String>.from(
          badgeResult['newlyUnlocked'] ?? [],
        );

        await _achievementsService.updateAchievementsInDb(
          Map<String, dynamic>.from(badgeResult['achievements']),
        );
      }

      emit(
        CheckInSuccess(
          earnedPoints: result['pointsEarned'] ?? 0,
          streak: result['newStreak'] ?? 0,
          level: result['newLevel'] ?? 1,
          newlyUnlockedBadges: newlyUnlockedBadges,
        ),
      );
    } catch (e) {
      emit(CheckInError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}
