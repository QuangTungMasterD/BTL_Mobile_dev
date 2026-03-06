import 'package:btl_music_app/core/providers/comment_provider.dart';
import 'package:btl_music_app/features/comment/data/models/comment_model.dart';
import 'package:btl_music_app/features/comment/presentation/widgets/comment_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentList extends StatelessWidget {
  const CommentList({super.key});

  Future<void> _confirmDelete(BuildContext context, CommentProvider provider, String commentId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa bình luận'),
        content: const Text('Bạn có chắc muốn xóa bình luận này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (shouldDelete == true) {
      await provider.deleteComment(commentId);
    }
  }

  // Hàm đệ quy để xây dựng cây comment và chỉ hiển thị những node hợp lệ
  List<Widget> _buildCommentTree(
    CommentModel node,
    Map<String, List<CommentModel>> childrenMap,
    CommentProvider provider,
    BuildContext context,
    String? replyToName,
  ) {
    final children = childrenMap[node.id] ?? [];

    // Xử lý children trước để biết có nên hiển thị node không
    List<Widget> childWidgets = [];
    for (var child in children) {
      childWidgets.addAll(_buildCommentTree(child, childrenMap, provider, context, node.userName));
    }

    bool hasVisibleChildren = childWidgets.isNotEmpty;

    // Quyết định hiển thị node này không?
    if (node.isDeleted && !hasVisibleChildren) {
      // Nếu node đã xóa và không có con hiển thị, thì không hiển thị node này
      return [];
    }

    // Nếu node hiển thị, tạo widget cho nó và kèm theo children
    return [
      Padding(
        padding: EdgeInsets.only(left: node.parentId == null ? 0 : 40),
        child: CommentItem(
          comment: node,
          currentUserId: provider.currentUserId,
          onLike: () => provider.toggleLike(node.id),
          onDelete: node.userId == provider.currentUserId
              ? () => _confirmDelete(context, provider, node.id)
              : null,
          onReply: () => provider.setReplyingTo(node),
          replyToName: replyToName,
        ),
      ),
      ...childWidgets,
    ];
  }

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

        // Xây dựng map children
        final Map<String, List<CommentModel>> childrenMap = {};
        final List<CommentModel> roots = [];

        for (var c in comments) {
          if (c.parentId == null) {
            roots.add(c);
          } else {
            childrenMap.putIfAbsent(c.parentId!, () => []).add(c);
          }
        }

        // Xây dựng cây và lấy danh sách widget
        List<Widget> treeWidgets = [];
        for (var root in roots) {
          treeWidgets.addAll(_buildCommentTree(root, childrenMap, provider, context, null));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: treeWidgets.length,
          itemBuilder: (context, index) => treeWidgets[index],
        );
      },
    );
  }
}