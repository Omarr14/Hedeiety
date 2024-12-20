import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE friends (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        phone TEXT,
        image_url TEXT,
        isFriend INTEGER
      )
    ''');

    // Insert initial friends
    await _insertInitialFriends(db);
  }

  Future<void> _insertInitialFriends(Database db) async {
    final friends = [
      {
        'username': 'Joey',
        'phone': '01234567890',
        'image_url': 'assets/images/Joe.png',
        'isFriend': 1
      },
      {
        'username': 'Khaled',
        'phone': '01123456789',
        'image_url': 'assets/images/khaled.jpg',
        'isFriend': 1
      },
      {
        'username': 'Luda',
        'phone': '01012345678',
        'image_url': 'assets/images/luda.jpg',
        'isFriend': 1
      },
    ];

    for (var friend in friends) {
      await db.insert('friends', friend);
    }
  }

  Future<List<Map<String, dynamic>>> getFriends() async {
    final db = await database;
    return await db.query('friends');
  }

  Future<void> insertFriend(Map<String, dynamic> friendData) async {
    final db = await database;
    await db.insert('friends', friendData);
  }
}
