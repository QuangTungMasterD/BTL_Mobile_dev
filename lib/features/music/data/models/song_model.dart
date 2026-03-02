class SongModel {
  final String id;              // ID document trên Firestore
  final String title;
  final String artist;
  final String? album;
  final String youtubeId;       // ID video YouTube
  final String? thumbnailUrl;   // Ảnh bìa (từ YouTube)
  final int duration;           // Thời lượng (giây) – optional, lấy từ YouTube nếu cần

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    required this.youtubeId,
    this.thumbnailUrl,
    this.duration = 0,
  });

  // Từ Firestore document
  factory SongModel.fromFirestore(Map<String, dynamic> data, String id) {
    return SongModel(
      id: id,
      title: data['title'] ?? 'Unknown Title',
      artist: data['artist'] ?? 'Unknown Artist',
      album: data['album'],
      youtubeId: data['youtubeId'] ?? '',
      thumbnailUrl: data['thumbnailUrl'],
      duration: data['duration'] ?? 0,
    );
  }

  // Để lưu lên Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
      'album': album,
      'youtubeId': youtubeId,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  // Để hiển thị trong UI
  String get displayTitle => title;
  String get displayArtist => artist;
  String get thumbnail => thumbnailUrl ?? 'https://i.ytimg.com/vi/$youtubeId/maxresdefault.jpg';
}