import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('todoBox');
  runApp(const MaterialApp(home: HiveTodoApp()));
}

class HiveTodoApp extends StatefulWidget {
  const HiveTodoApp({super.key});

  @override
  State<HiveTodoApp> createState() => _HiveTodoAppState();
}

class _HiveTodoAppState extends State<HiveTodoApp> {
  final TextEditingController _controller = TextEditingController();
  late Box _todoBox;
  List<String> _todos = [];

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    _todoBox = Hive.isBoxOpen('todoBox') ? Hive.box('todoBox') : await Hive.openBox('todoBox');
    _loadTodos();
  }

  void _loadTodos() {
    setState(() {
      _todos = List<String>.from(_todoBox.get('notes', defaultValue: <String>[]));
    });
  }

  void _addTodo() {
    if (_controller.text.isNotEmpty) {
      _todos.add(_controller.text);
      _todoBox.put('notes', _todos);
      _controller.clear();
      _loadTodos();
    }
  }

  void _deleteTodo(int index) {
    _todos.removeAt(index);
    _todoBox.put('notes', _todos);
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hive To-Do Note")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Enter To-Do Note"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _addTodo, child: const Text("Save Note")),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_todos[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteTodo(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
