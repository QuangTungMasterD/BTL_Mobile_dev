import 'package:btl_music_app/features/comment/bloc/comment_bloc.dart';
import 'package:btl_music_app/features/comment/bloc/comment_event.dart';
import 'package:btl_music_app/features/comment/bloc/comment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/features/comment/data/models/comment_model.dart';
import 'package:btl_music_app/features/comment/presentation/widgets/comment_item.dart';

class CommentList extends StatelessWidget {
  const CommentList({super.key});

  Future<void> _confirmDelete(BuildContext context, String commentId) async {
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
      context.read<CommentBloc>().add(DeleteComment(commentId));
    }
  }

  List<Widget> _buildCommentTree(
    CommentModel node,
    Map<String, List<CommentModel>> childrenMap,
    BuildContext context,
    String? replyToName,
  ) {
    final children = childrenMap[node.id] ?? [];
    List<Widget> childWidgets = [];
    for (var child in children) {
      childWidgets.addAll(_buildCommentTree(child, childrenMap, context, node.userName));
    }

    bool hasVisibleChildren = childWidgets.isNotEmpty;

    if (node.isDeleted && !hasVisibleChildren) {
      return [];
    }

    return [
      Padding(
        padding: EdgeInsets.only(left: node.parentId == null ? 0 : 40),
        child: CommentItem(
          comment: node,
          currentUserId: context.read<CommentBloc>().state.currentUserId,
          onLike: () => context.read<CommentBloc>().add(ToggleLike(node.id)),
          onDelete: node.userId == context.read<CommentBloc>().state.currentUserId
              ? () => _confirmDelete(context, node.id)
              : null,
          onReply: () => context.read<CommentBloc>().add(SetReplyingTo(node)),
          replyToName: replyToName,
        ),
      ),
      ...childWidgets,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.error != null) {
          return Center(child: Text('Lỗi: ${state.error}'));
        }
        final comments = state.comments;
        if (comments.isEmpty) {
          return const Center(child: Text('Chưa có bình luận nào'));
        }

        final Map<String, List<CommentModel>> childrenMap = {};
        final List<CommentModel> roots = [];

        for (var c in comments) {
          if (c.parentId == null) {
            roots.add(c);
          } else {
            childrenMap.putIfAbsent(c.parentId!, () => []).add(c);
          }
        }

        List<Widget> treeWidgets = [];
        for (var root in roots) {
          treeWidgets.addAll(_buildCommentTree(root, childrenMap, context, null));
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