import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/contact.dart';

class ContactService {
  static Database? _database;
  static const String tableName = 'contacts';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'contacts.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            firstName TEXT NOT NULL,
            lastName TEXT NOT NULL,
            phoneNumber TEXT NOT NULL,
            email TEXT,
            address TEXT,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> addContact(Contact contact) async {
    final db = await database;
    return await db.insert(tableName, contact.toMap());
  }

  Future<List<Contact>> getContacts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'firstName, lastName',
    );
    return List.generate(maps.length, (i) {
      return Contact.fromMap(maps[i]);
    });
  }

  Future<int> updateContact(Contact contact) async {
    final db = await database;
    return await db.update(
      tableName,
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Contact>> searchContacts(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'firstName LIKE ? OR lastName LIKE ? OR phoneNumber LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) {
      return Contact.fromMap(maps[i]);
    });
  }
}