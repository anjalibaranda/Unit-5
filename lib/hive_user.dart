import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  runApp(const MaterialApp(home: HiveUserApp()));
}

class HiveUserApp extends StatefulWidget {
  const HiveUserApp({super.key});

  @override
  State<HiveUserApp> createState() => _HiveUserAppState();
}

class _HiveUserAppState extends State<HiveUserApp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  late Box _userBox;
  String _savedName = "";
  int _savedAge = 0;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    _userBox = Hive.isBoxOpen('userBox') ? Hive.box('userBox') : await Hive.openBox('userBox');
    _loadUserData();
  }

  void _loadUserData() {
    setState(() {
      _savedName = _userBox.get('name', defaultValue: "No Name");
      _savedAge = _userBox.get('age', defaultValue: 0);
    });
  }

  void _saveUserData() {
    if (_nameController.text.isNotEmpty && _ageController.text.isNotEmpty) {
      _userBox.put('name', _nameController.text);
      _userBox.put('age', int.tryParse(_ageController.text) ?? 0);
      _loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hive Store Name & Age")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Saved Data: Name: $_savedName, Age: $_savedAge", style: const TextStyle(fontSize: 18)),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Enter Name")),
            TextField(controller: _ageController, decoration: const InputDecoration(labelText: "Enter Age"), keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveUserData, child: const Text("Save User Data"))
          ],
        ),
      ),
    );
  }
}
