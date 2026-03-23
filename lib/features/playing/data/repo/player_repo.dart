import 'package:btl_music_app/features/playing/data/services/play_back_state_service.dart';
import 'package:btl_music_app/features/playing/data/services/player_service.dart';

class PlayerRepository {
  final PlayerService _playerService;
  final PlaybackStateService _stateService;

  PlayerRepository(this._playerService, this._stateService);

  // 🎧 Player controls
  Future<void> play(String path) => _playerService.play(path);
  Future<void> pause() => _playerService.pause();
  Future<void> resume() => _playerService.resume();
  Future<void> stop() => _playerService.stop();
  Future<void> seek(Duration position) => _playerService.seek(position);

  // 🎵 Streams
  Stream<PlayerStateCustom> get stateStream => _playerService.stateStream;
  Stream<Duration> get positionStream => _playerService.positionStream;
  Stream<Duration> get durationStream => _playerService.durationStream;

  PlayerStateCustom get currentState => _playerService.currentState;

  // 💾 State persistence
  Future<void> saveState(
    String? songId,
    bool isPlaying,
    int position,
    int duration,
  ) =>
      _stateService.saveState(
        songId: songId,
        isPlaying: isPlaying,
        position: position,
        duration: duration,
      );

  Future<Map<String, dynamic>?> loadState() =>
      _stateService.loadState();

  Future<void> clearState() =>
      _stateService.clearState();

  void dispose() => _playerService.dispose();
}