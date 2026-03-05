// features/comment/presentation/widgets/comment_list.dart
import 'package:btl_music_app/core/providers/comment_provider.dart';
import 'package:btl_music_app/features/comment/presentation/widgets/comment_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentList extends StatelessWidget {
  const CommentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.error != null) {
          return Center(child: Text('Lỗi: ${provider.error}'));
        }
        final comments = provider.comments;
        if (comments.isEmpty) {
          return const Center(child: Text('Chưa có bình luận nào'));
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            final comment = comments[index];
            return CommentItem(
              comment: comment,
              onLike: () => provider.toggleLike(comment.id),
              onDelete: comment.userId == provider.currentUserId
                  ? () => provider.deleteComment(comment.id)
                  : null,
            );
          },
        );
      },
    );
  }
}