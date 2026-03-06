abstract class SearchEvent {}

class SearchSongs extends SearchEvent {
  final String query;
  SearchSongs(this.query);
}

class SearchArtists extends SearchEvent {
  final String query;
  SearchArtists(this.query);
}

class ClearSearch extends SearchEvent {}