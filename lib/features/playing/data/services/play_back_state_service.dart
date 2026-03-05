// features/playing/data/services/playback_state_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PlaybackStateService {
  static const String _key = 'playback_state';

  Future<void> saveState({
    required String? songId,
    required bool isPlaying,
    required int position,
    required int duration,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'songId': songId,
      'isPlaying': isPlaying,
      'position': position,
      'duration': duration,
    };
    await prefs.setString(_key, jsonEncode(data));
  }

  Future<Map<String, dynamic>?> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Future<void> clearState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}