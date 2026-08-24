import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AchievementsService {
  final _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final docSnap = await _firestore.collection('users').doc(user.uid).get();
    if (docSnap.exists && docSnap.data() != null) {
      return docSnap.data();
    }
    return null;
  }

  Future<void> updateAchievementsInDb(Map<String, dynamic> achievements) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).set({
      'achievements': achievements,
    }, SetOptions(merge: true));
  }
}
