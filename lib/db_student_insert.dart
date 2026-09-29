import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MaterialApp(home: StudentInsertApp()));
}

class StudentInsertApp extends StatefulWidget {
  const StudentInsertApp({super.key});

  @override
  State<StudentInsertApp> createState() => _StudentInsertAppState();
}

class _StudentInsertAppState extends State<StudentInsertApp> {
  final TextEditingController _nameController = TextEditingController();
  Database? _database;

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

  Future<void> _insertStudent() async {
    if (_database != null && _nameController.text.isNotEmpty) {
      await _database!.insert('students', {'name': _nameController.text});
      _nameController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Student Inserted")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite Insert Student")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Student Name")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _insertStudent, child: const Text("Insert Record"))
          ],
        ),
      ),
    );
  }
}
