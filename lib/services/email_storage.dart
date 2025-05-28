import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveEmail(String email) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
}

Future<String?> loadEmail() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}

Future<void> clearEmail() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('email');
}
