import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/features/library/data/repo/love_list_repo.dart';
import 'package:btl_music_app/features/music/data/repo/song_repo.dart';
import 'love_list_event.dart';
import 'love_list_state.dart';

class LoveListBloc extends Bloc<LoveListEvent, LoveListState> {
  final LoveListRepository _loveRepo;
  final SongRepository _songRepo;

  LoveListBloc({
    required LoveListRepository loveRepo,
    required SongRepository songRepo,
  })  : _loveRepo = loveRepo,
        _songRepo = songRepo,
        super(LoveListState()) {
    on<LoadLoveList>(_onLoadLoveList);
  }

  Future<void> _onLoadLoveList(
    LoadLoveList event,
    Emitter<LoveListState> emit,
  ) async {
    if (event.userId.isEmpty) {
      emit(state.copyWith(songs: [], isLoading: false));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));
    try {
      // Lấy danh sách songIds từ love list
      final loveList = await _loveRepo.getLoveListOnce(event.userId);
      final songIds = loveList?.songIds ?? [];

      // Load chi tiết từng bài hát
      final songs = <SongModel>[];
      for (var id in songIds) {
        final song = await _songRepo.getSongById(id);
        if (song != null) songs.add(song);
      }

      emit(state.copyWith(songs: songs, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
