// core/providers/comment_provider.dart
import 'dart:async';
import 'package:btl_music_app/features/comment/data/repo/comment_repo.dart';
import 'package:flutter/material.dart';
import 'package:btl_music_app/features/comment/data/models/comment_model.dart';
import 'package:btl_music_app/core/providers/user_provider.dart'; // Giả sử có UserProvider

class CommentProvider extends ChangeNotifier {
  final CommentRepository _repo;
  final String songId;
  final String? currentUserId;
  final UserProvider _userProvider; // Thêm để lấy thông tin user hiện tại

  List<CommentModel> _comments = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _subscription;
  CommentModel? _replyingTo; // Comment đang được reply

  List<CommentModel> get comments => _comments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  CommentModel? get replyingTo => _replyingTo;

  CommentProvider(this._repo, this.songId, this.currentUserId, this._userProvider) {
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

  // Thêm comment mới (có thể là reply nếu parentId != null)
  Future<void> addComment(String content, {String? parentId}) async {
    if (currentUserId == null) return;
    final user = _userProvider.user;
    final newComment = CommentModel(
      id: '',
      songId: songId,
      userId: currentUserId!,
      userName: user?.displayName ?? 'Người dùng',
      userAvatar: user?.avatar,
      content: content,
      createdAt: DateTime.now(),
      parentId: parentId,
    );
    await _repo.addComment(newComment);
  }

  // Xóa comment
  Future<void> deleteComment(String commentId) async {
    await _repo.softDeleteComment(songId, commentId);
  }

  // Thích/bỏ thích
  Future<void> toggleLike(String commentId) async {
    if (currentUserId == null) return;
    await _repo.toggleLike(songId, commentId, currentUserId!);
  }

  // Đặt trạng thái đang reply
  void setReplyingTo(CommentModel? comment) {
    _replyingTo = comment;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}