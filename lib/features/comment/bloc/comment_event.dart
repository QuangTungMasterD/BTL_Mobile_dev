import 'package:btl_music_app/features/comment/data/models/comment_model.dart';

abstract class CommentEvent {}

class LoadComments extends CommentEvent {
  final String songId;
  LoadComments(this.songId);
}

class CommentsUpdated extends CommentEvent {
  final List<CommentModel> comments;
  CommentsUpdated(this.comments);
}

class AddComment extends CommentEvent {
  final String content;
  final String? parentId;
  AddComment(this.content, this.parentId);
}

class DeleteComment extends CommentEvent {
  final String commentId;
  DeleteComment(this.commentId);
}

class ToggleLike extends CommentEvent {
  final String commentId;
  ToggleLike(this.commentId);
}

class SetReplyingTo extends CommentEvent {
  final CommentModel? comment;
  SetReplyingTo(this.comment);
}