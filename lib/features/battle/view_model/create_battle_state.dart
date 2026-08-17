sealed class CreateBattleState {}

class CreateBattleInitial extends CreateBattleState {}

class CreateBattleLoading extends CreateBattleState {}

class CreateBattleSuccess extends CreateBattleState {}

class CreateBattleError extends CreateBattleState {
  final String message;
  CreateBattleError(this.message);
}