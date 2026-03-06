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
    emit(SearchLoading());
    try {
      final songs = await _repository.searchSongs(event.query);
      // Giữ lại artists hiện tại nếu có, hoặc khởi tạo rỗng
      final currentState = state;
      final currentArtists = (currentState is SearchLoaded) ? currentState.artists : <ArtistModel> [];
      emit(SearchLoaded(songs: songs, artists: currentArtists, query: event.query));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onSearchArtists(SearchArtists event, Emitter<SearchState> emit) async {
    // Nếu đang loading thì không làm gì? Có thể emit loading riêng nhưng ở đây ta giữ loading chung
    emit(SearchLoading());
    try {
      final artists = await _repository.searchArtists(event.query);
      final currentState = state;
      final currentSongs = (currentState is SearchLoaded) ? currentState.songs : <SongModel> [];
      emit(SearchLoaded(songs: currentSongs, artists: artists, query: event.query));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}