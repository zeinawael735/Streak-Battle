import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'battle_entity.dart';
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

      final query = await _firestore
          .collection('battles')
          .where('battleCode', isEqualTo: normalizedCode)
          .limit(1)
          .get();

      log(query.docs.isEmpty.toString());

      if (query.docs.isEmpty) {
        emit(JoinBattleInvalid());
        return;
      }
      final doc = query.docs.first;
      final battle = BattleEntity.fromFirestore(doc.id, doc.data());
      final userId = _auth.currentUser?.uid;

      if (userId != null && battle.members.contains(userId)) {
        emit(JoinBattleAlreadyJoined());
        return;
      }

      _foundBattle = battle;
      emit(JoinBattlePreview(battle));
    } catch (e) {
      log(e.toString());
      emit(JoinBattleInvalid());
    }
  }

  Future<void> joinBattle() async {
    final battle = _foundBattle;
    final userId = _auth.currentUser?.uid;
    if (battle == null || userId == null) return;

    emit(JoinBattleLoading());
    try {
      await _firestore.collection('battles').doc(battle.id).update({
        'members': FieldValue.arrayUnion([userId]),
      });

      await _firestore.collection('users').doc(userId).update({
        'battlesXp.${battle.id}': 0,
      });

      emit(JoinBattleJoined(battle.id));
    } catch (_) {
      emit(JoinBattleInvalid());
    }
  }
}