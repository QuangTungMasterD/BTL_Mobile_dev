import 'dart:async';
import 'package:btl_music_app/features/playing/data/repo/player_repo.dart';
import 'package:btl_music_app/features/playing/data/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:btl_music_app/core/providers/song_provider.dart';

class PlayerProvider extends ChangeNotifier {
  final PlayerRepository _repo;
  final SongProvider _songProvider;

  SongModel? _currentSong;
  PlayerState _state = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<Duration>? _positionSub;

  SongModel? get currentSong => _currentSong;
  PlayerState get state => _state;
  Duration get position => _position;
  Duration get duration => _duration;
  bool get isPlaying => _state == PlayerState.playing;

  PlayerProvider(this._repo, this._songProvider) {
    _init();
  }

  Future<void> _init() async {
    
    _stateSub = _repo.stateStream.listen((newState) {
      _state = newState;
      notifyListeners();
    });

    _positionSub = _repo.positionStream.listen((newPos) {
      _position = newPos;
      notifyListeners();
    });

    await _restoreState();
  }

  Future<void> _restoreState() async {
    final saved = await _repo.loadState();
    if (saved == null || saved['songId'] == null) return;

    final songId = saved['songId'] as String;
    final song = await _songProvider.getSongById(songId);
    if (song != null) {
      _currentSong = song;
      _duration = Duration(milliseconds: saved['duration'] ?? 0);
      _position = Duration(milliseconds: saved['position'] ?? 0);
      final isPlaying = saved['isPlaying'] as bool? ?? false;
      _state = isPlaying ? PlayerState.playing : PlayerState.paused;
      _repo.setDuration(_duration);
      if (isPlaying) {
        _repo.play(song.audio ?? '');
      } else {
        _repo.stop();
      }
      notifyListeners();
    } else {
      await _repo.clearState();
    }
  }

  Future<void> _persistState() async {
    await _repo.saveState(
      _currentSong?.id,
      _state == PlayerState.playing,
      _position.inMilliseconds,
      _duration.inMilliseconds,
    );
  }

  
  Future<void> playSong(SongModel song) async {
    _currentSong = song;
    _duration = Duration(seconds: song.duration ?? 0);
    _position = Duration.zero;
    _state = PlayerState.playing;
    _repo.setDuration(_duration);
    _repo.play(song.audio ?? '');
    notifyListeners();
    await _persistState();
  }

  void pause() {
    if (_state == PlayerState.playing) {
      _repo.pause();
      
      _state = PlayerState.paused;
      notifyListeners();
      _persistState();
    }
  }

  void resume() {
    if (_state == PlayerState.paused) {
      _repo.resume();
      _state = PlayerState.playing;
      notifyListeners();
      _persistState();
    }
  }

  void stop() {
    _repo.stop();
    _currentSong = null;
    _position = Duration.zero;
    _duration = Duration.zero;
    notifyListeners();
    _persistState();
  }

  Future<void> seek(Duration newPosition) async {
    if (_currentSong == null) return;
    _repo.seek(newPosition);
    
    await _persistState();
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _positionSub?.cancel();
    _repo.dispose();
    super.dispose();
  }
}