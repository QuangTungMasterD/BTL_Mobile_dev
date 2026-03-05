// core/providers/song_provider.dart
import 'package:btl_music_app/features/music/data/repo/song_repo.dart';
import 'package:flutter/material.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';

class SongProvider extends ChangeNotifier {
  final SongRepository _repo;

  // Cache bài hát theo ID
  final Map<String, SongModel> _cache = {};

  // Dữ liệu top songs (có thể lưu để dùng lại)
  List<SongModel> _topSongs = [];
  bool _isLoadingTop = false;

  // Trạng thái lỗi chung
  String? _error;
  String? get error => _error;

  // Getters
  List<SongModel> get topSongs => _topSongs;
  bool get isLoadingTop => _isLoadingTop;

  SongProvider(this._repo);

  Future<List<SongModel>> getSongsByArtistId(String id) async {
    if (_cache.containsKey(id)) return [_cache[id]!];
    try {
      final songs = await _repo.getSongsByArtistId(id);
      for (var song in songs) {
        _cache[song.id] = song;
      }
      return songs;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  // --- Cache methods ---
  Future<SongModel?> getSongById(String id) async {
    if (_cache.containsKey(id)) return _cache[id];
    try {
      final song = await _repo.getSongById(id);
      if (song != null) _cache[id] = song;
      return song;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // --- Top songs (nổi bật) ---
  Future<void> loadTopSongs({int limit = 99}) async {
    _isLoadingTop = true;
    notifyListeners();
    try {
      _topSongs = await _repo.getTopSongs(limit: limit);
      for (var song in _topSongs) {
        _cache[song.id] = song;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingTop = false;
      notifyListeners();
    }
  }

  // --- Tìm kiếm ---
  Future<List<SongModel>> searchSongs(String query, {int limit = 20}) async {
    if (query.isEmpty) return [];
    try {
      final results = await _repo.searchSongs(query, limit: limit);
      for (var song in results) {
        _cache[song.id] = song;
      }
      return results;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  // --- Đề xuất ngẫu nhiên ---
  Future<List<SongModel>> getRandomRecommendations({int limit = 10}) async {
    try {
      final songs = await _repo.getRandomSongs(limit: limit);
      for (var song in songs) {
        _cache[song.id] = song;
      }
      return songs;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  // --- Đề xuất theo thể loại (có thể truyền genre cụ thể) ---
  Future<List<SongModel>> getRecommendationsByGenre({
    int limit = 10,
    String? genre,
  }) async {
    try {
      // Nếu không có genre, có thể lấy từ sở thích người dùng hoặc mặc định 'Pop'
      // final genreToUse = genre ?? 'Pop';
      final songs = await _repo.getTopSongs(limit: limit);
      for (var song in songs) {
        _cache[song.id] = song;
      }
      return songs;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  // --- Đề xuất theo thể loại từ một bài hát (giữ tên cũ) ---
  // Có thể dùng getRecommendationsByGenre với genre từ bài hát đầu tiên (nếu có)
  // Nhưng không còn allSongs nên cần truyền genre từ bên ngoài.
  // Hàm này để tương thích với code cũ, nhưng thực tế nên gọi getRecommendationsByGenre.
  // Tôi sẽ để trống hoặc báo lỗi.
  // @Deprecated('Sử dụng getRecommendationsByGenre thay thế')
  // List<SongModel> getRecommendationsByGenreSync({int limit = 10}) => [];
}