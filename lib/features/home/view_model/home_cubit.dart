import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  StreamSubscription? _userSub;

  void loadHomeData() {
    emit(HomeLoading());
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      emit(HomeError("User not logged in"));
      return;
    }

    // بنستمع لتغييرات اليوزر علشان لما يعمل Check-in الشاشة تتحدث فوراً
    _userSub?.cancel();
    _userSub = _firestore.collection('users').doc(uid).snapshots().listen((userDoc) async {
      try {
        if (!userDoc.exists) return;
        final userData = userDoc.data()!;

        // 1. الداتا الأساسية
        final String name = userData['name'] ?? 'User';
        final String initials = name.isNotEmpty ? name.trim().split(' ').map((e) => e[0].toUpperCase()).take(2).join() : 'U';
        final int currentStreak = userData['currentStreak'] ?? 0;
        final int totalPoints = userData['totalPoints'] ?? 0;

        // 2. حساب الأيام للأسبوع الحالي (بافتراض الأسبوع يبدأ السبت)
        List<String> weeklyCheckIns = List<String>.from(userData['weeklyCheckIns'] ?? []);
        DateTime now = DateTime.now();
        // يوم 1 في Dart هو الاتنين، ويوم 7 هو الأحد. إحنا عايزين السبت يكون البداية.
        int daysToSubtract = (now.weekday + 1) % 7;
        DateTime startOfWeek = now.subtract(Duration(days: daysToSubtract));

        List<bool> completedDays = [];
        int currentDayIndex = daysToSubtract + 1; // هيكون من 1 لـ 7

        for (int i = 0; i < 7; i++) {
          DateTime day = startOfWeek.add(Duration(days: i));
          String dayStr = "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
          // لو التاريخ موجود في المصفوفة، يبقى عمل check-in
          completedDays.add(weeklyCheckIns.contains(dayStr));
        }

        // 3. جلب وتصفية التحديات
        List<Map<String, dynamic>> activeBattles = [];
        List<Map<String, dynamic>> nextUpBattles = [];
        final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

        final battlesSnap = await _firestore.collection('battles').where('members', arrayContains: uid).get();

        for (var doc in battlesSnap.docs) {
          final data = doc.data();
          final battleId = doc.id;

          DateTime startDate = (data['startDate'] as Timestamp).toDate();
          int durationDays = data['durationDays'] ?? 21;
          DateTime endDate = startDate.add(Duration(days: durationDays));

          // تخطي التحديات المنتهية
          if (now.isAfter(endDate) && now.difference(endDate).inDays >= 1) continue;

          // جلب عدد مرات الحضور لحساب النسبة ومعرفة إذا كان حضر اليوم
          final checkInsSnap = await _firestore.collection('battles').doc(battleId).collection('check_ins').where('userId', isEqualTo: uid).get();
          int checkInsCount = checkInsSnap.docs.length;
          int progress = durationDays > 0 ? ((checkInsCount / durationDays) * 100).round().clamp(0, 100) : 0;

          int currentDayOfBattle = now.difference(startDate).inDays + 1;
          if (currentDayOfBattle < 1) currentDayOfBattle = 1;
          if (currentDayOfBattle > durationDays) currentDayOfBattle = durationDays;

          // هل عمل Check-in النهاردة في التحدي ده؟
          bool checkedInToday = false;
          for (var checkInDoc in checkInsSnap.docs) {
            final checkInData = checkInDoc.data();
            final checkInDate = (checkInData['checkInDate'] as Timestamp?)?.toDate();
            if (checkInDate != null && checkInDate.year == now.year && checkInDate.month == now.month && checkInDate.day == now.day) {
              checkedInToday = true;
              break;
            }
          }

          final battleInfo = {
            'id': battleId,
            'title': data['title'] ?? 'Streak Battle',
            'category': data['category'] ?? 'Custom',
            'goal': data['dailyGoal'] ?? data['goal'] ?? '',
            'progress': progress,
            'currentDay': currentDayOfBattle,
            'durationDays': durationDays,
            'participantsCount': (data['members'] as List).length,
          };

          activeBattles.add(battleInfo);

          // لو لسه معملش Check-in النهاردة، حطه في الـ Next Up
          if (!checkedInToday) {
            nextUpBattles.add(battleInfo);
          }
        }

        // الحفاظ على حالة زرار الـ Show More لو كانت الشاشة متحملة قبل كده
        bool currentShowAll = false;
        if (state is HomeLoaded) {
          currentShowAll = (state as HomeLoaded).showAllBattles;
        }

        emit(HomeLoaded(
          userName: name.split(' ')[0], // أول اسم فقط
          initials: initials,
          currentStreak: currentStreak,
          totalPoints: totalPoints,
          completedDays: completedDays,
          currentDayIndex: currentDayIndex,
          activeBattles: activeBattles,
          nextUpBattles: nextUpBattles,
          showAllBattles: currentShowAll,
        ));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }

  void toggleShowAllBattles() {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(showAllBattles: !currentState.showAllBattles));
    }
  }

  @override
  Future<void> close() {
    _userSub?.cancel();
    return super.close();
  }
}