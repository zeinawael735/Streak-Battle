class UserModel {
  final String uid;
  final String displayName;
  final int xp;
  final int currentStreak;
  final int rank;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.xp,
    required this.currentStreak,
    this.rank = 0,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String docId) {

    int parseNum(dynamic value) {
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return UserModel(
      uid: (data['uid'] ?? docId).toString().replaceAll('"', '').trim(),
      displayName: (data['name']  ?? 'User').toString(),
      xp: parseNum(data['xp']),
      currentStreak: parseNum(data['currentStreak']),
    );
  }

  UserModel copyWith({int? rank}) {
    return UserModel(
      uid: uid,
      displayName: displayName,
      xp: xp,
      currentStreak: currentStreak,
      rank: rank ?? this.rank,
    );
  }
}