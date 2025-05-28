import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api.dart';
import '../services/email_storage.dart';
import 'character_screen.dart';
import 'login_screen.dart';

class QuestScreen extends StatefulWidget {
  @override
  _QuestScreenState createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {
  String? email;

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  void _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
    });
  }

  void _completeQuest(String questId, int xpAmount) async {
    if (email == null) return;

    final xpSuccess = await addXP(email!, xpAmount);
    await logAnalytics(email!, 'quest_tapped', {'quest_id': questId});

    if (xpSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("+$xpAmount XP!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update XP.")));
    }
  }

  void _logout() async {
    await clearEmail();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (email == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Epic Grind Quests")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Epic Grind Quests"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: _logout),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => CharacterScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("🏋️ Pushups x10"),
            onTap: () => _completeQuest("pushups_10", 10),
          ),
          ListTile(
            title: Text("🏃 Run 1 mile"),
            onTap: () => _completeQuest("run_mile", 20),
          ),
        ],
      ),
    );
  }
}
