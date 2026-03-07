import 'package:btl_music_app/features/comment/data/models/comment_model.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  final CommentModel comment;
  final String? currentUserId;
  final VoidCallback onLike;
  final VoidCallback? onDelete;
  final VoidCallback onReply;
  final String? replyToName;

  const CommentItem({
    super.key,
    required this.comment,
    required this.currentUserId,
    required this.onLike,
    this.onDelete,
    required this.onReply,
    this.replyToName,
  });

  @override
  Widget build(BuildContext context) {
    final isLiked = currentUserId != null && comment.likedBy.contains(currentUserId);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Nếu comment đã xóa
    if (comment.isDeleted) {
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
              child: comment.userAvatar == null ? Icon(Icons.person, color: colorScheme.onSurface) : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bình luận đã xóa',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Bình thường
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundImage: comment.userAvatar != null
                ? NetworkImage(comment.userAvatar!)
                : null,
            child: comment.userAvatar == null ? Icon(Icons.person, color: colorScheme.onSurface) : null,
          ),
          const SizedBox(width: 10),
          // Phần nội dung bên phải
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hàng 1: Tên và thời gian
                Row(
                  children: [
                    Text(
                      comment.userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(comment.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Hàng 2: Nội dung comment (có thể có tag)
                replyToName != null
                    ? RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '@$replyToName ',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: comment.content,
                              style: TextStyle(color: colorScheme.onSurface),
                            ),
                          ],
                        ),
                      )
                    : Text(
                        comment.content,
                        style: TextStyle(color: colorScheme.onSurface),
                      ),
                const SizedBox(height: 8),
                // Hàng 3: Các nút hành động
                Wrap(
                  spacing: 4,
                  children: [
                    InkWell(
                      onTap: onReply,
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          'Trả lời',
                          style: TextStyle(color: colorScheme.primary, fontSize: 12),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: onLike,
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.5),
                          size: 14,
                        ),
                      ),
                    ),
                    if (onDelete != null)
                      InkWell(
                        onTap: onDelete,
                        borderRadius: BorderRadius.circular(4),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.delete,
                            color: colorScheme.onSurface.withOpacity(0.5),
                            size: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
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