import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/features/library/data/repo/play_list_repo.dart';
import 'package:btl_music_app/features/library/data/models/play_list_model.dart';
import 'playlist_event.dart';
import 'playlist_state.dart';

class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final PlayListRepository _repository;

  PlaylistBloc({required PlayListRepository repository})
      : _repository = repository,
        super(PlaylistState()) {
    on<LoadPlaylists>(_onLoadPlaylists);
    on<CreatePlaylist>(_onCreatePlaylist);
    on<DeletePlaylist>(_onDeletePlaylist);
  }

  Future<void> _onLoadPlaylists(
    LoadPlaylists event,
    Emitter<PlaylistState> emit,
  ) async {
    if (event.userId.isEmpty) {
      emit(state.copyWith(playlists: [], isLoading: false));
      return;
    }
    emit(state.copyWith(isLoading: true, error: null));
    try {
      // Lấy dữ liệu một lần từ stream
      final stream = _repository.getUserPlaylists(event.userId);
      final playlists = await stream.first;
      emit(state.copyWith(playlists: playlists, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onCreatePlaylist(
    CreatePlaylist event,
    Emitter<PlaylistState> emit,
  ) async {
    try {
      final newPlaylist = PlayListModel(
        id: '',
        name: event.name,
        coverUrl: event.coverUrl,
        userId: event.userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        songIds: [],
      );
      await _repository.createPlaylist(newPlaylist);
      add(LoadPlaylists(event.userId));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDeletePlaylist(
    DeletePlaylist event,
    Emitter<PlaylistState> emit,
  ) async {
    try {
      await _repository.deletePlaylist(event.playlistId);
      add(LoadPlaylists(event.userId));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}