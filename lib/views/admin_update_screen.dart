import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/match_controller.dart';
import '../models/match_model.dart';

class AdminUpdateScreen extends StatefulWidget {
  const AdminUpdateScreen({super.key});

  @override
  State<AdminUpdateScreen> createState() => _AdminUpdateScreenState();
}

class _AdminUpdateScreenState extends State<AdminUpdateScreen> {
  final MatchController _matchController = Get.find<MatchController>();

  MatchModel? _selectedMatch;
  int _scoreA = 0;
  int _scoreB = 0;
  String _status = 'Upcoming';
  final List<String> _statusOptions = ['Upcoming', 'Live', 'Finished'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Score Update'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _matchController.matchesStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No matches available to update.'));
            }

            final matches = snapshot.data!.docs
                .map((doc) => MatchModel.fromFirestore(doc))
                .toList();

            if (_selectedMatch == null && matches.isNotEmpty) {
              _selectedMatch = matches.first;
              _scoreA = _selectedMatch!.scoreA;
              _scoreB = _selectedMatch!.scoreB;
              _status = _selectedMatch!.status;
            }

            return ListView(
              children: [
                const Text(
                  'Select Match',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<MatchModel>(
                  value: _selectedMatch,
                  isExpanded: true,
                  items: matches.map((match) {
                    return DropdownMenuItem<MatchModel>(
                      value: match,
                      child: Text('${match.teamA} vs ${match.teamB}'),
                    );
                  }).toList(),
                  onChanged: (MatchModel? newMatch) {
                    if (newMatch != null) {
                      setState(() {
                        _selectedMatch = newMatch;
                        _scoreA = newMatch.scoreA;
                        _scoreB = newMatch.scoreB;
                        _status = newMatch.status;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Team A Score: ${_selectedMatch?.teamA ?? ''}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '$_scoreA',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (_scoreA > 0) _scoreA--;
                        });
                      },
                      icon: const Icon(Icons.remove_circle, color: Colors.red, size: 32),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _scoreA++;
                        });
                      },
                      icon: const Icon(Icons.add_circle, color: Colors.green, size: 32),
                    ),
                  ],
                ),
                const Divider(height: 32),
                Text(
                  'Team B Score: ${_selectedMatch?.teamB ?? ''}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '$_scoreB',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (_scoreB > 0) _scoreB--;
                        });
                      },
                      icon: const Icon(Icons.remove_circle, color: Colors.red, size: 32),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _scoreB++;
                        });
                      },
                      icon: const Icon(Icons.add_circle, color: Colors.green, size: 32),
                    ),
                  ],
                ),
                const Divider(height: 32),
                const Text(
                  'Match Status',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _statusOptions.contains(_status) ? _status : 'Upcoming',
                  isExpanded: true,
                  items: _statusOptions.map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (String? newStatus) {
                    if (newStatus != null) {
                      setState(() {
                        _status = newStatus;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    if (_selectedMatch != null) {
                      await _matchController.updateMatchScore(
                        matchId: _selectedMatch!.id,
                        scoreA: _scoreA,
                        scoreB: _scoreB,
                        status: _status,
                      );
                      Get.back();
                      Get.snackbar(
                        'Success',
                        'Match updated successfully!',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  child: const Text(
                    'Update Score',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
