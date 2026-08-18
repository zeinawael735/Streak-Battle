import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../notification/view_model/notification_services.dart';
import 'battle_dto.dart';
import 'battle_entity.dart';
import 'create_battle_state.dart';

class CreateBattleCubit extends Cubit<CreateBattleState> {
  CreateBattleCubit() : super(CreateBattleInitial());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void>createBattle(BattleEntity battle)async {
    emit(CreateBattleLoading());
    try{
      final currentUserId = _auth.currentUser?.uid ?? '';

      final docRef = _firestore.collection('battles').doc();
      final updatedMembers = List<String>.from(battle.members);
      if (currentUserId.isNotEmpty && !updatedMembers.contains(currentUserId)) {
        updatedMembers.add(currentUserId);
      }

      final battleDto = BattleDto(
        id: docRef.id,
        title: battle.title,
        category: battle.category,
        description: battle.description,
        startDate: battle.startDate,
        durationDays: battle.durationDays,
        dailyGoal: battle.dailyGoal,
        isReminderOn: battle.isReminderOn,
        reminderTime: battle.reminderTime,
        isInviteOnly: battle.isInviteOnly,
        battleCode: battle.battleCode,
        creatorId: currentUserId.isNotEmpty ? currentUserId : battle.creatorId,
        members: updatedMembers,
        createdAt: DateTime.now(),
      );



      await docRef.set(battleDto.toMap());
      if (battle.isReminderOn) {
        final timeParts = battle.reminderTime.split(':');
        final reminderTimeOfDay = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );

        await NotificationService.scheduleBattleReminders(
          battleId: docRef.id,
          title: battle.title,
          startDate: battle.startDate,
          durationDays: battle.durationDays,
          reminderTime: reminderTimeOfDay,
        );
      }
      emit(CreateBattleSuccess());
    }catch(e){
      emit(CreateBattleError(e.toString()));
    }
  }

}