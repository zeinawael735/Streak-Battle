import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'check_in_repository.dart';
import 'check_in_state.dart';

class CheckInCubit extends Cubit<CheckInState> {
  final CheckInRepository _repository;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String battleTitle = '';
  String battleGoal = '';

  CheckInCubit(this._repository) : super(CheckInInitial());

  Future<void> loadBattleData(String battleId) async {
    try {
      final data = await _repository.getBattleInfo(battleId);
      battleTitle = data['title'] ?? '';
      battleGoal = data['goal'] ?? '';
      emit(CheckInInfoLoaded());
    } catch (e) {
      //
    }
  }

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

      emit(CheckInSuccess(
        earnedPoints: result['pointsEarned'],
        streak: result['newStreak'],
        level: result['newLevel'],
      ));
    } catch (e) {
      emit(CheckInError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}