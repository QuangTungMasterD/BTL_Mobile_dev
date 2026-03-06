abstract class TopEvent {}

class LoadTopSongs extends TopEvent {
  final int limit;
  LoadTopSongs({this.limit = 99});
}
