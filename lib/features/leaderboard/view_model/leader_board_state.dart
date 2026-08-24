import 'package:streak_battle/features/leaderboard/view_model/user_model.dart';

sealed class LeaderBoardState {}
class LeaderBoardInitial extends LeaderBoardState {}

class LeaderBoardLoading extends LeaderBoardState {}

class LeaderBoardError extends LeaderBoardState{
  String message;
  LeaderBoardError(this.message);
}

class LeaderBoardSuccess extends LeaderBoardState{
  List<UserModel> top3;
  List<UserModel> remainingUsers;
  UserModel? currentUser;
  LeaderBoardSuccess(this.top3,this.remainingUsers,this.currentUser);

}