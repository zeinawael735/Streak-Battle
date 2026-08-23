import 'package:flutter_bloc/flutter_bloc.dart';
import 'battle_result_state.dart';

class BattleResultCubit extends Cubit<BattleResultState> {
  BattleResultCubit() : super(BattleResultCalculating()) {
    _loadPlaceholderResult(); // TODO: replace with real Firestore logic once battleId/winnerId are received from screen navigation
  }

  Future<void> _loadPlaceholderResult() async {
    await Future.delayed(const Duration(milliseconds: 600));
    emit(const BattleResultLoaded(
      battleTitle: 'Morning Run Club',
      durationDays: 21,
      winnerName: 'Maya Ahmed',
      userCategoryLabel: 'Fitness', // TODO: category comes from the battle document
      points: 1720, // TODO: confirm source
      completionPercent: 0.91, // TODO: confirm source
      checkIns: 19, // TODO: confirm source
      bestStreak: 12,
      totalDistanceKm: 62.4,
    ));
  }
}