import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'battle_result_state.dart';

class BattleResultCubit extends Cubit<BattleResultState> {
  final FirebaseFirestore _firestore;

  BattleResultCubit({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(BattleResultCalculating());

  Future<void> loadResult({
    required String battleId,
    required String winnerId,
  }) async {
    emit(BattleResultCalculating());
    try {
      final battleDoc =
      await _firestore.collection('battles').doc(battleId).get();
      if (!battleDoc.exists) {
        emit(const BattleResultError('Battle not found.'));
        return;
      }
      final battleData = battleDoc.data()!;

      final winnerDoc =
      await _firestore.collection('users').doc(winnerId).get();
      if (!winnerDoc.exists) {
        emit(const BattleResultError('Winner data not found.'));
        return;
      }
      final winnerData = winnerDoc.data()!;

      final String title = battleData['title'] ?? 'Battle';
      final int durationDays = battleData['durationDays'] ?? 0;
      final String category = battleData['category'] ?? 'Custom';

      final Map<String, dynamic> battlesXp =
      Map<String, dynamic>.from(winnerData['battlesXp'] ?? {});
      final int currentPoints = (battlesXp[battleId] ?? 0) as int;

      final Map<String, dynamic> checkInsMap =
      Map<String, dynamic>.from(winnerData['battlesCheckInsCount'] ?? {});
      final int checkIns = (checkInsMap[battleId] ?? 0) as int;

      final double completionPercent =
      durationDays > 0 ? (checkIns / durationDays).clamp(0.0, 1.0) : 0.0;

      // ---- Award XP bonus + win, only once per battle (guarded by resultProcessed) ----
      final bool alreadyProcessed = battleData['resultProcessed'] == true;
      int finalPoints = currentPoints;

      if (!alreadyProcessed) {
        finalPoints = currentPoints + 50;

        await _firestore.collection('users').doc(winnerId).update({
          'battlesXp.$battleId': finalPoints,
          'wins': FieldValue.increment(1),
        });

        await _firestore.collection('battles').doc(battleId).update({
          'resultProcessed': true,
        });
      }

      emit(BattleResultLoaded(
        battleTitle: title,
        durationDays: durationDays,
        winnerName: winnerData['name'] ?? 'Unknown',
        userCategoryLabel: category,
        points: finalPoints,
        completionPercent: completionPercent,
        checkIns: checkIns,
        xpBonusAwarded: !alreadyProcessed,
      ));
    } catch (e) {
      emit(BattleResultError('Failed to load battle result: $e'));
    }
  }
}