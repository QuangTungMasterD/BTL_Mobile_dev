import 'package:btl_music_app/features/comment/bloc/comment_bloc.dart';
import 'package:btl_music_app/features/comment/bloc/comment_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/core/providers/user_provider.dart';
import 'package:btl_music_app/features/comment/data/repo/comment_repo.dart';
import 'package:btl_music_app/features/comment/presentation/widgets/comment_input.dart';
import 'package:btl_music_app/features/comment/presentation/widgets/comment_list.dart';

class CommentSheet extends StatelessWidget {
  final String songId;

  const CommentSheet({super.key, required this.songId});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();

    return BlocProvider(
      create: (context) => CommentBloc(
        repository: context.read<CommentRepository>(),
        userProvider: userProvider,
        songId: songId,
      )..add(LoadComments(songId)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Bình luận",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
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