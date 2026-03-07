import 'package:btl_music_app/features/library/data/repo/love_list_repo.dart';
import 'package:btl_music_app/features/music/data/repo/song_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/core/providers/auth_provider.dart';
import 'package:btl_music_app/features/library/bloc/love_list/love_list_bloc.dart';
import 'package:btl_music_app/features/library/bloc/love_list/love_list_event.dart';
import 'package:btl_music_app/features/library/bloc/love_list/love_list_state.dart';
import 'package:btl_music_app/features/library/presentation/widgets/seach_playlist_layout.dart';
import 'package:btl_music_app/core/widgets/bottom.dart';
import 'package:btl_music_app/core/widgets/mini_player.dart';

class LoveListScreen extends StatelessWidget {
  const LoveListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthUserProvider>();
    final userId = authProvider.user?.uid ?? '';

    return BlocProvider(
      create: (context) => LoveListBloc(
        loveRepo: context.read<LoveListRepository>(),
        songRepo: context.read<SongRepository>(),
      )..add(LoadLoveList(userId)),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<LoveListBloc, LoveListState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.error != null) {
                return Center(child: Text('Lỗi: ${state.error}'));
              }
              return SearchableSongList(
                songs: state.songs,
                title: "Yêu thích",
                onSongTap: (song) {
                  // Xử lý phát nhạc
                },
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [MiniPlayer(), AppBottomNav(currentIndex: 0)],
        ),
      ),
    );
  }
}