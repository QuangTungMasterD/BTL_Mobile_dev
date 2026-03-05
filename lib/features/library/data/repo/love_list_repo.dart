// features/library/data/repo/love_list_repo.dart
import 'package:btl_music_app/features/library/data/models/love_list_model.dart';
import 'package:btl_music_app/features/library/data/services/love_list_service.dart';

class LoveListRepository {
  final LoveListService _service;

  LoveListRepository(this._service);

  Stream<LoveListModel?> getLoveListStream(String userId) =>
      _service.getLoveListStream(userId);

  Future<void> createLoveList(String userId) => _service.createLoveList(userId);

  Future<void> addSongToLoveList(String userId, String songId) =>
      _service.addSongToLoveList(userId, songId);

  Future<void> removeSongFromLoveList(String userId, String songId) =>
      _service.removeSongFromLoveList(userId, songId);

  Future<LoveListModel?> getLoveListOnce(String userId) =>
      _service.getLoveListOnce(userId);
}