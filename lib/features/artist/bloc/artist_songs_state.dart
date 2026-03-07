import 'package:btl_music_app/features/music/data/models/artist_model.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';

abstract class ArtistSongsState {}

class ArtistSongsInitial extends ArtistSongsState {}

class ArtistSongsLoading extends ArtistSongsState {}

class ArtistSongsLoaded extends ArtistSongsState {
  final ArtistModel artist;
  final List<SongModel> songs;
  ArtistSongsLoaded({required this.artist, required this.songs});
}

class ArtistSongsError extends ArtistSongsState {
  final String message;
  ArtistSongsError(this.message);
}
