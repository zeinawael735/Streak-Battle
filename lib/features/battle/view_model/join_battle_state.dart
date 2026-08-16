import 'package:equatable/equatable.dart';
import 'package:streak_battle/core/common/common.dart';

abstract class JoinBattleState extends Equatable {
  const JoinBattleState();
  @override
  List<Object?> get props => [];
}

class JoinBattleEmpty extends JoinBattleState {}

class JoinBattlePartial extends JoinBattleState {}

class JoinBattleInvalid extends JoinBattleState {}

class JoinBattleExpired extends JoinBattleState {}

class JoinBattleAlreadyJoined extends JoinBattleState {}

class JoinBattleLoading extends JoinBattleState {}

class JoinBattlePreview extends JoinBattleState {
  final BattleEntity battle;
  const JoinBattlePreview(this.battle);
  @override
  List<Object?> get props => [battle];
}

class JoinBattleJoined extends JoinBattleState {
  final String battleId;
  const JoinBattleJoined(this.battleId);
  @override
  List<Object?> get props => [battleId];
}