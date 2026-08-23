import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streak_battle/features/auth/signup/view_model/sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignUpInitial());
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final String uid = userCredential.user!.uid;

      await firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': name.trim(),
        'email': email.trim(),
        'photoURL': '',
        'totalPoints': 0,
        'battlesXp': {},
        'battlesCheckInsCount': {},
        'level': 1,
        'currentStreak': 0,
        'lastCheckInDate': null,
        'weeklyCheckIns': [],
        'wins': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      emit(SignUpSuccess());
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'An account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      }
      emit(SignUpError(errorMessage));
    } catch (e) {
      emit(SignUpError(e.toString()));
    }
  }
}