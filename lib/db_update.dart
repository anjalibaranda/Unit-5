import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MaterialApp(home: StudentUpdateApp()));
}

class StudentUpdateApp extends StatefulWidget {
  const StudentUpdateApp({super.key});

  @override
  State<StudentUpdateApp> createState() => _StudentUpdateAppState();
}

class _StudentUpdateAppState extends State<StudentUpdateApp> {
  Database? _database;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'students_db.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE students (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)');
      },
    );
  }

  Future<void> _updateStudent() async {
    if (_database != null && _idController.text.isNotEmpty && _nameController.text.isNotEmpty) {
      int id = int.parse(_idController.text);
      int count = await _database!.update(
        'students',
        {'name': _nameController.text},
        where: 'id = ?',
        whereArgs: [id],
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(count > 0 ? "Record Updated" : "No Record Found")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite Update Record")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _idController, decoration: const InputDecoration(labelText: "Enter Student ID"), keyboardType: TextInputType.number),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Enter New Name")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _updateStudent, child: const Text("Update Student"))
          ],
        ),
      ),
    );
  }
}
