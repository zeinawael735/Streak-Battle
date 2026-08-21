import 'package:equatable/equatable.dart';

abstract class BattleResultState extends Equatable {
  const BattleResultState();
  @override
  List<Object?> get props => [];
}

class BattleResultCalculating extends BattleResultState {}

class BattleResultError extends BattleResultState {
  final String message;
  const BattleResultError(this.message);
  @override
  List<Object?> get props => [message];
}

// Base data shared across Winner / RunnerUp / Participant / Tie
class BattleResultLoaded extends BattleResultState {
  final String battleTitle;
  final String winnerName;
  final String userRankLabel; // e.g. "#2 Runner-up", "#1 Winner"
  final int points;
  final double completionPercent; // 0.0 - 1.0
  final int checkIns;
  final int bestStreak;
  final double totalDistanceKm;
  final bool isTie;

  const BattleResultLoaded({
    required this.battleTitle,
    required this.winnerName,
    required this.userRankLabel,
    required this.points,
    required this.completionPercent,
    required this.checkIns,
    required this.bestStreak,
    required this.totalDistanceKm,
    this.isTie = false,
  });

  @override
  List<Object?> get props => [
    battleTitle,
    winnerName,
    userRankLabel,
    points,
    completionPercent,
    checkIns,
    bestStreak,
    totalDistanceKm,
    isTie,
  ];
}