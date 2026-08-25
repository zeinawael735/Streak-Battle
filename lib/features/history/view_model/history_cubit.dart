import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial());

  StreamSubscription? _battlesSubscription;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void fetchUserBattles() {
    emit(HistoryLoading());
    final currentUserId = _auth.currentUser?.uid;

    if (currentUserId == null || currentUserId.isEmpty) {
      emit(HistoryError("User not logged in"));
      return;
    }

    _battlesSubscription?.cancel();

    _battlesSubscription = _firestore
        .collection('battles')
        .snapshots()
        .listen(
          (snapshot) async {
        try {
          final userBattles = snapshot.docs.where((doc) {
            final data = doc.data();
            final List participants = data['members'] ?? [];
            final String createdBy = data['creatorId'] ?? '';

            return participants.contains(currentUserId) || createdBy == currentUserId;
          }).toList();

          List<Map<String, dynamic>> processedBattles = [];

          for (var doc in userBattles) {
            final data = doc.data();
            final battleId = doc.id;

            DateTime startDate = (data['startDate'] != null)
                ? (data['startDate'] as Timestamp).toDate()
                : DateTime.now();
            int durationDays = data['durationDays'] ?? 21;
            DateTime endDate = startDate.add(Duration(days: durationDays));

            String formattedDuration =
                "${DateFormat('MMM dd').format(startDate)} - ${DateFormat('MMM dd').format(endDate)}";

            final checkInsSnap = await _firestore
                .collection('battles')
                .doc(battleId)
                .collection('check_ins')
                .where('userId', isEqualTo: currentUserId)
                .get();

            int checkInsCount = checkInsSnap.docs.length;
            int progressPercent = durationDays > 0
                ? ((checkInsCount / durationDays) * 100).round().clamp(0, 100)
                : 0;

            processedBattles.add({
              'id': battleId,
              'title': data['title'] ?? 'Streak Challenge',
              'duration': formattedDuration,
              'progress': progressPercent,
              'rank': 1,
              'category': data['category'] ?? '',
              'endDate': endDate,
            });
          }

          // ترتيب الـ Battles
          processedBattles.sort((a, b) {
            DateTime now = DateTime.now();
            DateTime endA = a['endDate'];
            DateTime endB = b['endDate'];

            bool isAFinished = endA.isBefore(now);
            bool isBFinished = endB.isBefore(now);

            if (isAFinished && !isBFinished) return 1;
            if (!isAFinished && isBFinished) return -1;

            if (!isAFinished && !isBFinished) {
              return endA.compareTo(endB);
            } else {
              return endB.compareTo(endA);
            }
          });

          if (!isClosed) {
            emit(HistorySuccess(processedBattles));
          }
        } catch (e) {
          if (!isClosed) emit(HistoryError(e.toString()));
        }
      },
      onError: (error) {
        if (!isClosed) emit(HistoryError(error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _battlesSubscription?.cancel();
    return super.close();
  }
}