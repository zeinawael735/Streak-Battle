import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final FirebaseAuth _firebaseAuth;
  Timer? _timer;

  ForgetPasswordCubit({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        super(ForgetPasswordIdle());

  Future<void> sendResetLink(String email) async {
    emit(ForgetPasswordLoading());
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      _startResendTimer();
    } on FirebaseAuthException catch (e) {
      emit(ForgetPasswordError(_mapError(e.code)));
    } catch (_) {
      emit(ForgetPasswordError('Something went wrong. Please try again.'));
    }
  }

  void _startResendTimer() {
    int seconds = 30;
    emit(ForgetPasswordSuccess(remainingSeconds: seconds));
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      seconds--;
      if (seconds <= 0) {
        timer.cancel();
      }
      if (state is ForgetPasswordSuccess) {
        emit(ForgetPasswordSuccess(remainingSeconds: seconds));
      }
    });
  }

  String _mapError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      default:
        return 'Failed to send reset link. Please try again.';
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}