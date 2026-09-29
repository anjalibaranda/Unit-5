import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MaterialApp(home: DBProductsApp()));
}

class DBProductsApp extends StatefulWidget {
  const DBProductsApp({super.key});

  @override
  State<DBProductsApp> createState() => _DBProductsAppState();
}

class _DBProductsAppState extends State<DBProductsApp> {
  Database? _database;
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'products_db.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            price REAL
          )
        ''');
      },
    );
    _refreshProducts();
  }

  Future<void> _refreshProducts() async {
    if (_database == null) return;
    final data = await _database!.query('products');
    setState(() {
      _products = data;
    });
  }

  Future<void> _addProduct() async {
    if (_database == null) return;
    await _database!.insert('products', {
      'name': 'Product ${DateTime.now().second}',
      'price': 99.99,
    });
    _refreshProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite Products Table")),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final prod = _products[index];
          return ListTile(
            title: Text(prod['name'] ?? ''),
            subtitle: Text("Price: \$${prod['price']}"),
            trailing: Text("ID: ${prod['id']}"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        child: const Icon(Icons.add),
      ),
    );
  }
}
