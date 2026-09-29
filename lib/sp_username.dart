import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(home: UsernameSP()));
}

class UsernameSP extends StatefulWidget {
  const UsernameSP({super.key});

  @override
  State<UsernameSP> createState() => _UsernameSPState();
}

class _UsernameSPState extends State<UsernameSP> {
  final TextEditingController _controller = TextEditingController();
  String _savedName = "";

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedName = prefs.getString('username') ?? "No Name Saved";
    });
  }

  _saveUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _controller.text);
    _loadUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SP Username")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Saved Name: $_savedName", style: const TextStyle(fontSize: 20)),
            TextField(controller: _controller, decoration: const InputDecoration(labelText: "Enter Username")),
            ElevatedButton(onPressed: _saveUsername, child: const Text("Save"))
          ],
        ),
      ),
    );
  }
}
