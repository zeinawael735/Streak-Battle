abstract class CheckInState {}

class CheckInInitial extends CheckInState {}

class CheckInLoading extends CheckInState {}

class CheckInInfoLoaded extends CheckInState {}

class CheckInSuccess extends CheckInState {
  final int earnedPoints;
  final int streak;
  final int level;
  final List<String> newlyUnlockedBadges;

  CheckInSuccess({
    required this.earnedPoints,
    required this.streak,
    required this.level,
    this.newlyUnlockedBadges = const [],
  });
}

class CheckInError extends CheckInState {
  final String message;

  CheckInError(this.message);
}
