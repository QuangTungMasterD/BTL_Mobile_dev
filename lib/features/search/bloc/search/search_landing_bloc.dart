import 'package:btl_music_app/features/search/bloc/search/search_landing_event.dart';
import 'package:btl_music_app/features/search/bloc/search/search_landing_state.dart';
import 'package:btl_music_app/features/search/data/repo/history_search_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchLandingBloc extends Bloc<SearchLandingEvent, SearchLandingState> {
  final SearchHistoryRepository _repo;

  SearchLandingBloc({required SearchHistoryRepository repo})
      : _repo = repo,
        super(SearchLandingState.initial()) {
    on<LoadHistory>(_onLoadHistory);
    on<AddSearchQuery>(_onAddSearchQuery);
  }

  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<SearchLandingState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final history = await _repo.getRecentSearches();
      emit(state.copyWith(history: history, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onAddSearchQuery(
    AddSearchQuery event,
    Emitter<SearchLandingState> emit,
  ) async {
    // Lưu query
    await _repo.addSearchQuery(event.query);
    // Sau khi lưu, load lại lịch sử mới
    add(LoadHistory()); // gọi lại event load
  }
}