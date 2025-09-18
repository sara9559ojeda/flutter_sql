import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, 'medical_history.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medical_records(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        diagnosis TEXT,
        date TEXT,
        results TEXT
      )
    ''');
  }

  Future<int> insertRecord(Map<String, dynamic> record) async {
    final db = await database;
    return await db.insert('medical_records', record);
  }

  Future<List<Map<String, dynamic>>> getRecords() async {
    final db = await database;
    return await db.query('medical_records');
  }

  Future<int> updateRecord(Map<String, dynamic> record) async {
    final db = await database;
    return await db.update(
      'medical_records',
      record,
      where: 'id = ?',
      whereArgs: [record['id']],
    );
  }

  Future<int> deleteRecord(int id) async {
    final db = await database;
    return await db.delete(
      'medical_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
