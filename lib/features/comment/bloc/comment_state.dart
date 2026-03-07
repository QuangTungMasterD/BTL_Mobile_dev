import 'package:btl_music_app/features/comment/data/models/comment_model.dart';

class CommentState {
  final List<CommentModel> comments;
  final bool isLoading;
  final String? error;
  final CommentModel? replyingTo;
  final String? currentUserId;

  CommentState({
    this.comments = const [],
    this.isLoading = false,
    this.error,
    this.replyingTo,
    this.currentUserId,
  });

  CommentState copyWith({
    List<CommentModel>? comments,
    bool? isLoading,
    String? error,
    CommentModel? replyingTo,
    String? currentUserId,
  }) {
    return CommentState(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      replyingTo: replyingTo ?? this.replyingTo,
      currentUserId: currentUserId ?? this.currentUserId,
    );
  }
}
