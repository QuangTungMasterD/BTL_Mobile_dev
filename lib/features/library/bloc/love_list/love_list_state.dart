import 'package:btl_music_app/features/music/data/models/song_model.dart';

class LoveListState {
  final List<SongModel> songs;
  final bool isLoading;
  final String? error;

  LoveListState({
    this.songs = const [],
    this.isLoading = false,
    this.error,
  });

  LoveListState copyWith({
    List<SongModel>? songs,
    bool? isLoading,
    String? error,
  }) {
    return LoveListState(
      songs: songs ?? this.songs,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
