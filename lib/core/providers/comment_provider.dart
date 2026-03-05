
import 'dart:async';
import 'package:btl_music_app/features/comment/data/repo/comment_repo.dart';
import 'package:flutter/material.dart';
import 'package:btl_music_app/features/comment/data/models/comment_model.dart';

class CommentProvider extends ChangeNotifier {
  final CommentRepository _repo;
  final String songId;
  final String? currentUserId; // ID người dùng hiện tại (từ Auth)

  List<CommentModel> _comments = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _subscription;

  List<CommentModel> get comments => _comments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  CommentProvider(this._repo, this.songId, this.currentUserId) {
    _loadComments();
  }

  void _loadComments() {
    _subscription?.cancel();
    _isLoading = true;
    notifyListeners();

    _subscription = _repo.getCommentsStream(songId).listen(
      (comments) {
        _comments = comments;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Thêm comment
  Future<void> addComment(String content, {String? parentId}) async {
    if (currentUserId == null) return;
    final newComment = CommentModel(
      id: '', // sẽ được tạo tự động
      songId: songId,
      userId: currentUserId!,
      userName: 'User Name', // TODO: lấy từ UserProvider
      userAvatar: null,
      content: content,
      createdAt: DateTime.now(),
      parentId: parentId,
    );
    await _repo.addComment(newComment);
  }

  // Xóa comment
  Future<void> deleteComment(String commentId) async {
    await _repo.deleteComment(songId, commentId);
  }

  // Thích / bỏ thích
  Future<void> toggleLike(String commentId) async {
    if (currentUserId == null) return;
    await _repo.toggleLike(songId, commentId, currentUserId!);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}