import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

enum PlayerStateCustom { stopped, playing, paused }

class PlayerService {
  VoidCallback? onSongCompleted;
  
  final AudioPlayer _player = AudioPlayer();

  PlayerStateCustom _state = PlayerStateCustom.stopped;

  final _stateController = StreamController<PlayerStateCustom>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();

  Stream<PlayerStateCustom> get stateStream => _stateController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;

  PlayerStateCustom get currentState => _state;

  Future<void> clearJustAudioCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final justAudioCacheDir = Directory('${cacheDir.path}/just_audio_cache');
      if (await justAudioCacheDir.exists()) {
        await justAudioCacheDir.delete(recursive: true);
        print('Đã xóa just_audio_cache cũ');
      }
    } catch (e) {
      print('Lỗi khi xóa cache: $e');
    }
  }

  PlayerService() {
    // listen position
    _player.positionStream.listen((pos) {
      _positionController.add(pos);
    });

    // listen duration
    _player.durationStream.listen((dur) {
      if (dur != null) {
        _durationController.add(dur);
      }
    });

    // listen state
    _player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _state = PlayerStateCustom.stopped;
        onSongCompleted?.call();
      } else if (playerState.playing) {
        _state = PlayerStateCustom.playing;
      } else {
        _state = PlayerStateCustom.paused;
      }
      print('Song i dont no!');
      _stateController.add(_state);
    });
  }

  bool _isNetworkUrl(String path) {
  return path.startsWith('http://') || path.startsWith('https://');
  }

  Future<void> load(String path) async {
    if (_isNetworkUrl(path)) {
      await _player.setUrl(path);
    } else {
      await _player.setAsset(path);
    }
  }

  /// 🔥 PLAY LOCAL AUDIO
  Future<void> play(String assetPath) async {
    // await clearJustAudioCache();
    await this.load(assetPath); // load file
    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  void dispose() {
    _player.dispose();
    _stateController.close();
    _positionController.close();
    _durationController.close();
  }
}