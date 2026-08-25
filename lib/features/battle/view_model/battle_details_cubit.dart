import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:streak_battle/features/battle/view_model/battle_entity.dart'; // مسار الـ Entity بتاعك
import '../view/widgets/battle_details_screen_widgets.dart';

part 'battle_details_state.dart';

class BattleDetailsCubit extends Cubit<BattleDetailsState> {
  BattleDetailsCubit() : super(BattleDetailsInitial());

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  StreamSubscription? _battleSub;
  StreamSubscription? _usersSub;
  StreamSubscription? _myCheckInsSub;
  StreamSubscription? _todayCheckInsSub;

  BattleEntity? _battleEntity;
  String _category = 'Fitness';

  List<DocumentSnapshot> _users = [];
  List<DocumentSnapshot> _myCheckIns = [];
  List<DocumentSnapshot> _todayCheckIns = [];

  String _battleId = '';

  void loadBattleDetails(String battleId) {
    if (battleId.isEmpty) {
      emit(BattleDetailsError("undefined"));
      return;
    }

    _battleId = battleId;
    emit(BattleDetailsLoading());

    final currentUserId = _auth.currentUser?.uid ?? '';
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);

    _battleSub = _firestore.collection('battles').doc(_battleId).snapshots().listen((battleSnap) {
      if (!battleSnap.exists) {
        emit(BattleDetailsError("does not exist"));
        return;
      }

      final data = battleSnap.data() as Map<String, dynamic>;
      _battleEntity = BattleEntity.fromFirestore(battleSnap.id, data);

      _category = data['category'] ?? 'Fitness';

      final membersIds = _battleEntity!.members;
      _listenToUsers(membersIds);
      _listenToCheckIns(currentUserId, startOfToday);

      _emitCombinedState();
    });
  }

  void _listenToUsers(List<String> membersIds) {
    _usersSub?.cancel();
    if (membersIds.isNotEmpty) {
      _usersSub = _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: membersIds.take(10).toList())
          .snapshots()
          .listen((usersSnap) {
        _users = usersSnap.docs;
        _emitCombinedState();
      });
    }
  }

  void _listenToCheckIns(String currentUserId, DateTime startOfToday) {
    _myCheckInsSub ??= _firestore
        .collection('battles')
        .doc(_battleId)
        .collection('check_ins')
        .where('userId', isEqualTo: currentUserId)
        .snapshots()
        .listen((snap) {
      _myCheckIns = snap.docs;
      _emitCombinedState();
    });

    _todayCheckInsSub ??= _firestore
        .collection('battles')
        .doc(_battleId)
        .collection('check_ins')
        .where('checkInDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfToday))
        .snapshots()
        .listen((snap) {
      _todayCheckIns = snap.docs;
      _emitCombinedState();
    });
  }

  void _emitCombinedState() {
    if (_battleEntity == null) return;

    final String title = _battleEntity!.title;
    final String goal = _battleEntity!.dailyGoal;
    final String battleCode = _battleEntity!.battleCode;
    final int durationDays = _battleEntity!.durationDays;
    final List<String> membersIds = _battleEntity!.members;

    final DateTime startDate = _battleEntity!.startDate;
    final DateTime endDate = startDate.add(Duration(days: durationDays));
    final bool isFinished = DateTime.now().isAfter(endDate);
    final String formattedEndDate = DateFormat('MMM dd, yyyy').format(endDate);

    int currentDay = DateTime.now().difference(startDate).inDays + 1;
    if (currentDay < 1) currentDay = 1;
    if (currentDay > durationDays) currentDay = durationDays;

    int myCheckInsCount = _myCheckIns.length;
    double progressValue = (myCheckInsCount / durationDays).clamp(0.0, 1.0);

    List<Participant> participants = _users.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final name = data['name'] ?? 'Unknown';
      final initials = name.isNotEmpty
          ? name.trim().split(' ').map((e) => e[0].toUpperCase()).take(2).join()
          : 'U';
      return Participant(initials: initials, name: name);
    }).toList();


    Map<String, Participant> userMap = {
      for (var doc in _users) doc.id: Participant(
          initials: (doc.data() as Map<String, dynamic>)['name']?.trim().split(' ').map((e) => e.toString()[0].toUpperCase()).take(2).join() ?? 'U',
          name: (doc.data() as Map<String, dynamic>)['name'] ?? 'Unknown'
      )
    };

    List<CheckInViewData> todayCheckInsView = _todayCheckIns.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final String uId = data['userId'] ?? '';
      final participant = userMap[uId] ?? const Participant(initials: 'U', name: 'User');

      String timeAgo = "just now";
      if (data['checkInDate'] != null) {
        final checkInTime = (data['checkInDate'] as Timestamp).toDate();
        final diff = DateTime.now().difference(checkInTime);

        if (diff.inMinutes == 0) {
          timeAgo = "just now";
        } else if (diff.inMinutes < 60) {
          timeAgo = "just ${diff.inMinutes} min ago";
        } else {
          timeAgo = "just ${diff.inHours} hours ago";
        }
      }

      return CheckInViewData(
        name: participant.name,
        initials: participant.initials,
        goal: data['note'] ?? goal,
        timeAgo: timeAgo,
      );
    }).toList();

    emit(BattleDetailsLoaded(
      title: title,
      category: _category,
      goal: goal,
      battleCode: battleCode,
      durationDays: durationDays,
      isFinished: isFinished,
      formattedEndDate: formattedEndDate,
      currentDay: currentDay,
      progressValue: progressValue,
      myCheckInsCount: myCheckInsCount,
      participants: participants,
      participantsCount: membersIds.length,
      displayCount: participants.length > 4 ? 4 : participants.length,
      remainingCount: membersIds.length - (participants.length > 4 ? 4 : participants.length),
      todayCheckIns: todayCheckInsView,
    ));
  }

  @override
  Future<void> close() {
    _battleSub?.cancel();
    _usersSub?.cancel();
    _myCheckInsSub?.cancel();
    _todayCheckInsSub?.cancel();
    return super.close();
  }
}