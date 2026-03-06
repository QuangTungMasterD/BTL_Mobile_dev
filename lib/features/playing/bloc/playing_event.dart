abstract class PlayingEvent {}

class ChangePage extends PlayingEvent {
  final int pageIndex;
  ChangePage(this.pageIndex);
}
