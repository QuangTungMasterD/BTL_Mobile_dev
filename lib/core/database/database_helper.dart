import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('btl_music.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Tạo bảng downloaded_songs
      await db.execute('''
      CREATE TABLE downloaded_songs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        songId TEXT NOT NULL UNIQUE,
        title TEXT NOT NULL,
        artist TEXT NOT NULL,
        thumbnailUrl TEXT,
        downloadedAt INTEGER NOT NULL
      )
    ''');
    }
  }

  Future _createDB(Database db, int version) async {
    // Bảng lịch sử tìm kiếm
    await db.execute('''
    CREATE TABLE search_history (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      query TEXT NOT NULL UNIQUE,
      searchedAt INTEGER NOT NULL
    )
  ''');

    // Bảng bài hát đã tải về
    await db.execute('''
    CREATE TABLE downloaded_songs (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      songId TEXT NOT NULL UNIQUE,
      title TEXT NOT NULL,
      artist TEXT NOT NULL,
      thumbnailUrl TEXT,
      downloadedAt INTEGER NOT NULL
    )
  ''');
  }

  // Thêm query mới (nếu đã có thì cập nhật thời gian)
  Future<void> addSearchQuery(String query) async {
    final db = await database;
    await db.insert('search_history', {
      'query': query.trim(),
      'searchedAt': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Lấy 10 tìm kiếm gần nhất
  Future<List<String>> getRecentSearches({int limit = 10}) async {
    final db = await database;
    final maps = await db.query(
      'search_history',
      orderBy: 'searchedAt DESC',
      limit: limit,
    );
    return maps.map((map) => map['query'] as String).toList();
  }

  // Xóa toàn bộ lịch sử (tùy chọn)
  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('search_history');
  }

  /// DOWNLOAD

  // Thêm bài hát đã tải
  Future<void> insertDownloadedSong({
    required String songId,
    required String title,
    required String artist,
    String? thumbnailUrl,
  }) async {
    final db = await database;
    await db.insert(
      'downloaded_songs',
      {
        'songId': songId,
        'title': title,
        'artist': artist,
        'thumbnailUrl': thumbnailUrl,
        'downloadedAt': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm:
          ConflictAlgorithm.replace, // nếu đã tải rồi thì cập nhật
    );
  }

  // Kiểm tra bài hát đã tải chưa
  Future<bool> isSongDownloaded(String songId) async {
    final db = await database;
    final maps = await db.query(
      'downloaded_songs',
      where: 'songId = ?',
      whereArgs: [songId],
    );
    return maps.isNotEmpty;
  }

  // Lấy danh sách bài hát đã tải
  Future<List<Map<String, dynamic>>> getDownloadedSongs() async {
    final db = await database;
    return db.query('downloaded_songs', orderBy: 'downloadedAt DESC');
  }

  // Xóa bài hát đã tải (và cả file nhạc)
  Future<void> deleteDownloadedSong(String songId) async {
    final db = await database;
    await db.delete(
      'downloaded_songs',
      where: 'songId = ?',
      whereArgs: [songId],
    );
  }
}
