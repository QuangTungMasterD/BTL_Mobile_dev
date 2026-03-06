// features/comment/data/repos/comment_repo.dart
import 'package:btl_music_app/features/comment/data/models/comment_model.dart';
import 'package:btl_music_app/features/comment/data/services/comment_service.dart';

class CommentRepository {
  final CommentService _service;

  CommentRepository(this._service);

  Stream<List<CommentModel>> getCommentsStream(String songId, {int limit = 20}) =>
      _service.getCommentsStream(songId, limit: limit);

  Future<void> addComment(CommentModel comment) => _service.addComment(comment);

  Future<void> updateComment(String songId, String commentId, Map<String, dynamic> data) =>
      _service.updateComment(songId, commentId, data);

  Future<void> deleteComment(String songId, String commentId) =>
      _service.deleteComment(songId, commentId);

  Future<void> toggleLike(String songId, String commentId, String userId) =>
      _service.toggleLike(songId, commentId, userId);

  Future<void> softDeleteComment(String songId, String commentId) =>
      _service.softDeleteComment(songId, commentId);
}