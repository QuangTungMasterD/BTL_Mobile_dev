class Song {
  final String title;
  final String artist;
  final String? imageUrl;
  final bool isHQ;
  final bool isDownloaded;
  final bool isLiked;

  Song({
    required this.title,
    required this.artist,
    this.imageUrl,
    this.isHQ = false,
    this.isDownloaded = false,
    this.isLiked = false,
  });
}