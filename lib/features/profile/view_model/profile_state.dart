import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
  @override
  List<Object?> get props => [message];
}

class ProfileLoaded extends ProfileState {
  final String name;
  final int wins;
  final int currentStreak;
  final int level;
  final int totalPoints;
  final int battlesCount;
  final List<double> activityLastWeek; // 7 values, 1 = check-in day, 0 = no check-in
  final String rankLabel; // TODO: waiting on Zeina for rank logic
  final List<String> favoriteHabits; // TODO: postponed
  final int achievementsUnlocked; // TODO: postponed
  final int achievementsTotal; // TODO: postponed

  const ProfileLoaded({
    required this.name,
    required this.wins,
    required this.currentStreak,
    required this.level,
    required this.totalPoints,
    required this.battlesCount,
    required this.activityLastWeek,
    this.rankLabel = 'Level', // will be combined with level number in UI
    this.favoriteHabits = const [],
    this.achievementsUnlocked = 0,
    this.achievementsTotal = 0,
  });

  @override
  List<Object?> get props => [
    name,
    wins,
    currentStreak,
    level,
    totalPoints,
    battlesCount,
    activityLastWeek,
    rankLabel,
    favoriteHabits,
    achievementsUnlocked,
    achievementsTotal,
  ];
}