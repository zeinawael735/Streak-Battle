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
    } else if (code.length < 6) {
      emit(JoinBattlePartial());
    }
  }

  Future<void> findBattle(String code) async {
    if (code.length != 6) {
      emit(JoinBattleInvalid());
      return;
    }
    emit(JoinBattleLoading());
    try {
      final query = await _firestore
          .collection('battles')
          .where('code', isEqualTo: code.toUpperCase())
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        emit(JoinBattleInvalid());
        return;
      }

      final doc = query.docs.first;
      final battle = BattleEntity.fromFirestore(doc.id, doc.data());

      if (battle.status != 'active') {
        emit(JoinBattleExpired());
        return;
      }

      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final participantDoc = await _firestore
            .collection('battles')
            .doc(battle.id)
            .collection('participants')
            .doc(userId)
            .get();
        if (participantDoc.exists) {
          emit(JoinBattleAlreadyJoined());
          return;
        }
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
      await _firestore
          .collection('battles')
          .doc(battle.id)
          .collection('participants')
          .doc(userId)
          .set({
        'userId': userId,
        'joinedAt': FieldValue.serverTimestamp(),
        'streak': 0,
        'points': 0,
      });

      await _firestore.collection('battles').doc(battle.id).update({
        'participantsCount': FieldValue.increment(1),
      });

      emit(JoinBattleJoined(battle.id));
    } catch (_) {
      emit(JoinBattleInvalid());
    }
  }
}