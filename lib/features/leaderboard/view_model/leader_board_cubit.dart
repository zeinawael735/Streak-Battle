import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_battle/features/leaderboard/view_model/leader_board_state.dart';
import 'package:streak_battle/features/leaderboard/view_model/user_model.dart';

class LeaderboardCubit extends Cubit<LeaderBoardState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription? _subscription;

  LeaderboardCubit() : super(LeaderBoardInitial());

  void fetchLeaderboard({required String battleId}) async {
    emit(LeaderBoardLoading());

    await _subscription?.cancel();

    try {
      final currentUserId = _auth.currentUser?.uid;

      if (currentUserId == null || currentUserId.isEmpty) {
        emit(LeaderBoardError("You Are Not Logged in"));
        return;
      }

      final battleDoc = await _firestore
          .collection('battles')
          .doc(battleId)
          .get();

      if (!battleDoc.exists) {
        emit(LeaderBoardError("Battle Not Found"));
        return;
      }

      final battleData = battleDoc.data();

      if (battleData == null) {
        emit(LeaderBoardError("Battle Details are not  found"));
        return;
      }

      final List<String> memberIds = List<String>.from(
        battleData['members'] ?? [],
      );
      final String creatorId = battleData['creatorId'] ?? '';

      final bool isMember = memberIds.contains(currentUserId);
      final bool isCreator = creatorId == currentUserId;

      if (!isMember && !isCreator) {
        emit(LeaderBoardError("You Are Not a Member Of This Battle"));
        return;
      }

      final Set<String> queryUserIds = Set<String>.from(memberIds);
      if (creatorId.isNotEmpty) {
        queryUserIds.add(creatorId);
      }

      if (queryUserIds.isEmpty) {
        emit(LeaderBoardSuccess(const [], const [], null));
        return;
      }

      final query = _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: queryUserIds.toList());

      _subscription = query.snapshots().listen(
        (snapshot) {
          try {
            List<UserModel> allFetchedUsers = snapshot.docs
                .map(
                  (doc) => UserModel.fromFirestore(
                    doc.data(),
                    doc.id,
                    battleId: battleId,
                  ),
                )
                .toList();

            List<UserModel> leaderboardUsers = allFetchedUsers.toList();

            leaderboardUsers.sort((a, b) {
              if (b.xp != a.xp) {
                return b.xp.compareTo(a.xp);
              }

              if (b.currentStreak != a.currentStreak) {
                return b.currentStreak.compareTo(a.currentStreak);
              }

              if (a.lastCheckInDate != null && b.lastCheckInDate != null) {
                return a.lastCheckInDate!.compareTo(b.lastCheckInDate!);
              }

              if (a.lastCheckInDate != null && b.lastCheckInDate == null)
                return -1;
              if (a.lastCheckInDate == null && b.lastCheckInDate != null)
                return 1;

              return 0;
            });

            for (int i = 0; i < leaderboardUsers.length; i++) {
              leaderboardUsers[i] = leaderboardUsers[i].copyWith(rank: i + 1);
            }

            final top3 = leaderboardUsers.take(3).toList();
            final remaining = leaderboardUsers.length > 3
                ? leaderboardUsers.sublist(3)
                : <UserModel>[];

            UserModel? currentUserModel;
            try {
              currentUserModel = leaderboardUsers.firstWhere(
                (u) => u.uid == currentUserId,
              );
            } catch (_) {
              currentUserModel = null;
            }

            emit(LeaderBoardSuccess(top3, remaining, currentUserModel));
          } catch (e) {
            emit(LeaderBoardError(e.toString()));
          }
        },
        onError: (e) {
          emit(LeaderBoardError(e.toString()));
        },
      );
    } catch (e) {
      emit(LeaderBoardError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

/// Fetches the uid of the top-ranked participant (winner) of a given battle.
/// Uses a one-time Future (not a Stream) so it can be awaited directly,
/// e.g. from a button's onPressed. Ranking logic is identical to
/// LeaderboardCubit.fetchLeaderboard: xp desc -> currentStreak desc -> lastCheckInDate asc.
Future<String?> getBattleWinnerId(String battleId) async {
  final firestore = FirebaseFirestore.instance;

  final battleDoc = await firestore.collection('battles').doc(battleId).get();
  if (!battleDoc.exists) return null;

  final battleData = battleDoc.data();
  if (battleData == null) return null;

  final List<String> memberIds = List<String>.from(battleData['members'] ?? []);
  final String creatorId = battleData['creatorId'] ?? '';

  final Set<String> queryUserIds = Set<String>.from(memberIds);
  if (creatorId.isNotEmpty) queryUserIds.add(creatorId);

  if (queryUserIds.isEmpty) return null;

  final usersSnapshot = await firestore
      .collection('users')
      .where(FieldPath.documentId, whereIn: queryUserIds.toList())
      .get();

  if (usersSnapshot.docs.isEmpty) return null;

  final users = usersSnapshot.docs
      .map((doc) => UserModel.fromFirestore(doc.data(), doc.id, battleId: battleId))
      .toList();

  users.sort((a, b) {
    if (b.xp != a.xp) {
      return b.xp.compareTo(a.xp);
    }

    if (b.currentStreak != a.currentStreak) {
      return b.currentStreak.compareTo(a.currentStreak);
    }

    if (a.lastCheckInDate != null && b.lastCheckInDate != null) {
      return a.lastCheckInDate!.compareTo(b.lastCheckInDate!);
    }

    if (a.lastCheckInDate != null && b.lastCheckInDate == null) return -1;
    if (a.lastCheckInDate == null && b.lastCheckInDate != null) return 1;

    return 0;
  });

  return users.isNotEmpty ? users.first.uid : null;
}