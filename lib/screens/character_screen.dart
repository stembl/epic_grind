import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/email_storage.dart';
import '../services/api.dart';
import 'login_screen.dart';
import 'quest_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CharacterScreen extends StatefulWidget {
  @override
  _CharacterScreenState createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  String? email;
  Map<String, dynamic>? character;

  @override
  void initState() {
    super.initState();
    _loadCharacter();
  }

  void _loadCharacter() async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('email');
    if (storedEmail != null) {
      final response = await http.get(Uri.parse('http://localhost:8000/character?email=$storedEmail'));
      if (response.statusCode == 200) {
        setState(() {
          email = storedEmail;
          character = jsonDecode(response.body);
        });
      }
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
    if (character == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Character"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${character!['name']}", style: TextStyle(fontSize: 20)),
            Text("Race: ${character!['race']}", style: TextStyle(fontSize: 20)),
            Text("Role: ${character!['role']}", style: TextStyle(fontSize: 20)),
            Text("XP: ${character!['xp']}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => QuestScreen()),
                );
              },
              child: Text("Go to Quests"),
            )
          ],
        ),
      ),
    );
  }
}
