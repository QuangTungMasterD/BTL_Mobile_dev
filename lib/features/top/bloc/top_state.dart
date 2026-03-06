import 'package:btl_music_app/features/music/data/models/song_model.dart';

class TopState {
  final List<SongModel> topSongs;
  final bool isLoading;
  final String? error;

  TopState({required this.topSongs, required this.isLoading, this.error});

  factory TopState.initial() {
    return TopState(topSongs: [], isLoading: false);
  }
}
