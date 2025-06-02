import 'package:flutter/material.dart';
import '../services/email_storage.dart';
import '../services/api.dart';
import 'login_screen.dart';
import 'quest_screen.dart';

class CharacterScreen extends StatefulWidget {
  final String email;

  const CharacterScreen({required this.email});

  @override
  _CharacterScreenState createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  Map<String, dynamic>? character;

  final List<String> quotes = [
    "I'm not lazy, I'm in stealth mode.",
    "Muscles loading... please wait.",
    "Today's quest: avoid cardio.",
    "Leveling up is just aggressive resting.",
  ];

  String get funnyQuote => (quotes..shuffle()).first;

  @override
  void initState() {
    super.initState();
    fetchCharacter();
  }

  Future<void> fetchCharacter() async {
    final data = await getCharacter(widget.email);
    setState(() {
      character = data;
    });
  }

  void _logout() async {
    await clearEmail();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }

  void _goToQuestScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => QuestScreen(email: widget.email)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = character?['name'] ?? 'Loading...';
    final race = character?['race'] ?? 'Unknown';
    final role = character?['role'] ?? 'Unknown';
    final xp = character?['xp']?.toString() ?? '0';

    return Scaffold(
      appBar: AppBar(
        title: Text("Character Profile"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
          IconButton(icon: const Icon(Icons.list), onPressed: _goToQuestScreen),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 🧍 Character Illustration
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage('assets/character_placeholder.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 🧙 Character Details
              Text(name, style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 8),
              Text("Race: $race"),
              Text("Role: $role"),
              Text("XP: $xp"),

              const Spacer(),

              // 😂 Funny quote
              Text(
                funnyQuote,
                textAlign: TextAlign.center,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
