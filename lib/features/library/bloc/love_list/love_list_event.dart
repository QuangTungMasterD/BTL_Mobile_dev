abstract class LoveListEvent {}

class LoadLoveList extends LoveListEvent {
  final String userId;
  LoadLoveList(this.userId);
}
