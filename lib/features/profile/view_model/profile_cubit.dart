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

      // battlesXp is a map of {battleId: score} -> count = number of battles played
      final battlesXp = data['battlesXp'] as Map<String, dynamic>? ?? {};
      final battlesCount = battlesXp.length;

      // weeklyCheckIns is a list of date strings, e.g. "2026-08-22"
      final checkInsRaw = data['weeklyCheckIns'] as List<dynamic>? ?? [];
      final checkInDates = checkInsRaw.map((e) => e.toString()).toSet();

      final activity = _buildLast7DaysActivity(checkInDates);

      emit(ProfileLoaded(
        name: data['name'] ?? 'Unknown',
        wins: data['wins'] ?? 0,
        currentStreak: data['currentStreak'] ?? 0,
        level: data['level'] ?? 1,
        totalPoints: data['totalPoints'] ?? 0,
        battlesCount: battlesCount,
        activityLastWeek: activity,
      ));
    }, onError: (_) {
      emit(const ProfileError('Failed to load profile data.'));
    });
  }

  // Builds a 7-value list (oldest -> newest) where 1 = check-in happened that day.
  List<double> _buildLast7DaysActivity(Set<String> checkInDates) {
    final today = DateTime.now();
    return List.generate(7, (index) {
      final day = today.subtract(Duration(days: 6 - index));
      final dateKey =
          '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
      return checkInDates.contains(dateKey) ? 1.0 : 0.0;
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}