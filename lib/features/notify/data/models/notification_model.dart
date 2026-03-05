// features/notification/data/models/notification_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? targetUser;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.targetUser,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> data, String id) {
    return NotificationModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      targetUser: data['targetUser'], // có thể null
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'targetUser': targetUser,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}