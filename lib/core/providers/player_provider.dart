import 'dart:async';
import 'dart:math';
import 'package:btl_music_app/features/playing/bloc/playing_bloc.dart';
import 'package:btl_music_app/features/playing/bloc/playing_event.dart';
import 'package:btl_music_app/features/playing/data/repo/player_repo.dart';
import 'package:flutter/material.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:btl_music_app/core/providers/song_provider.dart';
import 'package:btl_music_app/features/playing/data/services/player_service.dart';
import 'package:btl_music_app/features/playing/bloc/playing_state.dart';

class PlayerProvider extends ChangeNotifier {
  final PlayerRepository _repo;
  final SongProvider _songProvider;

  SongModel? _currentSong;

  List<SongModel> _playlist = [];
  int _currentIndex = -1;

  List<SongModel> get playlist => _playlist;
  int get currentIndex => _currentIndex;

  List<SongModel> _history = [];
  int _historyIndex = -1;

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

  final PlayingBloc _playingBloc;
  StreamSubscription? _playingBlocSub;

  PlayerProvider(
    this._repo, 
    this._songProvider, 
    this._playingBloc
  ) {
    _init();
    _listenToBloc();
  }

  void _listenToBloc() {
    _playingBlocSub = _playingBloc.stream.listen((state) {
      notifyListeners();
    });
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

    _repo.setOnSongCompleted(() {
      final repeatMode = _playingBloc.state.repeatMode;
      if (repeatMode == RepeatMode.one) {
        playSong(_currentSong!);
      } else if (_playlist.isNotEmpty) {
        next();
      }
    });

    await _restoreState();
  }

  void setPlaylist(List<SongModel> playlist, {int startIndex = 0}) {
    _playlist = playlist;
    _history = [];
    if (playlist.isNotEmpty && startIndex >= 0 && startIndex < playlist.length) {
      _currentIndex = startIndex;
      final song = playlist[_currentIndex];
      _addToHistory(song);
      playSong(song);
    } else {
      _currentIndex = -1;
    }
    notifyListeners();
  }

  void _addToHistory(SongModel song) {
    if (_history.isNotEmpty && _history.last.id == song.id) return;
    if (_historyIndex >= 0 && _historyIndex < _history.length - 1) {
      _history = _history.sublist(0, _historyIndex + 1);
    }
    _history.add(song);
    _historyIndex = _history.length - 1;
  }

  Future<void> next() async {
    if (_playlist.isEmpty) return;
    final state = _playingBloc.state;
    int nextIndex;

    if (state.repeatMode == RepeatMode.one) {
      nextIndex = _currentIndex;
    } else if (state.shuffle) {
      // Chọn ngẫu nhiên một bài khác với bài hiện tại (nếu có hơn 1 bài)
      if (_playlist.length > 1) {
        do {
          nextIndex = Random().nextInt(_playlist.length);
        } while (nextIndex == _currentIndex);
      } else {
        nextIndex = _currentIndex;
      }
    } else {
      nextIndex = _currentIndex + 1;
      if (nextIndex >= _playlist.length) {
        if (state.repeatMode == RepeatMode.all) {
          nextIndex = 0;
        } else {
          nextIndex = _currentIndex;
        }
      }
    }

    _currentIndex = nextIndex;
    await playSong(_playlist[_currentIndex]);
  }

  Future<void> previous() async {
    final state = _playingBloc.state;

    if (state.repeatMode == RepeatMode.one) {
      await seek(Duration.zero);
      return;
    }

    if (_historyIndex > 0 && _position <= const Duration(seconds: 10)) {
      _historyIndex--;
      final previousSong = _history[_historyIndex];
      await playSong(previousSong);
    }
    await seek(Duration.zero);
  }

  Future<void> _restoreState() async {
    final saved = await _repo.loadState();
    if (saved == null || saved['songId'] == null) return;

    final songId = saved['songId'] as String;
    final song = await _songProvider.getSongById(songId);

    if (song != null) {
      _currentSong = song;

      await _repo.load(song.audio);

      final isPlaying = saved['isPlaying'] as bool? ?? false;

      if (isPlaying) {
        await _repo.play(song.audio);
        _playingBloc.add(SetPlaybackState(true));
      } else {
        _playingBloc.add(SetPlaybackState(false));
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
    int index = _playlist.indexOf(song);
    if (index != -1) {
      _currentIndex = index;
    }
    _currentSong = song;
    _addToHistory(song);
    await _repo.play(song.audio);
    _playingBloc.add(SetPlaybackState(true));
    notifyListeners();
    await _persistState();
  }

  Future<void> pause() async {
    await _repo.pause();
    _playingBloc.add(SetPlaybackState(false));
    await _persistState();
  }

  Future<void> resume() async {
    await _repo.resume();
    _playingBloc.add(SetPlaybackState(true));
    await _persistState();
  }

  Future<void> stop() async {
    await _repo.stop();
    _playingBloc.add(SetPlaybackState(false));

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
    _playingBlocSub?.cancel();
    _repo.dispose();
    super.dispose();
  }
}