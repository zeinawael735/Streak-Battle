import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String displayName;
  final int xp;
  final int currentStreak;
  final int rank;
  final DateTime? lastCheckInDate;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.xp,
    required this.currentStreak,
    this.rank = 0,
    this.lastCheckInDate,
  });

  factory UserModel.fromFirestore(
      Map<String, dynamic> data,
      String docId, {
        String? battleId,
      }) {
    int parseNum(dynamic value) {
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }


    int calculatedXp = 0;
    if (battleId != null && data['battlesXp'] is Map) {
      final battlesXpMap = data['battlesXp'] as Map<String, dynamic>;
      calculatedXp = parseNum(battlesXpMap[battleId]);
    } else {
      calculatedXp = parseNum(data['xp'] ?? data['totalPoints']);
    }


    int calculatedStreak = 0;
    if (battleId != null && data['battlesCheckInsCount'] is Map) {
      final checkInsMap = data['battlesCheckInsCount'] as Map<String, dynamic>;
      calculatedStreak = parseNum(checkInsMap[battleId]);
    } else {
      calculatedStreak = parseNum(data['currentStreak']);
    }


    DateTime? checkInDate;
    if (data['lastCheckInDate'] is Timestamp) {
      checkInDate = (data['lastCheckInDate'] as Timestamp).toDate();
    }

    return UserModel(
      uid: (data['uid'] ?? docId).toString().replaceAll('"', '').trim(),
      displayName: (data['name'] ?? 'User').toString(),
      xp: calculatedXp,
      currentStreak: calculatedStreak,
      lastCheckInDate: checkInDate,
    );
  }

  UserModel copyWith({int? rank}) {
    return UserModel(
      uid: uid,
      displayName: displayName,
      xp: xp,
      currentStreak: currentStreak,
      rank: rank ?? this.rank,
      lastCheckInDate: lastCheckInDate,
    );
  }
}