import 'package:btl_music_app/features/music/data/models/artist_model.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:btl_music_app/features/search/bloc/search_result/search_event.dart';
import 'package:btl_music_app/features/search/bloc/search_result/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/features/search/data/repo/search_repo.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _repository;

  SearchBloc({required SearchRepository repository})
      : _repository = repository,
        super(SearchInitial()) {
    on<SearchSongs>(_onSearchSongs);
    on<SearchArtists>(_onSearchArtists);
    on<ClearSearch>((event, emit) => emit(SearchInitial()));
  }

  Future<void> _onSearchSongs(SearchSongs event, Emitter<SearchState> emit) async {
    final currentArtists = (state is SearchLoaded) ? (state as SearchLoaded).artists : <ArtistModel> [];
    
    // Chỉ emit loading nếu chưa có kết quả nào
    if (currentArtists.isEmpty && (state is! SearchLoaded || (state as SearchLoaded).songs.isEmpty)) {
      emit(SearchLoading());
    }
    
    try {
      final songs = await _repository.searchSongs(event.query);
      emit(SearchLoaded(
        songs: songs,
        artists: currentArtists,
        query: event.query,
      ));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onSearchArtists(SearchArtists event, Emitter<SearchState> emit) async {
    final currentSongs = (state is SearchLoaded) ? (state as SearchLoaded).songs : <SongModel> [];
    
    // Chỉ emit loading nếu chưa có kết quả nào
    if (currentSongs.isEmpty && (state is! SearchLoaded || (state as SearchLoaded).artists.isEmpty)) {
      emit(SearchLoading());
    }
    
    try {
      final artists = await _repository.searchArtists(event.query);
      emit(SearchLoaded(
        songs: currentSongs,
        artists: artists,
        query: event.query,
      ));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}