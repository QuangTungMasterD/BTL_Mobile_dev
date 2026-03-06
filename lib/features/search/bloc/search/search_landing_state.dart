class SearchLandingState {
  final List<String> history;
  final bool isLoading;
  final String? error;

  SearchLandingState({
    required this.history,
    this.isLoading = false,
    this.error,
  });

  factory SearchLandingState.initial() {
    return SearchLandingState(history: []);
  }

  SearchLandingState copyWith({
    List<String>? history,
    bool? isLoading,
    String? error,
  }) {
    return SearchLandingState(
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
