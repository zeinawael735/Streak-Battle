import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_battle/core/common/common.dart';
import 'join_battle_state.dart';

class JoinBattleCubit extends Cubit<JoinBattleState> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  BattleEntity? _foundBattle;

  JoinBattleCubit({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        super(JoinBattleEmpty());

  void onCodeChanged(String code) {
    if (code.isEmpty) {
      emit(JoinBattleEmpty());
    } else if (code.length < 8) {
      emit(JoinBattlePartial());
    }
  }

  Future<void> findBattle(String code) async {
    if (code.length != 8) {
      emit(JoinBattleInvalid());
      return;
    }
    emit(JoinBattleLoading());
    try {
      final normalizedCode = code.toUpperCase();

      var query = await _firestore
          .collection('battles')
          .where('battleCode', isEqualTo: normalizedCode)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        query = await _firestore
            .collection('battles')
            .where('battleCode', isEqualTo: 'BAT-$normalizedCode')
            .limit(1)
            .get();
      }

      if (query.docs.isEmpty) {
        emit(JoinBattleInvalid());
        return;
      }

      final doc = query.docs.first;
      final battle = BattleEntity.fromFirestore(doc.id, doc.data());

      final initials = await _getUserInitials();
      if (initials != null && battle.members.contains(initials)) {
        emit(JoinBattleAlreadyJoined());
        return;
      }

      _foundBattle = battle;
      emit(JoinBattlePreview(battle));
    } catch (_) {
      emit(JoinBattleInvalid());
    }
  }

  Future<void> joinBattle() async {
    final battle = _foundBattle;
    final userId = _auth.currentUser?.uid;
    if (battle == null || userId == null) return;

    emit(JoinBattleLoading());
    try {
      final initials = await _getUserInitials();
      if (initials == null) {
        emit(JoinBattleInvalid());
        return;
      }

      await _firestore.collection('battles').doc(battle.id).update({
        'members': FieldValue.arrayUnion([initials]),
      });

      emit(JoinBattleJoined(battle.id));
    } catch (_) {
      emit(JoinBattleInvalid());
    }
  }

  // Fetches the current user's name from Firestore `users` collection
  // and returns initials, e.g. "rahma salama" -> "RS".
  Future<String?> _getUserInitials() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return null;

    final userDoc = await _firestore.collection('users').doc(userId).get();
    final name = userDoc.data()?['name'] as String?;
    if (name == null || name.trim().isEmpty) return null;

    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return (parts.first[0] + parts.last[0]).toUpperCase();
    }
    return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
  }
}