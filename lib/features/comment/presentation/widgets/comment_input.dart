// features/comment/presentation/widgets/comment_input.dart
import 'package:btl_music_app/core/providers/comment_provider.dart';
import 'package:btl_music_app/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentInput extends StatefulWidget {
  const CommentInput({super.key});

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentProvider = context.watch<CommentProvider>();
    final userProvider = context.watch<UserProvider>();
    final replyingTo = commentProvider.replyingTo;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Lấy avatar của user hiện tại
    final currentUserAvatar = userProvider.user?.avatar;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // decoration: const BoxDecoration(
      //   border: Border(top: BorderSide(color: Colors.white12)),
      // ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Thanh hiển thị đang reply (nếu có)
          if (replyingTo != null)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.reply, color: colorScheme.primary, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Đang trả lời @${replyingTo.userName}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => commentProvider.setReplyingTo(null),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: currentUserAvatar != null
                    ? NetworkImage(currentUserAvatar)
                    : null,
                child: currentUserAvatar == null ? const Icon(Icons.person, size: 16) : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: replyingTo == null ? "Viết bình luận..." : "Nhập nội dung...",
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _sendComment(commentProvider),
                ),
              ),
              if (_isSending)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                IconButton(
                  icon: Icon(Icons.send, color: colorScheme.primary),
                  onPressed: () => _sendComment(commentProvider),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _sendComment(CommentProvider provider) async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;
    setState(() => _isSending = true);
    try {
      await provider.addComment(content, parentId: provider.replyingTo?.id);
      _controller.clear();
      if (provider.replyingTo != null) {
        provider.setReplyingTo(null);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }
}