import 'dart:async';
import 'package:btl_music_app/features/playing/data/repo/player_repo.dart';
import 'package:flutter/material.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:btl_music_app/core/providers/song_provider.dart';
import 'package:btl_music_app/features/playing/data/services/player_service.dart';

class PlayerProvider extends ChangeNotifier {
  final PlayerRepository _repo;
  final SongProvider _songProvider;

  SongModel? _currentSong;
  PlayerStateCustom _state = PlayerStateCustom.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  StreamSubscription<PlayerStateCustom>? _stateSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration>? _durationSub;

  SongModel? get currentSong => _currentSong;
  PlayerStateCustom get state => _state;
  Duration get position => _position;
  Duration get duration => _duration;
  bool get isPlaying => _state == PlayerStateCustom.playing;

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

    _durationSub = _repo.durationStream.listen((dur) {
      _duration = dur;
      notifyListeners();
    });

    // Đăng ký callback khi bài hát kết thúc
    _repo.setOnSongCompleted(() {
      if (_playlist.isNotEmpty) {
        next(); // Chuyển bài tiếp theo
      }
    });

    await _restoreState();
  }

  List<SongModel> _playlist = [];
  int _currentIndex = -1;

  List<SongModel> get playlist => _playlist;
  int get currentIndex => _currentIndex;

  // Thêm phương thức thiết lập playlist và bắt đầu phát
  void setPlaylist(List<SongModel> playlist, {int startIndex = 0}) {
    _playlist = playlist;
    if (playlist.isNotEmpty && startIndex >= 0 && startIndex < playlist.length) {
      _currentIndex = startIndex;
      playSong(playlist[_currentIndex]);
    } else {
      _currentIndex = -1;
    }
    notifyListeners();
  }

  Future<void> next() async {
    if (_playlist.isEmpty) return;
    int nextIndex = _currentIndex + 1;
    if (nextIndex >= _playlist.length) {
      nextIndex = 0;
    }
    _currentIndex = nextIndex;
    await playSong(_playlist[_currentIndex]);
  }

  // Phát bài trước đó
  Future<void> previous() async {
    if (_playlist.isEmpty) return;
    int prevIndex = _currentIndex - 1;
    if (prevIndex < 0) {
      // Nếu đang ở đầu playlist, có thể không làm gì
      return;
    }
    _currentIndex = prevIndex;
    await playSong(_playlist[_currentIndex]);
  }

  Future<void> _restoreState() async {
    final saved = await _repo.loadState();
    if (saved == null || saved['songId'] == null) return;

    final songId = saved['songId'] as String;
    final song = await _songProvider.getSongById(songId);

    if (song != null) {
      _currentSong = song;

      final isPlaying = saved['isPlaying'] as bool? ?? false;

      if (isPlaying) {
        await _repo.play(song.audio ?? '');
      }

      notifyListeners();
    } else {
      await _repo.clearState();
    }
  }

  Future<void> _persistState() async {
    await _repo.saveState(
      _currentSong?.id,
      _state == PlayerStateCustom.playing,
      _position.inMilliseconds,
      _duration.inMilliseconds,
    );
  }

  /// 🎧 PLAY SONG
  Future<void> playSong(SongModel song) async {
    // Tìm index trong playlist nếu có
    int index = _playlist.indexOf(song);
    if (index != -1) {
      _currentIndex = index;
    }
    _currentSong = song;
    await _repo.play(song.audio ?? '');
    notifyListeners();
    await _persistState();
  }

  Future<void> pause() async {
    await _repo.pause();
    await _persistState();
  }

  Future<void> resume() async {
    await _repo.resume();
    await _persistState();
  }

  Future<void> stop() async {
    await _repo.stop();

    _currentSong = null;
    _position = Duration.zero;
    _duration = Duration.zero;

    notifyListeners();
    await _persistState();
  }

  Future<void> seek(Duration newPosition) async {
    await _repo.seek(newPosition);
    await _persistState();
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _repo.dispose();
    super.dispose();
  }
}