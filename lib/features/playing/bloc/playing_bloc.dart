import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/features/playing/bloc/playing_event.dart';
import 'package:btl_music_app/features/playing/bloc/playing_state.dart';

class PlayingBloc extends Bloc<PlayingEvent, PlayingState> {
  PlayingBloc() : super(PlayingState.initial()) {
    on<ChangePage>((event, emit) {
      emit(state.copyWith(currentPage: event.pageIndex));
    });
  }
}
