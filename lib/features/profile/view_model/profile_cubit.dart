import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  StreamSubscription? _subscription;

  ProfileCubit({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        super(ProfileLoading()) {
    _listenToUserData();
  }

  void _listenToUserData() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      emit(const ProfileError('No logged-in user found.'));
      return;
    }

    emit(ProfileLoading());

    _subscription = _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) {
        emit(const ProfileError('User data not found.'));
        return;
      }

      final data = snapshot.data()!;
      emit(ProfileLoaded(
        name: data['name'] ?? 'Unknown',
        wins: data['wins'] ?? 0,
        currentStreak: data['currentStreak'] ?? 0,
        // Remaining fields use defaults until schema is extended.
      ));
    }, onError: (_) {
      emit(const ProfileError('Failed to load profile data.'));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}