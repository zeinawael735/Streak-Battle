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
  StreamSubscription? _battlesSub;

  DocumentSnapshot? _userData;
  QuerySnapshot? _battlesData;

  void loadHomeData() {
    emit(HomeLoading());
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      emit(HomeError("User not logged in"));
      return;
    }

    _userSub?.cancel();
    _userSub = _firestore.collection('users').doc(uid).snapshots().listen((userDoc) {
      _userData = userDoc;
      _processAndEmit(uid);
    });

    _battlesSub?.cancel();
    _battlesSub = _firestore
        .collection('battles')
        .where('members', arrayContains: uid)
        .snapshots()
        .listen((battlesSnap) {
      _battlesData = battlesSnap;
      _processAndEmit(uid);
    });
  }

  Future<void> _processAndEmit(String uid) async {
    if (_userData == null || _battlesData == null) return;
    if (!_userData!.exists) return;

    try {
      final userData = _userData!.data() as Map<String, dynamic>;

      final String name = userData['name'] ?? 'User';
      final String initials = name.isNotEmpty ? name.trim().split(' ').map((e) => e[0].toUpperCase()).take(2).join() : 'U';
      final int currentStreak = userData['currentStreak'] ?? 0;
      final int totalPoints = userData['totalPoints'] ?? 0;

      List<String> weeklyCheckIns = List<String>.from(userData['weeklyCheckIns'] ?? []);
      DateTime now = DateTime.now();

      int daysToSubtract = (now.weekday == DateTime.saturday)
          ? 0
          : (now.weekday % 7) + 1;

      DateTime startOfWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: daysToSubtract));

      List<bool> completedDays = [];
      int currentDayIndex = daysToSubtract + 1;

      for (int i = 0; i < 7; i++) {
        DateTime day = startOfWeek.add(Duration(days: i));
        String dayStr = "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
        completedDays.add(weeklyCheckIns.contains(dayStr));
      }

      List<Map<String, dynamic>> activeBattles = [];
      List<Map<String, dynamic>> nextUpBattles = [];

      for (var doc in _battlesData!.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final battleId = doc.id;

        DateTime startDate = (data['startDate'] as Timestamp).toDate();
        int durationDays = data['durationDays'] ?? 21;

        DateTime today = DateTime(now.year, now.month, now.day);
        DateTime start = DateTime(startDate.year, startDate.month, startDate.day);

        int currentDayOfBattle = today.difference(start).inDays + 1;

        if (currentDayOfBattle > durationDays) {
          continue;
        }

        if (currentDayOfBattle < 1) currentDayOfBattle = 1;

        final checkInsSnap = await _firestore.collection('battles').doc(battleId).collection('check_ins').where('userId', isEqualTo: uid).get();
        int checkInsCount = checkInsSnap.docs.length;
        int progress = durationDays > 0 ? ((checkInsCount / durationDays) * 100).round().clamp(0, 100) : 0;

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

        if (!checkedInToday) {
          nextUpBattles.add(battleInfo);
        }
      }

      bool currentShowAll = false;
      bool currentShowAllNextUp = false;

      if (state is HomeLoaded) {
        currentShowAll = (state as HomeLoaded).showAllBattles;
        currentShowAllNextUp = (state as HomeLoaded).showAllNextUpBattles;
      }

      emit(HomeLoaded(
        userName: name.split(' ')[0],
        initials: initials,
        currentStreak: currentStreak,
        totalPoints: totalPoints,
        completedDays: completedDays,
        currentDayIndex: currentDayIndex,
        activeBattles: activeBattles,
        nextUpBattles: nextUpBattles,
        showAllBattles: currentShowAll,
        showAllNextUpBattles: currentShowAllNextUp,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void toggleShowAllBattles() {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(showAllBattles: !currentState.showAllBattles));
    }
  }

  void toggleShowAllNextUpBattles() {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(currentState.copyWith(showAllNextUpBattles: !currentState.showAllNextUpBattles));
    }
  }

  @override
  Future<void> close() {
    _userSub?.cancel();
    _battlesSub?.cancel();
    return super.close();
  }
}