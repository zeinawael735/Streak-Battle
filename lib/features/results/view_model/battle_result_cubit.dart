import 'package:flutter_bloc/flutter_bloc.dart';
import 'battle_result_state.dart';

class BattleResultCubit extends Cubit<BattleResultState> {
  BattleResultCubit() : super(BattleResultCalculating()) {
    _loadPlaceholderResult(); // TODO: replace with real Firestore logic once schema/rules are confirmed
  }

  Future<void> _loadPlaceholderResult() async {
    await Future.delayed(const Duration(milliseconds: 600));
    emit(const BattleResultLoaded(
      battleTitle: '21-day Morning Run Club',
      winnerName: 'Maya',
      userRankLabel: '#2 Runner-up',
      points: 1720,
      completionPercent: 0.91,
      checkIns: 19,
      bestStreak: 12,
      totalDistanceKm: 62.4,
    ));
  }
}