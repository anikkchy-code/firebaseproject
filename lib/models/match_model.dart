import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String id;
  final String teamA;
  final String teamB;
  final int scoreA;
  final int scoreB;
  final String status;
  final String matchDate;
  final String venue;

  MatchModel({
    required this.id,
    required this.teamA,
    required this.teamB,
    required this.scoreA,
    required this.scoreB,
    required this.status,
    required this.matchDate,
    required this.venue,
  });

  factory MatchModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MatchModel(
      id: doc.id,
      teamA: data['teamA'] ?? '',
      teamB: data['teamB'] ?? '',
      scoreA: data['scoreA'] ?? 0,
      scoreB: data['scoreB'] ?? 0,
      status: data['status'] ?? 'Upcoming',
      matchDate: data['matchDate'] ?? '',
      venue: data['venue'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'teamA': teamA,
      'teamB': teamB,
      'scoreA': scoreA,
      'scoreB': scoreB,
      'status': status,
      'matchDate': matchDate,
      'venue': venue,
    };
  }
}
