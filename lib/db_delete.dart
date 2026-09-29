import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MaterialApp(home: StudentDeleteApp()));
}

class StudentDeleteApp extends StatefulWidget {
  const StudentDeleteApp({super.key});

  @override
  State<StudentDeleteApp> createState() => _StudentDeleteAppState();
}

class _StudentDeleteAppState extends State<StudentDeleteApp> {
  Database? _database;
  final TextEditingController _idController = TextEditingController();

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

  Future<void> _deleteStudent() async {
    if (_database != null && _idController.text.isNotEmpty) {
      int id = int.parse(_idController.text);
      int count = await _database!.delete(
        'students',
        where: 'id = ?',
        whereArgs: [id],
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(count > 0 ? "Record Deleted" : "No Record Found")));
      _idController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite Delete Record")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _idController, decoration: const InputDecoration(labelText: "Enter Student ID to Delete"), keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _deleteStudent, child: const Text("Delete Student"))
          ],
        ),
      ),
    );
  }
}
