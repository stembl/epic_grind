import 'package:flutter/material.dart';
import '../services/api.dart';

class CharacterCreationScreen extends StatefulWidget {
  final String email;
  final String password;

  const CharacterCreationScreen({required this.email, required this.password});

  @override
  _CharacterCreationScreenState createState() => _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends State<CharacterCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _race = 'Orc';
  String _role = 'Tank';

  final List<String> races = ['Orc', 'Elf', 'Human'];
  final List<String> roles = ['Tank', 'Rogue', 'Mage'];

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      bool success = await updateCharacter(
        widget.email,
        _name,
        _race,
        _role,
      );

      if (success) {
        Navigator.pushReplacementNamed(context, '/quest');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save character")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Your Character")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text("Logged in as: ${widget.email}", style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: "Character Name"),
                validator: (value) => value!.isEmpty ? "Enter a name" : null,
                onSaved: (value) => _name = value!,
              ),
              DropdownButtonFormField(
                value: _race,
                decoration: InputDecoration(labelText: "Race"),
                items: races.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (value) => setState(() => _race = value!),
              ),
              DropdownButtonFormField(
                value: _role,
                decoration: InputDecoration(labelText: "Role"),
                items: roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (value) => setState(() => _role = value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text("Create Character"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
