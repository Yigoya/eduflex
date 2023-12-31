import 'package:eduflex/service/schema/entque.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBservice {
  static const _dbname = 'ethiocation.db';
  static const _dbversion = 1;

  DBservice._privateConstructor();
  static final DBservice instance = DBservice._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database?> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbname);
    return await openDatabase(path, version: _dbversion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    String url = '''
        CREATE TABLE entque(
          id INTEGER PRIMARY KEY,
          question TEXT,
          a TEXT,
          b TEXT,
          c TEXT,
          d TEXT,
          answer TEXT,
          explain TEXT,
          year INT,
          subject TEXT,
          unit INT
        )
      ''';
    await db.execute(url);
  }

  Future<List<Map<String, dynamic>>> fetchQue() async {
    Database db = await instance.database;
    return await db.query("entque");
  }

  Future<List<Map<String, dynamic>>> fetchBySub(String sub) async {
    Database db = await instance.database;
    return await db.query("entque", where: "subject = ?", whereArgs: [sub]);
  }

  Future<List<Map<String, Object?>>> isEmpty() async {
    Database db = await instance.database;
    return await db.rawQuery("SELECT COUNT(*) as count FROM entque;");
  }

  Future<int> insertQue(Map<String, dynamic?> data) async {
    Database db = await instance.database;
    return db.insert('entque', data);
  }
}
