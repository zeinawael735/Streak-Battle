import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streak_battle/features/battle/view_model/battle_entity.dart';

class BattleDto {
  final String? id;
  final String title;
  final String category;
  final String? description;
  final DateTime startDate;
  final int durationDays;
  final String dailyGoal;
  final bool isReminderOn;
  final String? reminderTime;
  final bool isInviteOnly;
  final String battleCode;
  final String creatorId;
  final List<String> members;
  final DateTime createdAt;

  BattleDto({
    this.id,
    required this.title,
    required this.category,
    this.description,
    required this.startDate,
    required this.durationDays,
    required this.dailyGoal,
    required this.isReminderOn,
    this.reminderTime,
    required this.isInviteOnly,
    required this.battleCode,
    required this.creatorId,
    required this.members,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'description': description,
      'startDate': Timestamp.fromDate(startDate),
      'durationDays': durationDays,
      'dailyGoal': dailyGoal,
      'isReminderOn': isReminderOn,
      'reminderTime': reminderTime,
      'isInviteOnly': isInviteOnly,
      'battleCode': battleCode,
      'creatorId': creatorId,
      'members': members,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory BattleDto.fromMap(Map<String, dynamic> map, String docId) {
    return BattleDto(
      id: docId,
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      description: map['description'],
      startDate:(map['startDate'] as Timestamp).toDate(),
      durationDays: map['durationDays'] ?? 21,
      dailyGoal: map['dailyGoal'] ?? '',
      isReminderOn: map['isReminderOn'] ?? true,
      reminderTime: map['reminderTime'],
      isInviteOnly: map['isInviteOnly'] ?? true,
      battleCode: map['battleCode'] ?? '',
      creatorId: map['creatorId'] ?? '',
      members: List<String>.from(map['members'] ?? []),
      createdAt:(map['createdAt'] as Timestamp).toDate(),
    );
  }

  BattleEntity toEntity() {
    return BattleEntity(
      title: title ,
      category: category,
      startDate: startDate,
      durationDays: durationDays,
      dailyGoal: dailyGoal,
      isReminderOn: isReminderOn,
      isInviteOnly: isInviteOnly,
      battleCode: battleCode,
      creatorId: creatorId,
      members: members,
      createdAt: createdAt,
    );
  }
}
