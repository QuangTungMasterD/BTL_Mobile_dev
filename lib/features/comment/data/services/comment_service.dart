// features/comment/data/services/comment_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:btl_music_app/features/comment/data/models/comment_model.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _commentsRef(String songId) =>
      _firestore.collection('songs').doc(songId).collection('comments');

  // Lấy comments theo bài hát (có phân trang)
  Stream<List<CommentModel>> getCommentsStream(String songId, {int limit = 20}) {
    return _commentsRef(songId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CommentModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Thêm comment mới
  Future<void> addComment(CommentModel comment) async {
    await _commentsRef(comment.songId).add(comment.toJson());
  }

  // Sửa comment
  Future<void> updateComment(String songId, String commentId, Map<String, dynamic> data) async {
    await _commentsRef(songId).doc(commentId).update(data);
  }

  // Xóa comment
  Future<void> deleteComment(String songId, String commentId) async {
    await _commentsRef(songId).doc(commentId).delete();
  }

  // Thích / bỏ thích comment
  Future<void> toggleLike(String songId, String commentId, String userId) async {
    final docRef = _commentsRef(songId).doc(commentId);
    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(docRef);
      if (!doc.exists) return;
      final likedBy = List<String>.from(doc['likedBy'] ?? []);
      if (likedBy.contains(userId)) {
        likedBy.remove(userId);
      } else {
        likedBy.add(userId);
      }
      transaction.update(docRef, {
        'likedBy': likedBy,
        'likeCount': likedBy.length,
      });
    });
  }

  Future<void> softDeleteComment(String songId, String commentId) async {
  await _commentsRef(songId).doc(commentId).update({
    'isDeleted': true,
  });
}
}