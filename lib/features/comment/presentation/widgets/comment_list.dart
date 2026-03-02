import 'package:btl_music_app/features/comment/presentation/widgets/comment_item.dart';
import 'package:flutter/material.dart';

class CommentList extends StatelessWidget {
  const CommentList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 20,
      itemBuilder: (context, index) {
        return const CommentItem();
      },
    );
  }
}