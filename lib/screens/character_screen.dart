import 'package:flutter/material.dart';
import '../services/email_storage.dart';

class CharacterScreen extends StatelessWidget {
  final String email;

  const CharacterScreen({Key? key, required this.email}) : super(key: key);

  void _logout(BuildContext context) async {
    await clearEmail();
    Navigator.pushReplacementNamed(context, '/');
  }

  void _goToQuests(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/quest', arguments: email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character'),
        actions: [
          IconButton(
            icon: const Icon(Icons.assignment),
            onPressed: () => _goToQuests(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: const Center(child: Text('Welcome to the Character Screen')),
    );
  }
}
