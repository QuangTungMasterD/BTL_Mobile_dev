abstract class ArtistSongsEvent {}

class LoadArtistSongs extends ArtistSongsEvent {
  final String artistId;
  LoadArtistSongs(this.artistId);
}
