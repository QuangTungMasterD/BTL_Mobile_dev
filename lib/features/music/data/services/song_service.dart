// features/music/data/services/song_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';

class SongService {
  final CollectionReference _songsCollection = FirebaseFirestore.instance
      .collection('songs');

  // Lấy bài hát theo ID
  Future<SongModel?> getSongById(String id) async {
    final doc = await _songsCollection.doc(id).get();
    if (doc.exists) {
      return SongModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<List<SongModel>> getSongsByArtistId(String id) async {
    print(id);
    final snapshot = await _songsCollection.where('artistId', isEqualTo: id).get();

    return snapshot.docs.map((doc) {
      return SongModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  // Tìm kiếm bài hát theo tên hoặc nghệ sĩ (tìm kiếm gần đúng bằng where)
  // Firestore không hỗ trợ full-text search, ta có thể dùng where với điều kiện "bắt đầu bằng"
  // và kết hợp nhiều trường. Giải pháp tốt hơn là dùng external search, nhưng tạm thời dùng cách này.
  Future<List<SongModel>> searchSongs(String query, {int limit = 20}) async {
    final byTitle = await searchSongsByTitle(query, limit: limit);
    final byArtist = await searchSongsByArtist(query, limit: limit);

    final all = {...byTitle, ...byArtist}.toList();
    return all;
  }

  Future<List<SongModel>> searchSongsByTitle(
    String query, {
    int limit = 20,
  }) async {
    if (query.isEmpty) return [];

    final snapshot = await _songsCollection
        .where('title', isEqualTo: query)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) {
      return SongModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<List<SongModel>> searchSongsByArtist(
    String query, {
    int limit = 20,
  }) async {
    if (query.isEmpty) return [];

    final snapshot = await _songsCollection
        .where('artist', isEqualTo: query)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) {
      return SongModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  // Lấy top N bài hát (dựa trên lượt nghe - listenCount)
  Future<List<SongModel>> getTopSongs({int limit = 5}) async {
    final snapshot = await _songsCollection
        .orderBy('playCount', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) {
      return SongModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  // Lấy bài hát ngẫu nhiên (lấy nhiều hơn và random trên client)
  Future<List<SongModel>> getRandomSongs({int limit = 10}) async {
    final snapshot = await _songsCollection.limit(50).get();
    final all = snapshot.docs.map((doc) {
      return SongModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
    all.shuffle();
    return all.take(limit).toList();
  }

  // Lấy bài hát theo thể loại (có phân trang)
  Future<List<SongModel>> getSongsByGenre(
    String genre, {
    int limit = 10,
    DocumentSnapshot? startAfter,
  }) async {
    Query query = _songsCollection
        .where('genre', isEqualTo: genre)
        .orderBy('title')
        .limit(limit);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      return SongModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}
