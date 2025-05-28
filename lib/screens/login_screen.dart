import 'package:flutter/material.dart';
import '../services/api.dart';
import '../services/email_storage.dart';
import 'character_creation_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLogin = true;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_isLogin) {
        final user = await loginUser(_email, _password);
        if (user != null) {
          await saveEmail(_email);
          if ((user['name'] ?? '').isEmpty || (user['race'] ?? '').isEmpty) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => CharacterCreationScreen(
                  email: _email,
                  password: _password,
                ),
              ),
            );
          } else {
            Navigator.pushReplacementNamed(context, '/quest');
          }
        } else {
          _showError("Login failed");
        }
      } else {
        final success = await registerUser(_email, _password);
        if (success) {
          await saveEmail(_email);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => CharacterCreationScreen(
                email: _email,
                password: _password,
              ),
            ),
          );
        } else {
          _showError("Registration failed");
        }
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? "Login" : "Create Account")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.isEmpty || !value.contains("@") ? "Enter a valid email" : null,
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) =>
                    value!.length < 6 ? "Password must be at least 6 characters" : null,
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_isLogin ? "Login" : "Register"),
              ),
              TextButton(
                onPressed: () {
                  setState(() => _isLogin = !_isLogin);
                },
                child: Text(_isLogin
                    ? "Don't have an account? Register"
                    : "Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
