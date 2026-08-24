import 'package:cloud_firestore/cloud_firestore.dart';

/// Fetches the uid of the top-ranked participant (winner) of a given battle.
/// Uses the same ranking logic as LeaderboardCubit (highest xp wins).
Future<String?> getBattleWinnerId(String battleId) async {
  final firestore = FirebaseFirestore.instance;

  final battleDoc = await firestore.collection('battles').doc(battleId).get();
  if (!battleDoc.exists) return null;

  final battleData = battleDoc.data();
  if (battleData == null) return null;

  final List<String> memberIds = List<String>.from(battleData['members'] ?? []);
  final String creatorId = battleData['creatorId'] ?? '';

  final Set<String> queryUserIds = Set<String>.from(memberIds);
  if (creatorId.isNotEmpty) queryUserIds.add(creatorId);

  if (queryUserIds.isEmpty) return null;

  final usersSnapshot = await firestore
      .collection('users')
      .where(FieldPath.documentId, whereIn: queryUserIds.toList())
      .get();

  if (usersSnapshot.docs.isEmpty) return null;

  final sortedDocs = usersSnapshot.docs.toList()
    ..sort((a, b) {
      final xpA = a.data()['xp'] ?? 0;
      final xpB = b.data()['xp'] ?? 0;
      return (xpB as int).compareTo(xpA as int);
    });

  return sortedDocs.first.id; // winner's uid
}