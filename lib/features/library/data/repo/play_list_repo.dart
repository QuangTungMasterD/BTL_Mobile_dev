import 'package:btl_music_app/features/library/data/models/play_list_model.dart';
import 'package:btl_music_app/features/library/data/services/play_list_service.dart';

class PlayListRepository {
  final PlayListService _service;

  PlayListRepository(this._service);

  Stream<List<PlayListModel>> getUserPlaylists(String userId) =>
      _service.getUserPlaylists(userId);

  Future<String> createPlaylist(PlayListModel playlist) =>
      _service.createPlaylist(playlist);

  Future<void> updatePlaylist(PlayListModel playlist) =>
      _service.updatePlaylist(playlist);

  Future<void> deletePlaylist(String playlistId) =>
      _service.deletePlaylist(playlistId);

  Future<void> addSongToPlaylist(String playlistId, String songId) =>
      _service.addSongToPlaylist(playlistId, songId);

  Future<void> removeSongFromPlaylist(String playlistId, String songId) =>
      _service.removeSongFromPlaylist(playlistId, songId);

  Future<PlayListModel?> getPlaylistById(String playlistId) =>
      _service.getPlaylistById(playlistId);
}