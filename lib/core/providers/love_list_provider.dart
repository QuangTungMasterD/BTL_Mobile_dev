import 'dart:async';

import 'package:btl_music_app/features/library/data/models/love_list_model.dart';
import 'package:btl_music_app/features/library/data/repo/love_list_repo.dart';
import 'package:flutter/material.dart';

class LoveListProvider extends ChangeNotifier {
  final LoveListRepository _repo;
  final String userId;

  LoveListModel? _loveList;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<LoveListModel?>? _subscription;

  LoveListModel? get loveList => _loveList;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<String> get songIds => _loveList?.songIds ?? [];

  LoveListProvider(this._repo, this.userId) {
    _init();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _init() {
    if (userId.isEmpty) return;
    _isLoading = true;
    notifyListeners();

    _subscription = _repo.getLoveListStream(userId).listen(
      (loveList) {
        _loveList = loveList;
        _isLoading = false;
        notifyListeners();

        if (loveList == null) {
          _createInitialLoveList();
        }
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> _createInitialLoveList() async {
    try {
      await _repo.createLoveList(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleLoveSong(String songId) async {
    if (userId.isEmpty) return;
    final isLoved = songIds.contains(songId);
    try {
      if (isLoved) {
        await _repo.removeSongFromLoveList(userId, songId);
      } else {
        if (_loveList == null) {
          await _repo.createLoveList(userId);
        }
        await _repo.addSongToLoveList(userId, songId);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  bool isLoved(String songId) => songIds.contains(songId);
}