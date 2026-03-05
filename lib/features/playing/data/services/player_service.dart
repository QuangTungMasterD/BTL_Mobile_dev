// features/playing/data/services/player_service.dart
import 'dart:async';

enum PlayerState { stopped, playing, paused }

class PlayerService {
  PlayerState _state = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  final _stateController = StreamController<PlayerState>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();

  Stream<PlayerState> get stateStream => _stateController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  PlayerState get currentState => _state;
  Duration get currentPosition => _position;
  Duration get currentDuration => _duration;

  // Không thực sự phát nhạc, chỉ cập nhật trạng thái
  void play(String url) {
    // Giả sử bài hát có duration 180s (lấy từ metadata sau)
    _state = PlayerState.playing;
    _stateController.add(_state);
    // Không chạy timer, position chỉ thay đổi khi người dùng seek
  }

  void pause() {
    if (_state == PlayerState.playing) {
      _state = PlayerState.paused;
      _stateController.add(_state);
    }
  }

  void resume() {
    if (_state == PlayerState.paused) {
      _state = PlayerState.playing;
      _stateController.add(_state);
    }
  }

  void stop() {
    _state = PlayerState.stopped;
    _position = Duration.zero;
    _stateController.add(_state);
    _positionController.add(_position);
  }

  void seek(Duration newPosition) {
    if (newPosition < Duration.zero) newPosition = Duration.zero;
    if (newPosition > _duration) newPosition = _duration;
    _position = newPosition;
    _positionController.add(_position);
  }

  // Cập nhật duration khi có bài hát mới
  void setDuration(Duration duration) {
    _duration = duration;
  }

  void dispose() {
    _stateController.close();
    _positionController.close();
  }
}