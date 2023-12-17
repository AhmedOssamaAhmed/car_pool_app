import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final _tableName = 'user_table';

  // Singleton pattern to ensure only one instance of the database is created
  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'your_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            first_name TEXT,
            last_name TEXT,
            phone_number TEXT,
            age TEXT,
            grade TEXT,
            image_url TEXT
          )
        ''');
      },
    );
  }

  static Future<void> saveUserData({
    required String? firstName,
    required String? lastName,
    required String? phoneNumber,
    required String? age,
    required String? grade,
    required String? imageUrl
  }) async {
    final Database db = await database;

    await db.insert(
      _tableName,
      {
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
        'age': age,
        'grade': grade,
        'image_url': imageUrl,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final Database db = await database;

    return await db.query(_tableName);
  }
}