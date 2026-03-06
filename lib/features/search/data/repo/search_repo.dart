import 'package:btl_music_app/features/music/data/repo/song_repo.dart';
import 'package:btl_music_app/features/music/data/repo/artist_repo.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:btl_music_app/features/music/data/models/artist_model.dart';

class SearchRepository {
  final SongRepository _songRepo;
  final ArtistRepository _artistRepo;

  SearchRepository({required SongRepository songRepo, required ArtistRepository artistRepo})
      : _songRepo = songRepo,
        _artistRepo = artistRepo;

  Future<List<SongModel>> searchSongs(String query) => _songRepo.searchSongs(query);
  Future<List<ArtistModel>> searchArtists(String query) => _artistRepo.searchArtists(query);
}