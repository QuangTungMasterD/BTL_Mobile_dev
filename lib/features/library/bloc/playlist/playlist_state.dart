import 'package:btl_music_app/features/library/data/models/play_list_model.dart';

class PlaylistState {
  final List<PlayListModel> playlists;
  final bool isLoading;
  final String? error;

  PlaylistState({
    this.playlists = const [],
    this.isLoading = false,
    this.error,
  });

  PlaylistState copyWith({
    List<PlayListModel>? playlists,
    bool? isLoading,
    String? error,
  }) {
    return PlaylistState(
      playlists: playlists ?? this.playlists,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
