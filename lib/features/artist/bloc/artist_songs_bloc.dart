import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/features/music/data/repo/artist_repo.dart';
import 'package:btl_music_app/features/music/data/repo/song_repo.dart';
import 'artist_songs_event.dart';
import 'artist_songs_state.dart';

class ArtistSongsBloc extends Bloc<ArtistSongsEvent, ArtistSongsState> {
  final ArtistRepository _artistRepo;
  final SongRepository _songRepo;

  ArtistSongsBloc({
    required ArtistRepository artistRepo,
    required SongRepository songRepo,
  })  : _artistRepo = artistRepo,
        _songRepo = songRepo,
        super(ArtistSongsInitial()) {
    on<LoadArtistSongs>(_onLoadArtistSongs);
  }

  Future<void> _onLoadArtistSongs(
    LoadArtistSongs event,
    Emitter<ArtistSongsState> emit,
  ) async {
    emit(ArtistSongsLoading());
    try {
      // Load artist
      final artist = await _artistRepo.getArtistById(event.artistId);
      if (artist == null) {
        emit(ArtistSongsError('Không tìm thấy nghệ sĩ'));
        return;
      }
      // Load songs by artistId
      final songs = await _songRepo.getSongsByArtistId(event.artistId);
      emit(ArtistSongsLoaded(artist: artist, songs: songs));
    } catch (e) {
      emit(ArtistSongsError(e.toString()));
    }
  }
}
