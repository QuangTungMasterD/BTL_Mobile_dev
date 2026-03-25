
import 'package:btl_music_app/features/music/data/repo/song_repo.dart';
import 'package:flutter/material.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';

class SongProvider extends ChangeNotifier {
  final SongRepository _repo;

  final Map<String, SongModel> _cache = {};

  List<SongModel> _topSongs = [];
  bool _isLoadingTop = false;

  String? _error;
  String? get error => _error;

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

  Future<List<SongModel>> getRecommendationsByGenre({
    int? limit,
    String? genre,
  }) async {
    try {
      final songs = limit != null ? await _repo.getTopSongs(limit: limit) : await _repo.getTopSongs();
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

}