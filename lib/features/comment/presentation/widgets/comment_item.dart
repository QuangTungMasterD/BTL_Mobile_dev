// features/comment/presentation/widgets/comment_item.dart
import 'package:btl_music_app/features/comment/data/models/comment_model.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  final CommentModel comment;
  final VoidCallback onLike;
  final VoidCallback? onDelete;

  const CommentItem({
    super.key,
    required this.comment,
    required this.onLike,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isLiked = comment.likedBy.contains(comment.userId); // cần userId hiện tại

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: comment.userAvatar != null
                ? NetworkImage(comment.userAvatar!)
                : null,
            child: comment.userAvatar == null ? const Icon(Icons.person) : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(comment.createdAt),
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.content,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.purple : Colors.white54,
                  size: 18,
                ),
                onPressed: onLike,
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white54, size: 18),
                  onPressed: onDelete,
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inDays > 0) return '${diff.inDays} ngày';
    if (diff.inHours > 0) return '${diff.inHours} giờ';
    if (diff.inMinutes > 0) return '${diff.inMinutes} phút';
    return 'Vừa xong';
  }
}