// features/playing/data/repos/player_repo.dart
import 'package:btl_music_app/features/playing/data/services/play_back_state_service.dart';
import 'package:btl_music_app/features/playing/data/services/player_service.dart';

class PlayerRepository {
  final PlayerService _playerService;
  final PlaybackStateService _stateService;

  PlayerRepository(this._playerService, this._stateService);

  // Player operations (giả lập)
  void play(String url) => _playerService.play(url);
  void pause() => _playerService.pause();
  void resume() => _playerService.resume();
  void stop() => _playerService.stop();
  void seek(Duration position) => _playerService.seek(position);
  void setDuration(Duration duration) => _playerService.setDuration(duration);

  // Streams
  Stream<PlayerState> get stateStream => _playerService.stateStream;
  Stream<Duration> get positionStream => _playerService.positionStream;
  PlayerState get currentState => _playerService.currentState;
  Duration get currentPosition => _playerService.currentPosition;
  Duration get currentDuration => _playerService.currentDuration;

  // State persistence
  Future<void> saveState(String? songId, bool isPlaying, int position, int duration) =>
      _stateService.saveState(songId: songId, isPlaying: isPlaying, position: position, duration: duration);

  Future<Map<String, dynamic>?> loadState() => _stateService.loadState();
  Future<void> clearState() => _stateService.clearState();

  void dispose() => _playerService.dispose();
}