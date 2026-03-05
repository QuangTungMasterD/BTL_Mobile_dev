import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';

class PlayerProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  final YoutubeExplode _yt = YoutubeExplode();

  SongModel? _currentSong;
  List<SongModel> _playlist = [];
  int _currentIndex = 0;

  bool _isInitialized = false;

  SongModel? get currentSong => _currentSong;
  bool get isPlaying => _player.playing;
  Duration get position => _player.position;
  Duration get duration => _player.duration ?? Duration.zero;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  PlayerProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;

    try {
      await JustAudioBackground.init(
      androidNotificationChannelId: 'com.btl.music.channel.audio',
      androidNotificationChannelName: 'Music Playback',
      // androidNotificationColor: Colors.deepPurple.value,
      androidShowNotificationBadge: true,
      androidStopForegroundOnPause: true,
      // XÓA DÒNG NÀY: notificationIcon: const AndroidResource(...)
    );
      _isInitialized = true;
      debugPrint("JustAudioBackground init thành công");
    } catch (e) {
      debugPrint("Lỗi init JustAudioBackground: $e");
    }
  }

  /// Phát một bài hát từ model
  Future<void> playSong(SongModel song) async {
    // Đảm bảo đã init trước khi phát
    await _initialize();

    _currentSong = song;
    _playlist = [song];
    _currentIndex = 0;

    await _playAudio(song.youtubeId);
    notifyListeners();
  }

  // Các hàm khác giữ nguyên: playPlaylist, _playAudio, playPause, seek, next, previous...

  Future<void> _playAudio(String videoId) async {
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(videoId);
      final audio = manifest.audioOnly.withHighestBitrate();

      await _player.setAudioSource(
        LockCachingAudioSource(
          Uri.parse(audio.url.toString()),
          tag: MediaItem(
            id: videoId,
            title: _currentSong?.title ?? 'Unknown',
            artist: _currentSong?.artist ?? 'Unknown',
            artUri: _currentSong?.thumbnailUrl != null
                ? Uri.parse(_currentSong!.thumbnailUrl!)
                : null,
          ),
        ),
      );

      await _player.play();
    } catch (e) {
      debugPrint("Lỗi stream YouTube: $e");
    }
  }

  // ... các hàm playPause, seek, next, previous giữ nguyên như cũ

  @override
  void dispose() {
    _player.dispose();
    _yt.close();
    super.dispose();
  }
}