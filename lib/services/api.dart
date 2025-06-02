import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = "https://api.embl.io";

Future<bool> registerUser(String email, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
      'name': '',
      'race': '',
      'role': '',
    }),
  );
  return response.statusCode == 200;
}

Future<bool> registerUserWithCharacter(
  String email,
  String password,
  String name,
  String race,
  String role,
) async {
  final response = await http.post(
    Uri.parse('$baseUrl/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
      'name': name,
      'race': race,
      'role': role,
    }),
  );
  return response.statusCode == 200;
}

Future<Map<String, dynamic>?> loginUser(String email, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body)['user'];
  } else {
    return null;
  }
}

Future<bool> addXP(String email, int amount) async {
  final url = Uri.parse('$baseUrl/xp');

  //print('📤 Sending XP request to $url');
  //print("📛 Sending XP for email: $email");
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'amount': amount}),
  );
  //print('📥 XP Response: ${response.statusCode} ${response.body}');
  return response.statusCode == 200;
}

Future<void> logAnalytics(
  String userId,
  String type,
  Map<String, dynamic> details,
) async {
  await http.post(
    Uri.parse('$baseUrl/analytics'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'user_id': userId,
      'event_type': type,
      'details': details,
    }),
  );
}

Future<bool> healthCheck() async {
  final response = await http.get(Uri.parse('$baseUrl/status'));
  return response.statusCode == 200;
}

Future<bool> updateCharacter(
  String email,
  String name,
  String race,
  String role,
) async {
  final response = await http.patch(
    Uri.parse('$baseUrl/character'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'name': name,
      'race': race,
      'role': role,
    }),
  );
  return response.statusCode == 200;
}

Future<Map<String, dynamic>?> getCharacter(String email) async {
  final response = await http.get(
    Uri.parse('$baseUrl/character?email=$email'),
    headers: {'Content-Type': 'application/json'},
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return null;
  }
}
