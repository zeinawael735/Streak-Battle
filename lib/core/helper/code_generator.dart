import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BattleCodeHelper {
  static Future<String> generateUniqueCode({String prefix = 'BAT'}) async {
    final firestore = FirebaseFirestore.instance;
    final random = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    while (true) {

      final randomPart = List.generate(4, (_) => chars[random.nextInt(chars.length)]).join();
      final code = '$prefix-$randomPart';


      final doc = await firestore.collection('battles').doc(code).get();


      if (!doc.exists) {
        return code;
      }



    }
  }
}