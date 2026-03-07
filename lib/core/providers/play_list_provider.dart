import 'dart:async';

import 'package:btl_music_app/features/library/data/models/play_list_model.dart';
import 'package:btl_music_app/features/library/data/repo/play_list_repo.dart';
import 'package:flutter/material.dart';

class PlayListProvider extends ChangeNotifier {
  final PlayListRepository _repo;
  final String userId;
  StreamSubscription? _subscription;

  List<PlayListModel> _playlists = [];
  bool _isLoading = false;
  String? _error;

  List<PlayListModel> get playlists => _playlists;
  bool get isLoading => _isLoading;
  String? get error => _error;

  PlayListProvider(this._repo, this.userId) {
    loadUserPlaylists();
  }

  void loadUserPlaylists() {
    _subscription?.cancel();
    if (userId.isEmpty) {
      _playlists = [];
      _isLoading = false;
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();

    _subscription = _repo.getUserPlaylists(userId).listen(
      (playlists) {
        _playlists = playlists;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> createPlaylist(String name, String? coverUrl) async {
    final newPlaylist = PlayListModel(
      id: '',
      name: name,
      coverUrl: coverUrl,
      userId: userId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      songIds: [],
    );

    final playlistId = await _repo.createPlaylist(newPlaylist);
    loadUserPlaylists();
  }

  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    await _repo.addSongToPlaylist(playlistId, songId);
    loadUserPlaylists();
  }

  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    await _repo.removeSongFromPlaylist(playlistId, songId);
    loadUserPlaylists();
  }

  Future<void> deletePlaylist(String playlistId) async {
    await _repo.deletePlaylist(playlistId);
    loadUserPlaylists();
  }
}