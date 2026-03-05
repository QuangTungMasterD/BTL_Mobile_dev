import 'package:btl_music_app/features/music/data/models/artist_model.dart';
import 'package:btl_music_app/features/music/data/services/artist_service.dart';

class ArtistRepository {
  final ArtistService _service;

  ArtistRepository(this._service);

  Future<List<ArtistModel>> getAllArtists() => _service.getAllArtists();

  Future<ArtistModel?> getArtistById(String id) => _service.getArtistById(id);

  Future<List<ArtistModel>> searchArtists(String query) => _service.searchArtists(query);
}