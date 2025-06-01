import 'package:flutter/material.dart';
import '../services/api.dart';
import '../services/email_storage.dart';
import 'character_screen.dart';
import 'login_screen.dart';

class QuestScreen extends StatelessWidget {
  final String email;

  const QuestScreen({required this.email});

  void _completeQuest(
    BuildContext context,
    String questId,
    int xpAmount,
  ) async {
    final xpSuccess = await addXP(email, xpAmount);
    await logAnalytics(email, 'quest_tapped', {'quest_id': questId});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(xpSuccess ? "+$xpAmount XP!" : "Failed to update XP."),
      ),
    );
  }

  void _logout(BuildContext context) async {
    await clearEmail();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  void _goToCharacterScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/character', arguments: email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Epic Grind Quests"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => _goToCharacterScreen(context),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("🏋️ Pushups x10"),
            onTap: () => _completeQuest(context, "pushups_10", 10),
          ),
          ListTile(
            title: const Text("🏃 Run 1 mile"),
            onTap: () => _completeQuest(context, "run_mile", 20),
          ),
        ],
      ),
    );
  }
}
