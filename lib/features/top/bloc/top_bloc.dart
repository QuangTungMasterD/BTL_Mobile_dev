// lib/features/top/bloc/chart_bloc.dart
import 'package:btl_music_app/features/top/bloc/top_event.dart';
import 'package:btl_music_app/features/top/bloc/top_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/features/music/data/repo/song_repo.dart';

class TopBloc extends Bloc<TopEvent, TopState> {
  final SongRepository repository;

  TopBloc({required this.repository}) : super(TopState.initial()) {
    on<LoadTopSongs>((event, emit) async {
      emit(TopState(topSongs: [], isLoading: true));
      try {
        final songs = await repository.getTopSongs(limit: event.limit);
        emit(TopState(topSongs: songs, isLoading: false));
      } catch (e) {
        emit(TopState(topSongs: [], isLoading: false, error: e.toString()));
      }
    });
  }
}