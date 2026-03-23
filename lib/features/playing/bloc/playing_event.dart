import 'package:btl_music_app/features/playing/bloc/playing_state.dart';

abstract class PlayingEvent {}

class ChangePage extends PlayingEvent {
  final int pageIndex;
  ChangePage(this.pageIndex);
}

class ToggleShuffle extends PlayingEvent {}

class ToggleRepeat extends PlayingEvent {}

class SetRepeatMode extends PlayingEvent {
  final RepeatMode mode;
  SetRepeatMode(this.mode);
}

class SetPlaybackState extends PlayingEvent {
  final bool isPlaying;
  SetPlaybackState(this.isPlaying);
}