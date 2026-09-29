import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MaterialApp(home: StudentDisplayApp()));
}

class StudentDisplayApp extends StatefulWidget {
  const StudentDisplayApp({super.key});

  @override
  State<StudentDisplayApp> createState() => _StudentDisplayAppState();
}

class _StudentDisplayAppState extends State<StudentDisplayApp> {
  Database? _database;
  List<Map<String, dynamic>> _students = [];

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
        await db.insert('students', {'name': 'Default Student'});
      },
    );
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    if (_database != null) {
      final List<Map<String, dynamic>> maps = await _database!.query('students');
      setState(() {
        _students = maps;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite ListView Display")),
      body: _students.isEmpty
          ? const Center(child: Text("No records found"))
          : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(child: Text(_students[index]['id'].toString())),
                  title: Text(_students[index]['name']),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchStudents,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
