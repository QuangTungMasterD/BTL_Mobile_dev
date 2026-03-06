abstract class SearchLandingEvent {}

class LoadHistory extends SearchLandingEvent {}

class AddSearchQuery extends SearchLandingEvent {
  final String query;
  AddSearchQuery(this.query);
}
