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
  final int battlesCount; // TODO: not in schema yet, placeholder 0
  final String rankLabel; // TODO: not in schema yet, placeholder text
  final List<double> activityLastWeek; // TODO: not in schema yet, placeholder zeros
  final List<String> favoriteHabits; // TODO: not in schema yet, placeholder list
  final int achievementsUnlocked; // TODO: not in schema yet
  final int achievementsTotal; // TODO: not in schema yet

  const ProfileLoaded({
    required this.name,
    required this.wins,
    required this.currentStreak,
    this.battlesCount = 0,
    this.rankLabel = 'Level 1 Challenger',
    this.activityLastWeek = const [0, 0, 0, 0, 0, 0, 0],
    this.favoriteHabits = const [],
    this.achievementsUnlocked = 0,
    this.achievementsTotal = 0,
  });

  @override
  List<Object?> get props => [
    name,
    wins,
    currentStreak,
    battlesCount,
    rankLabel,
    activityLastWeek,
    favoriteHabits,
    achievementsUnlocked,
    achievementsTotal,
  ];
}