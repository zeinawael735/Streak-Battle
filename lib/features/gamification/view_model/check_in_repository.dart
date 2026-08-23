import 'package:cloud_firestore/cloud_firestore.dart';

class CheckInRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getBattleInfo(String battleId) async {
    final doc = await _firestore.collection('battles').doc(battleId).get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      return {
        'title': data['title'] ?? 'Unknown Battle',
        'goal': data['dailyGoal'] ?? data['goal'] ?? 'No Goal Set',
      };
    }
    return {'title': 'Unknown', 'goal': 'No Goal'};
  }

  Future<Map<String, dynamic>> submitDailyCheckIn({
    required String userId,
    required String battleId,
    required String note,
  }) async {
    final userRef = _firestore.collection('users').doc(userId);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayString =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final checkInDocId = "${userId}_$todayString";

    final checkInRef = _firestore
        .collection('battles')
        .doc(battleId)
        .collection('check_ins')
        .doc(checkInDocId);

    return await _firestore.runTransaction((transaction) async {
      final userSnapshot = await transaction.get(userRef);
      if (!userSnapshot.exists) throw Exception("User not found");

      final checkInSnapshot = await transaction.get(checkInRef);
      if (checkInSnapshot.exists) {
        throw Exception("You have already checked in for this battle today!");
      }

      final userData = userSnapshot.data()!;

      DateTime? lastCheckIn;
      if (userData['lastCheckInDate'] != null) {
        lastCheckIn = (userData['lastCheckInDate'] as Timestamp).toDate();
        lastCheckIn =
            DateTime(lastCheckIn.year, lastCheckIn.month, lastCheckIn.day);
      }

      int currentStreak = userData['currentStreak'] ?? 0;
      bool isFirstCheckInToday = false;

      if (lastCheckIn == null) {
        currentStreak = 1;
        isFirstCheckInToday = true;
      } else if (today.difference(lastCheckIn).inDays == 1) {
        currentStreak += 1;
        isFirstCheckInToday = true;
      } else if (lastCheckIn.isAtSameMomentAs(today)) {
      } else {
        currentStreak = 1;
        isFirstCheckInToday = true;
      }

      int pointsEarned = 10; // Base Points

      if (isFirstCheckInToday && currentStreak > 0 && currentStreak % 3 == 0) {
        pointsEarned += 5;
      }

      int totalPoints = (userData['totalPoints'] ?? 0) + pointsEarned;

      int currentLevel = (totalPoints ~/ 200) + 1;

      transaction.update(userRef, {
        'currentStreak': currentStreak,
        'lastCheckInDate': FieldValue.serverTimestamp(),
        'totalPoints': totalPoints,
        'level': currentLevel,
        'battlesXp.$battleId': FieldValue.increment(pointsEarned),
        'battlesCheckInsCount.$battleId': FieldValue.increment(1),
        'weeklyCheckIns': FieldValue.arrayUnion([todayString]),
      });

      transaction.set(checkInRef, {
        'checkInId': checkInRef.id,
        'userId': userId,
        'battleId': battleId,
        'note': note,
        'checkInDate': FieldValue.serverTimestamp(),
        'isCompleted': true,
      });

      return {
        'pointsEarned': pointsEarned,
        'newStreak': currentStreak,
        'newLevel': currentLevel,
      };
    });
  }
}