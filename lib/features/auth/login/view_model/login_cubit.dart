import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        await storage.write(key: 'user_id', value: user.uid);
        await storage.write(key: 'user_email', value: user.email);

        String? token = await user.getIdToken();
        if (token != null) {
          await storage.write(key: 'auth_token', value: token);
        }
      }

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        message = 'Invalid email or password.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password.';
      } else if (e.code == 'network-request-failed') {
        message = 'Please check your internet connection.';
      } else if (e.code == 'user-disabled') {
        message = 'This account has been disabled.';
      }
      emit(LoginError(message));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(LoginLoading());
    try {
      final googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(
        serverClientId: '812612591512-bepdkfhqbqg23mljgj03e27gci6ll003.apps.googleusercontent.com',
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.authenticate();
      if (googleUser == null) {
        emit(LoginInitial());
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final userDoc = await firestore.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          await firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'name': user.displayName ?? '',
            'email': user.email ?? '',
            'photoURL': user.photoURL ?? '',
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
        }

        await storage.write(key: 'user_id', value: user.uid);
        await storage.write(key: 'user_email', value: user.email);

        String? token = await user.getIdToken();
        if (token != null) {
          await storage.write(key: 'auth_token', value: token);
        }
      }

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginError(e.message ?? 'Google Sign-In failed'));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}