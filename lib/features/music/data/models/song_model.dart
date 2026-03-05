import 'package:btl_music_app/features/music/data/models/lyric_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SongModel {
  final String id; // ID document trên Firestore (hoặc tự sinh)
  final String title;
  final String artist;
  final String? album;
  final String artistId; // ID tham chiếu đến artists
  final String? albumId; // ID tham chiếu đến albums
  final String youtubeId; // ID video YouTube để stream
  final String? thumbnailUrl; // Ảnh bìa
  final int duration; // Thời lượng (giây)
  final String? genre; // Thể loại (Pop, Ballad...)
  // final String? mood;           // Cảm xúc (Sad, Chill...)
  final List<LyricLine>? lyrics; // Lời bài hát có thời gian
  final int playCount; // Số lượt nghe
  final int likeCount; // Số lượt yêu thích

  SongModel({
    required this.id,
    required this.title,
    required this.artist,
    this.album,
    required this.artistId,
    this.albumId,
    required this.youtubeId,
    this.thumbnailUrl,
    this.duration = 0,
    this.genre,
    // this.mood,
    this.lyrics,
    this.playCount = 0,
    this.likeCount = 0,
  });

  // Từ JSON (Firestore hoặc API)
  factory SongModel.fromJson(Map<String, dynamic> json, String? id) {
    List<LyricLine>? lyricsList;
    if (json['lyrics'] != null) {
      lyricsList = (json['lyrics'] as List<dynamic>)
          .map((line) => LyricLine.fromJson(line as Map<String, dynamic>))
          .toList();
    }

    return SongModel(
      id: id ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Unknown Title',
      artist: json['artist'] as String? ?? 'Unknown Artist',
      album: json['album'] as String?,
      artistId: json['artistId'] as String,
      albumId: json['albumId'] as String?,
      youtubeId: json['youtubeId'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String?,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      genre: json['genre'] as String?,
      // // mood: json['mood'] as String?,
      lyrics: lyricsList,
      playCount: (json['playCount'] as num?)?.toInt() ?? 0,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
    );
  }

  // Chuyển thành JSON để lưu lên Firestore
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'album': album,
      'artistId': artistId,
      'albumId': albumId,
      'youtubeId': youtubeId,
      'thumbnailUrl': thumbnailUrl,
      'duration': duration,
      'genre': genre,
      // // 'mood': mood,
      'lyrics': lyrics?.map((line) => line.toJson()).toList(),
      'playCount': playCount,
      'likeCount': likeCount,
      // Không cần lưu id vào JSON (Firestore tự quản lý)
    };
  }

  // Getter tiện lợi
  String get displayTitle => title;
  String get displayArtist => artist;
  String get thumbnail =>
    thumbnailUrl != "" ? '$thumbnailUrl' : 'https://i.ytimg.com/vi/$youtubeId/maxresdefault.jpg';
}
