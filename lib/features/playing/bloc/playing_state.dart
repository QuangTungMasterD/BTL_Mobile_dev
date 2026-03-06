class PlayingState {
  final int currentPage;
  PlayingState({required this.currentPage});

  factory PlayingState.initial() => PlayingState(currentPage: 0);

  PlayingState copyWith({int? currentPage}) {
    return PlayingState(currentPage: currentPage ?? this.currentPage);
  }
}
