import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/match_controller.dart';
import '../models/match_model.dart';
import '../widgets/match_card.dart';
import 'admin_update_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final MatchController _matchController = Get.put(MatchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Score App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              Get.to(() => const AdminUpdateScreen());
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _matchController.matchesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No matches found.'));
          }

          final matches = snapshot.data!.docs
              .map((doc) => MatchModel.fromFirestore(doc))
              .toList();

          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              return MatchCard(match: matches[index]);
            },
          );
        },
      ),
    );
  }
}
