import '../../view_model/badge_model.dart';

abstract class AchievementsState {}

class AchievementsInitial extends AchievementsState {}

class AchievementsUpdated extends AchievementsState {
  final List<BadgeModel> badges;

  AchievementsUpdated(this.badges);
}
