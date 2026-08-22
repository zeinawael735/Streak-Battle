part of 'battle_details_cubit.dart';

abstract class BattleDetailsState {}

class BattleDetailsInitial extends BattleDetailsState {}

class BattleDetailsLoading extends BattleDetailsState {}

class BattleDetailsError extends BattleDetailsState {
  final String message;
  BattleDetailsError(this.message);
}

class BattleDetailsLoaded extends BattleDetailsState {
  final String title;
  final String category;
  final String goal;
  final String battleCode;
  final int durationDays;
  final bool isFinished;
  final String formattedEndDate;
  final int currentDay;
  final double progressValue;
  final int myCheckInsCount;
  final List<Participant> participants;
  final int participantsCount;
  final int displayCount;
  final int remainingCount;
  final List<CheckInViewData> todayCheckIns;

  BattleDetailsLoaded({
    required this.title,
    required this.category,
    required this.goal,
    required this.battleCode,
    required this.durationDays,
    required this.isFinished,
    required this.formattedEndDate,
    required this.currentDay,
    required this.progressValue,
    required this.myCheckInsCount,
    required this.participants,
    required this.participantsCount,
    required this.displayCount,
    required this.remainingCount,
    required this.todayCheckIns,
  });
}

class CheckInViewData {
  final String name;
  final String initials;
  final String goal;
  final String timeAgo;

  CheckInViewData({
    required this.name,
    required this.initials,
    required this.goal,
    required this.timeAgo,
  });
}