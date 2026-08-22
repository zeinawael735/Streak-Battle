import 'package:cloud_firestore/cloud_firestore.dart';

class CheckInRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> submitDailyCheckIn({
    required String userId,
    required String battleId,
    required String note,
  }) async {
    final userRef = _firestore.collection('users').doc(userId);

    // 1. تجهيز تاريخ اليوم لصناعة ID مميز يمنع تكرار الـ Check-in لنفس الـ Battle
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayString =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    // الـ ID هيكون عبارة عن (رقم اليوزر + تاريخ اليوم)
    final checkInDocId = "${userId}_$todayString";

    final checkInRef = _firestore
        .collection('battles')
        .doc(battleId)
        .collection('check_ins') // Subcollection داخل الـ Battle
        .doc(checkInDocId);

    return await _firestore.runTransaction((transaction) async {
      // قراءة بيانات المستخدم
      final userSnapshot = await transaction.get(userRef);
      if (!userSnapshot.exists) throw Exception("User not found");

      // فحص إذا كان اليوزر عمل Check-in في الـ Battle دي تحديداً النهاردة
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

      // 2. حساب الـ Streak (بناءً على currentStreak)
      int currentStreak = userData['currentStreak'] ?? 0;
      bool isFirstCheckInToday = false;

      if (lastCheckIn == null) {
        currentStreak = 1; // أول مرة خالص
        isFirstCheckInToday = true;
      } else if (today.difference(lastCheckIn).inDays == 1) {
        currentStreak += 1; // يوم متتالي جديد
        isFirstCheckInToday = true;
      } else if (lastCheckIn.isAtSameMomentAs(today)) {
        // عمل Check-in في معركة تانية النهاردة.. الـ Streak يفضل زي ما هو بدون زيادة
      } else {
        currentStreak = 1; // الـ Streak اتكسر، نبدأ من 1
        isFirstCheckInToday = true;
      }

      // 3. حساب النقاط
      int pointsEarned = 10; // Base Points

      // Streak Bonus (كل 3 أيام) - بيتحسب لو ده أول تشيك إن ليه في اليوم بس
      if (isFirstCheckInToday && currentStreak > 0 && currentStreak % 3 == 0) {
        pointsEarned += 5;
      }

      int totalPoints = (userData['totalPoints'] ?? 0) + pointsEarned;
      int xp = (userData['xp'] ?? 0) + pointsEarned;
      int currentLevel = (xp ~/ 200) + 1;

      transaction.update(userRef, {
        'currentStreak': currentStreak, // تم التعديل
        'lastCheckInDate': FieldValue.serverTimestamp(),
        'totalPoints': totalPoints,
        'xp': xp,
        'level': currentLevel,
        'battlesXp.$battleId': FieldValue.increment(pointsEarned),
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