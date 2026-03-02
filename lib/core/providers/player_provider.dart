// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';

// class PlayerProvider extends ChangeNotifier {
//   final AudioPlayer _player = AudioPlayer();

//   bool _isPlaying = false;
//   bool get isPlaying => _isPlaying;

//   String? _currentUrl;
//   String? get currentUrl => _currentUrl;

//   Future<void> play(String url) async {
//     if (_currentUrl != url) {
//       _currentUrl = url;
//       await _player.setUrl(url);
//     }

//     await _player.play();
//     _isPlaying = true;
//     notifyListeners();
//   }

//   Future<void> pause() async {
//     await _player.pause();
//     _isPlaying = false;
//     notifyListeners();
//   }

//   Future<void> stop() async {
//     await _player.stop();
//     _currentUrl = null;
//     _isPlaying = false;
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }
// }