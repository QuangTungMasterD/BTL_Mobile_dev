import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:btl_music_app/features/music/data/models/artist_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<SongModel> songs;
  final List<ArtistModel> artists;
  final String query;

  SearchLoaded({required this.songs, required this.artists, required this.query});
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}