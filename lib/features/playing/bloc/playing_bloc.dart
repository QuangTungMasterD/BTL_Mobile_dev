import 'package:btl_music_app/features/playing/bloc/playing_event.dart';
import 'package:btl_music_app/features/playing/bloc/playing_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayingBloc extends Bloc<PlayingEvent, PlayingState> {
  PlayingBloc() : super(PlayingState.initial()) {
    on<ChangePage>(_onChangePage);
    on<ToggleShuffle>(_onToggleShuffle);
    on<ToggleRepeat>(_onToggleRepeat);
    on<SetRepeatMode>(_onSetRepeatMode);
    on<SetPlaybackState>(_onSetPlaybackState);

    _loadState(); // tải trạng thái lưu trữ
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final shuffle = prefs.getBool('shuffle') ?? false;
    final repeatModeStr = prefs.getString('repeatMode') ?? RepeatMode.none.name;
    final repeatMode = RepeatMode.values.firstWhere(
      (e) => e.name == repeatModeStr,
      orElse: () => RepeatMode.none,
    );
    emit(state.copyWith(shuffle: shuffle, repeatMode: repeatMode));
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('shuffle', state.shuffle);
    await prefs.setString('repeatMode', state.repeatMode.name);
    // không cần lưu isPlaying vì nó thay đổi liên tục
  }

  void _onChangePage(ChangePage event, Emitter<PlayingState> emit) {
    emit(state.copyWith(currentPage: event.pageIndex));
  }

  void _onToggleShuffle(ToggleShuffle event, Emitter<PlayingState> emit) {
    final newShuffle = !state.shuffle;
    emit(state.copyWith(shuffle: newShuffle));
    _saveState();
  }

  void _onToggleRepeat(ToggleRepeat event, Emitter<PlayingState> emit) {
    final newMode = _nextRepeatMode(state.repeatMode);
    emit(state.copyWith(repeatMode: newMode));
    _saveState();
  }

  void _onSetRepeatMode(SetRepeatMode event, Emitter<PlayingState> emit) {
    emit(state.copyWith(repeatMode: event.mode));
    _saveState();
  }

  void _onSetPlaybackState(SetPlaybackState event, Emitter<PlayingState> emit) {
    emit(state.copyWith(isPlaying: event.isPlaying));
    // Không lưu isPlaying vào shared preferences
  }

  RepeatMode _nextRepeatMode(RepeatMode current) {
    switch (current) {
      case RepeatMode.none:
        return RepeatMode.one;
      case RepeatMode.one:
        return RepeatMode.all;
      case RepeatMode.all:
        return RepeatMode.none;
    }
  }
}