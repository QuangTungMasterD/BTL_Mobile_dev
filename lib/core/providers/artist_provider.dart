import 'package:btl_music_app/features/music/data/repo/artist_repo.dart';
import 'package:flutter/material.dart';
import 'package:btl_music_app/features/music/data/models/artist_model.dart';

class ArtistProvider extends ChangeNotifier {
  final ArtistRepository _repo;

  List<ArtistModel> _allArtists = [];
  List<ArtistModel> _searchResults = [];
  bool _isLoading = false;
  String? _error;

  List<ArtistModel> get allArtists => _allArtists;
  List<ArtistModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ArtistProvider(this._repo) {
    loadAllArtists();
  }

  Future<void> loadAllArtists() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allArtists = await _repo.getAllArtists();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchArtists(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _repo.searchArtists(query.trim());
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}