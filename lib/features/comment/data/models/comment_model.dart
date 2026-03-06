// features/comment/data/models/comment_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String songId;      // ID bài hát
  final String userId;      // ID người bình luận
  final String userName;    // Tên người dùng (có thể lấy từ UserModel)
  final String? userAvatar; // Avatar người dùng
  final String content;     // Nội dung
  final DateTime createdAt;
  final int likeCount;      // Số lượt thích
  final List<String> likedBy; // Danh sách user id đã thích
  final String? parentId;   // null nếu là comment gốc, nếu không là reply
  final bool isDeleted;

  CommentModel({
    required this.id,
    required this.songId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.content,
    required this.createdAt,
    this.likeCount = 0,
    this.likedBy = const [],
    this.parentId,
    this.isDeleted = false,
  });

  factory CommentModel.fromJson(Map<String, dynamic> data, String id) {
    return CommentModel(
      id: id,
      songId: data['songId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userAvatar: data['userAvatar'],
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      likeCount: (data['likeCount'] as num?)?.toInt() ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      parentId: data['parentId'],
      isDeleted: data['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'songId': songId,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'likeCount': likeCount,
      'likedBy': likedBy,
      'parentId': parentId,
      'isDeleted': isDeleted,
    };
  }

  CommentModel copyWith({
    int? likeCount,
    List<String>? likedBy,
  }) {
    return CommentModel(
      id: id,
      songId: songId,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      content: content,
      createdAt: createdAt,
      likeCount: likeCount ?? this.likeCount,
      likedBy: likedBy ?? this.likedBy,
      parentId: parentId,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}