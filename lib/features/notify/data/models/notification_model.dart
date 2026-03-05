import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String type;  // "like", "follow", "new_song", "comment", "playlist_share", "system"
  final String title;
  final String body;
  final String? imageUrl;  // Avatar người gửi hoặc thumbnail bài hát
  final String? senderId;  // UID người gửi (null nếu hệ thống)
  final String? senderName;  // Tên người gửi
  final String? targetId;  // ID bài hát/artists/playlist bị tương tác
  final String? targetType;  // "song", "artist", "playlist"
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.imageUrl,
    this.senderId,
    this.senderName,
    this.targetId,
    this.targetType,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> data, String id) {
    return NotificationModel(
      id: id,
      type: data['type'] as String? ?? 'system',
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      imageUrl: data['imageUrl'] as String?,
      senderId: data['senderId'] as String?,
      senderName: data['senderName'] as String?,
      targetId: data['targetId'] as String?,
      targetType: data['targetType'] as String?,
      isRead: data['isRead'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'senderId': senderId,
      'senderName': senderName,
      'targetId': targetId,
      'targetType': targetType,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  NotificationModel copyWith({
    bool? isRead,
  }) {
    return NotificationModel(
      id: id,
      type: type,
      title: title,
      body: body,
      imageUrl: imageUrl,
      senderId: senderId,
      senderName: senderName,
      targetId: targetId,
      targetType: targetType,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}