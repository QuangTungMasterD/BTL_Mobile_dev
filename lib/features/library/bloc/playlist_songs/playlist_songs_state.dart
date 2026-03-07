import 'package:btl_music_app/features/music/data/models/song_model.dart';

class PlaylistSongsState {
  final List<SongModel> songs;
  final bool isLoading;
  final String? error;
  final String? playlistName;

  PlaylistSongsState({
    this.songs = const [],
    this.isLoading = false,
    this.error,
    this.playlistName,
  });

  PlaylistSongsState copyWith({
    List<SongModel>? songs,
    bool? isLoading,
    String? error,
    String? playlistName,
  }) {
    return PlaylistSongsState(
      songs: songs ?? this.songs,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      playlistName: playlistName ?? this.playlistName,
    );
  }
}