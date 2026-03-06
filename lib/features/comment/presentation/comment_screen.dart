// features/comment/presentation/comment_sheet.dart
import 'package:btl_music_app/core/providers/comment_provider.dart';
import 'package:btl_music_app/core/providers/user_provider.dart';
import 'package:btl_music_app/features/comment/data/repo/comment_repo.dart';
import 'package:btl_music_app/features/comment/presentation/widgets/comment_input.dart';
import 'package:btl_music_app/features/comment/presentation/widgets/comment_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentSheet extends StatelessWidget {
  final String songId;
  final String? currentUserId;

  const CommentSheet({super.key, required this.songId, this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    return ChangeNotifierProvider(
      create: (_) => CommentProvider(
        context.read<CommentRepository>(),
        songId,
        currentUserId,
        userProvider,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, // Thay vì Colors.black
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor, // Hoặc màu phù hợp
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Bình luận",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            Divider(color: Theme.of(context).dividerColor),
            const Expanded(child: CommentList()),
            const CommentInput(),
          ],
        ),
      ),
    );
  }
}