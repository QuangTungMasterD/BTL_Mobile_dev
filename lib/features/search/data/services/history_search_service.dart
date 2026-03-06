
import 'package:btl_music_app/core/database/database_helper.dart';

class SearchHistoryService {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<String>> getRecentSearches(int limit) async {
    return _dbHelper.getRecentSearches(limit: limit);
  }

  Future<void> addSearchQuery(String query) async {
    await _dbHelper.addSearchQuery(query);
  }
}