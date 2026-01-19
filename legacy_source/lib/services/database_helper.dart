import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contact.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'contacts.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createTables,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Simple migration for dev: drop and recreate
          await db.execute('DROP TABLE IF EXISTS contacts');
          await _createTables(db, newVersion);
        }
      },
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT,
        address TEXT
      )
    ''');
  }

  Future<int> insertContact(Contact contact) async {
    final db = await database;
    return await db.insert('contacts', contact.toMap());
  }

  Future<List<Contact>> getContacts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('contacts');
    return List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
  }

  Future<int> updateContact(Contact contact) async {
    final db = await database;
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Contact>> searchContacts(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'contacts',
      where: 'name LIKE ? OR phone LIKE ? OR email LIKE ? OR address LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
  }
}