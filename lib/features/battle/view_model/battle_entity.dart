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

  factory BattleEntity.fromFirestore(String docId, Map<String, dynamic> data) {
    return BattleEntity(
      id: docId,
      title: data['title'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      startDate: (data['startDate'] != null)
          ? (data['startDate'] as dynamic).toDate()
          : DateTime.now(),
      durationDays: data['durationDays'] ?? 0,
      dailyGoal: data['dailyGoal'] ?? '',
      isReminderOn: data['isReminderOn'] ?? false,
      reminderTime: data['reminderTime'] ?? '',
      isInviteOnly: data['isInviteOnly'] ?? true,
      battleCode: data['battleCode'] ?? '',
      creatorId: data['creatorId'] ?? '',
      members: List<String>.from(data['members'] ?? []),
      createdAt: (data['createdAt'] != null)
          ? (data['createdAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }
}