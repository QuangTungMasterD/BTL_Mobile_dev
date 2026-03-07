import 'package:btl_music_app/features/library/bloc/download_list/download_list_event.dart';
import 'package:btl_music_app/features/library/bloc/download_list/download_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/core/database/database_helper.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';

class DownloadedBloc extends Bloc<DownloadedEvent, DownloadedState> {
  DownloadedBloc() : super(DownloadedState()) {
    on<LoadDownloaded>(_onLoadDownloaded);
  }

  Future<void> _onLoadDownloaded(
    LoadDownloaded event,
    Emitter<DownloadedState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final data = await DatabaseHelper.instance.getDownloadedSongs();
      final songs = data.map((map) {
        return SongModel(
          id: map['songId'] as String,
          title: map['title'] as String,
          artist: map['artist'] as String,
          thumbnailUrl: map['thumbnailUrl'] as String? ?? '',
          artistId: '',
          youtubeId: '',
          duration: 0,
          playCount: 0,
          likeCount: 0,
        );
      }).toList();
      emit(state.copyWith(songs: songs, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}