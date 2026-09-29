import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MaterialApp(home: FileStorageApp()));
}

class FileStorageApp extends StatefulWidget {
  const FileStorageApp({super.key});

  @override
  State<FileStorageApp> createState() => _FileStorageAppState();
}

class _FileStorageAppState extends State<FileStorageApp> {
  final TextEditingController _controller = TextEditingController();
  String _fileContent = "No data read yet";

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/my_text_file.txt');
  }

  Future<void> _writeToFile() async {
    final file = await _getLocalFile();
    await file.writeAsString(_controller.text);
    _controller.clear();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data written to file")));
  }

  Future<void> _readFromFile() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        String content = await file.readAsString();
        setState(() {
          _fileContent = content;
        });
      } else {
        setState(() {
          _fileContent = "File does not exist yet";
        });
      }
    } catch (e) {
      setState(() {
        _fileContent = "Error reading file: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("File Storage (path_provider)")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: "Enter text to save"),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _writeToFile, child: const Text("Write to File")),
                ElevatedButton(onPressed: _readFromFile, child: const Text("Read from File")),
              ],
            ),
            const SizedBox(height: 20),
            const Text("File Content:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            Text(_fileContent, style: const TextStyle(fontSize: 16, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
