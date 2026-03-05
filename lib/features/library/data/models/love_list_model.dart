
import 'package:cloud_firestore/cloud_firestore.dart';

class LoveListModel {
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> songIds;

  LoveListModel({
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.songIds,
  });

  factory LoveListModel.fromJson(Map<String, dynamic> data, String userId) {
    return LoveListModel(
      userId: userId,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      songIds: List<String>.from(data['songIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'songIds': songIds,
    };
  }

  LoveListModel copyWith({
    DateTime? updatedAt,
    List<String>? songIds,
  }) {
    return LoveListModel(
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      songIds: songIds ?? this.songIds,
    );
  }
}