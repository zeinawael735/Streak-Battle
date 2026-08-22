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
  final bool showAllNextUpBattles; // المتغير الجديد

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
    this.showAllNextUpBattles = false, // القيمة الافتراضية
  });

  // تحديث الدالة علشان تدعم المتغير الجديد
  HomeLoaded copyWith({
    bool? showAllBattles,
    bool? showAllNextUpBattles,
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
      showAllNextUpBattles: showAllNextUpBattles ?? this.showAllNextUpBattles,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}