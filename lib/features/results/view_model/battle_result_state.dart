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

class BattleResultLoaded extends BattleResultState {
  final String battleTitle; // e.g. "Morning Run Club" (name only, without day count)
  final int durationDays; // e.g. 21
  final String winnerName; // full winner name, e.g. "Maya Ahmed"
  final String userCategoryLabel; // battle category, e.g. "Fitness"
  final int points; // TODO: confirm source
  final double completionPercent; // TODO: confirm source
  final int checkIns; // TODO: confirm source
  final int bestStreak; // postponed
  final double totalDistanceKm; // postponed
  final bool isTie;

  const BattleResultLoaded({
    required this.battleTitle,
    required this.durationDays,
    required this.winnerName,
    required this.userCategoryLabel,
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
    durationDays,
    winnerName,
    userCategoryLabel,
    points,
    completionPercent,
    checkIns,
    bestStreak,
    totalDistanceKm,
    isTie,
  ];
}