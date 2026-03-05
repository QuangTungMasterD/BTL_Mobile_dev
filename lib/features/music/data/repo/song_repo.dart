// features/music/data/repo/song_repo.dart
import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:btl_music_app/features/music/data/services/song_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SongRepository {
  final SongService _service;

  SongRepository(this._service);

  Future<SongModel?> getSongById(String id) => _service.getSongById(id);

  Future<List<SongModel>> getSongsByArtistId(String id) => _service.getSongsByArtistId(id);

  Future<List<SongModel>> searchSongs(String query, {int limit = 20}) =>
      _service.searchSongs(query, limit: limit);

  Future<List<SongModel>> getTopSongs({int limit = 5}) =>
      _service.getTopSongs(limit: limit);

  Future<List<SongModel>> getRandomSongs({int limit = 10}) =>
      _service.getRandomSongs(limit: limit);

  Future<List<SongModel>> getSongsByGenre(
    String genre, {
    int limit = 10,
    DocumentSnapshot? startAfter,
  }) => _service.getSongsByGenre(genre, limit: limit, startAfter: startAfter);
}