import 'package:btl_music_app/features/library/bloc/playlist_songs/playlist_songs_event.dart';
import 'package:btl_music_app/features/library/bloc/playlist_songs/playlist_songs_state.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/features/library/data/repo/play_list_repo.dart';
import 'package:btl_music_app/features/music/data/repo/song_repo.dart';

class PlaylistSongsBloc extends Bloc<PlaylistSongsEvent, PlaylistSongsState> {
  final PlayListRepository _playlistRepo;
  final SongRepository _songRepo;

  PlaylistSongsBloc({
    required PlayListRepository playlistRepo,
    required SongRepository songRepo,
  })  : _playlistRepo = playlistRepo,
        _songRepo = songRepo,
        super(PlaylistSongsState()) {
    on<LoadPlaySongslist>(_onLoadPlaylistSongs);
  }

  Future<void> _onLoadPlaylistSongs(
    LoadPlaySongslist event,
    Emitter<PlaylistSongsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final playlist = await _playlistRepo.getPlaylistById(event.playlistId);
      if (playlist == null) {
        emit(state.copyWith(error: 'Không tìm thấy playlist', isLoading: false));
        return;
      }

      final songs = <SongModel>[];
      for (var id in playlist.songIds) {
        final song = await _songRepo.getSongById(id);
        if (song != null) songs.add(song);
      }

      emit(state.copyWith(
        songs: songs,
        playlistName: playlist.name,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}