import 'package:flutter/material.dart';
import 'services/email_storage.dart';
import 'screens/login_screen.dart';
import 'screens/quest_screen.dart';
import 'screens/character_creation_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(EpicGrindApp());
}

class EpicGrindApp extends StatelessWidget {
  Future<Widget> _determineStartScreen() async {
    final email = await loadEmail();
    if (email != null && email.isNotEmpty) {
      return QuestScreen();
    }
    return LoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Epic Grind',
      theme: ThemeData(primarySwatch: Colors.green),
      home: FutureBuilder<Widget>(
        future: _determineStartScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data!;
          } else {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        },
      ),
      routes: {
        '/quest': (context) => QuestScreen(), // email to be passed explicitly
      },
    );
  }
}
