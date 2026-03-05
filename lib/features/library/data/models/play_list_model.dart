import 'package:cloud_firestore/cloud_firestore.dart';

class PlayListModel {
  final String id;
  final String name;
  final String? coverUrl;
  final String userId;           // Chủ sở hữu playlist
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> songIds;

  PlayListModel({
    required this.id,
    required this.name,
    this.coverUrl,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.songIds,
  });

  factory PlayListModel.fromJson(Map<String, dynamic> data, String id) {
    return PlayListModel(
      id: id,
      name: data['name'] ?? 'Untitled Playlist',
      coverUrl: data['coverUrl'] ?? 'https://www.techhive.com/wp-content/uploads/2023/04/recordalbum2-100616490-orig-1.jpg?quality=50&strip=all&w=1024',
      userId: data['userId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      songIds: List<String>.from(data['songIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'coverUrl': coverUrl ?? 'https://www.techhive.com/wp-content/uploads/2023/04/recordalbum2-100616490-orig-1.jpg?quality=50&strip=all&w=1024',
      'userId': userId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'songIds': songIds,
    };
  }

  PlayListModel copyWith({
    String? name,
    String? coverUrl,
    List<String>? songIds,
    bool? isPublic,
  }) {
    return PlayListModel(
      id: id,
      name: name ?? this.name,
      coverUrl: coverUrl ?? this.coverUrl,
      userId: userId,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      songIds: songIds ?? this.songIds,
    );
  }

}