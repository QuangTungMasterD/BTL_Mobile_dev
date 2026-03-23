enum RepeatMode { none, one, all }

class PlayingState {
  final int currentPage;
  final bool shuffle;
  final RepeatMode repeatMode;
  final bool isPlaying; // trạng thái phát hiện tại

  const PlayingState({
    required this.currentPage,
    required this.shuffle,
    required this.repeatMode,
    required this.isPlaying,
  });

  factory PlayingState.initial() {
    return const PlayingState(
      currentPage: 0,
      shuffle: false,
      repeatMode: RepeatMode.none,
      isPlaying: false,
    );
  }

  PlayingState copyWith({
    int? currentPage,
    bool? shuffle,
    RepeatMode? repeatMode,
    bool? isPlaying,
  }) {
    return PlayingState(
      currentPage: currentPage ?? this.currentPage,
      shuffle: shuffle ?? this.shuffle,
      repeatMode: repeatMode ?? this.repeatMode,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}