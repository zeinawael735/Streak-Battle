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
  final String battleTitle;
  final int durationDays;
  final String winnerName;
  final String userCategoryLabel;
  final int points;
  final double completionPercent;
  final int checkIns;
  final bool xpBonusAwarded; // true only the first time the bonus is granted

  const BattleResultLoaded({
    required this.battleTitle,
    required this.durationDays,
    required this.winnerName,
    required this.userCategoryLabel,
    required this.points,
    required this.completionPercent,
    required this.checkIns,
    required this.xpBonusAwarded,
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
    xpBonusAwarded,
  ];
}