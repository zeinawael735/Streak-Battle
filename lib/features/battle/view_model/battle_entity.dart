class BattleEntity {
  final String id;
  final String title;
  final String category;
  final String description;
  final DateTime startDate;
  final int durationDays;
  final String dailyGoal;
  final bool isReminderOn;
  final String reminderTime;
  final bool isInviteOnly;
  final String battleCode;
  final String creatorId;
  final List<String> members;
  final DateTime createdAt;

  BattleEntity({
    this.id='',
    required this.title,
    required this.category,
    this.description='',
    required this.startDate,
    required this.durationDays,
    required this.dailyGoal,
    required this.isReminderOn,
    this.reminderTime='',
    required this.isInviteOnly,
    required this.battleCode,
    required this.creatorId,
    required this.members,
    required this.createdAt,
  });




}