abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final String userName;
  final String initials;
  final int currentStreak;
  final int totalPoints;
  final List<bool> completedDays;
  final int currentDayIndex; // من 1 لـ 7 (السبت لـ الجمعة)
  final List<Map<String, dynamic>> activeBattles;
  final List<Map<String, dynamic>> nextUpBattles;
  final bool showAllBattles;

  HomeLoaded({
    required this.userName,
    required this.initials,
    required this.currentStreak,
    required this.totalPoints,
    required this.completedDays,
    required this.currentDayIndex,
    required this.activeBattles,
    required this.nextUpBattles,
    this.showAllBattles = false,
  });

  // دالة علشان نقدر نغير حالة زرار الـ Show More من غير ما نحمل الداتا من تاني
  HomeLoaded copyWith({
    bool? showAllBattles,
  }) {
    return HomeLoaded(
      userName: userName,
      initials: initials,
      currentStreak: currentStreak,
      totalPoints: totalPoints,
      completedDays: completedDays,
      currentDayIndex: currentDayIndex,
      activeBattles: activeBattles,
      nextUpBattles: nextUpBattles,
      showAllBattles: showAllBattles ?? this.showAllBattles,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}