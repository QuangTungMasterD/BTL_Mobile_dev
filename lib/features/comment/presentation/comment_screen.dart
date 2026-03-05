// features/comment/presentation/comment_sheet.dart
import 'package:btl_music_app/core/providers/comment_provider.dart';
import 'package:btl_music_app/features/comment/data/repo/comment_repo.dart';
import 'package:btl_music_app/features/comment/presentation/widgets/comment_input.dart';
import 'package:btl_music_app/features/comment/presentation/widgets/comment_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentSheet extends StatelessWidget {
  final String songId;
  final String? currentUserId; // có thể lấy từ Auth

  const CommentSheet({
    super.key,
    required this.songId,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CommentProvider(
        context.read<CommentRepository>(),
        songId,
        currentUserId,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Bình luận",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Divider(color: Colors.white12),
            const Expanded(child: CommentList()),
            const CommentInput(),
          ],
        ),
      ),
    );
  }
}