import 'package:sqflite/sqflite.dart';

import '../model/article.dart';

/// untuk menjalankan fungsionalitas database
class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblBookmark = 'bookmarks';

  /// Untuk menyiapkan database
  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/newsapp.db',
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblBookmark (
             url TEXT PRIMARY KEY,
             author TEXT,
             title TEXT,
             description TEXT,
             urlToImage TEXT,
             publishedAt TEXT,
             content TEXT
           )     
        ''');
      },
      version: 1,
    );

    return db;
  }

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initializeDb();
    }

    return _database;
  }
  /// Metode untuk menyimpan data:
  Future<void> insertBookmark(Article article) async {
    final db = await database;
    await db!.insert(_tblBookmark, article.toJson());
  }

  /// Mendapatkan seluruh data bookmark yang tersimpan:
  Future<List<Article>> getBookmarks() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblBookmark);

    return results.map((res) => Article.fromJson(res)).toList();
  }

  /// Mencari bookmark yang disimpan berdasarkan url.
  /// Query ini akan kita gunakan untuk mengecek status artikel
  /// apakah ditandai sebagai bookmark atau tidak.
  Future<Map> getBookmarkByUrl(String url) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tblBookmark,
      where: 'url = ?',
      whereArgs: [url],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  /// Menghapus data bookmark berdasarkan url.
  Future<void> removeBookmark(String url) async {
    final db = await database;

    await db!.delete(
      _tblBookmark,
      where: 'url = ?',
      whereArgs: [url],
    );
  }

  
}