import 'package:btl_music_app/features/library/bloc/download_list/download_list_bloc.dart';
import 'package:btl_music_app/features/library/bloc/download_list/download_list_event.dart';
import 'package:btl_music_app/features/library/bloc/download_list/download_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/features/library/presentation/widgets/seach_playlist_layout.dart';
import 'package:btl_music_app/core/widgets/bottom.dart';
import 'package:btl_music_app/core/widgets/mini_player.dart';

class DownloadedSongsScreen extends StatelessWidget {
  const DownloadedSongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DownloadedBloc()..add(LoadDownloaded()),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<DownloadedBloc, DownloadedState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.error != null) {
                return Center(child: Text('Lỗi: ${state.error}'));
              }
              return SearchableSongList(
                songs: state.songs,
                title: "Đã tải về",
                // onSongTap: (song) {
                //   // Xử lý phát nhạc offline
                // },
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