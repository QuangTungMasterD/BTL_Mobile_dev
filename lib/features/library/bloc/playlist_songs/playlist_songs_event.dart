abstract class PlaylistSongsEvent {}

class LoadPlaySongslist extends PlaylistSongsEvent {
  final String playlistId;
  LoadPlaySongslist(this.playlistId);
}