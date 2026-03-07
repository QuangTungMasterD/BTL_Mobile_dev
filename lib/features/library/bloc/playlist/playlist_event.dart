abstract class PlaylistEvent {}

class LoadPlaylists extends PlaylistEvent {
  final String userId;
  LoadPlaylists(this.userId);
}

class CreatePlaylist extends PlaylistEvent {
  final String userId;
  final String name;
  final String? coverUrl;
  CreatePlaylist(this.userId, this.name, this.coverUrl);
}

class DeletePlaylist extends PlaylistEvent {
  final String userId;
  final String playlistId;
  DeletePlaylist(this.userId, this.playlistId);
}
