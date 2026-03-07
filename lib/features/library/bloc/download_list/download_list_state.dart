import 'package:btl_music_app/features/music/data/models/song_model.dart';

class DownloadedState {
  final List<SongModel> songs;
  final bool isLoading;
  final String? error;

  DownloadedState({
    this.songs = const [],
    this.isLoading = false,
    this.error,
  });

  DownloadedState copyWith({
    List<SongModel>? songs,
    bool? isLoading,
    String? error,
  }) {
    return DownloadedState(
      songs: songs ?? this.songs,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}