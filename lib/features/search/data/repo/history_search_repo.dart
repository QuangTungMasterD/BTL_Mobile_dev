
import 'package:btl_music_app/features/search/data/services/history_search_service.dart';

class SearchHistoryRepository {
  final SearchHistoryService _service = SearchHistoryService();

  Future<List<String>> getRecentSearches({int limit = 10}) => _service.getRecentSearches(limit);

  Future<void> addSearchQuery(String query) => _service.addSearchQuery(query);
}