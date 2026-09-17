import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class MatchController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> get matchesStream {
    return _firestore.collection('matches').snapshots();
  }

  Future<void> updateMatchScore({
    required String matchId,
    required int scoreA,
    required int scoreB,
    required String status,
  }) async {
    await _firestore.collection('matches').doc(matchId).update({
      'scoreA': scoreA,
      'scoreB': scoreB,
      'status': status,
    });
  }
}
