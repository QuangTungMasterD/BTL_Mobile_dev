import 'package:btl_music_app/features/library/bloc/playlist_songs/playlist_songs_bloc.dart';
import 'package:btl_music_app/features/library/bloc/playlist_songs/playlist_songs_event.dart';
import 'package:btl_music_app/features/library/bloc/playlist_songs/playlist_songs_state.dart';
import 'package:btl_music_app/features/library/data/repo/play_list_repo.dart';
import 'package:btl_music_app/features/music/data/repo/song_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/features/library/presentation/widgets/seach_playlist_layout.dart';
import 'package:btl_music_app/core/widgets/bottom.dart';
import 'package:btl_music_app/core/widgets/mini_player.dart';

class SongListScreen extends StatelessWidget {
  final String playlistId;
  final String title;

  const SongListScreen({super.key, required this.playlistId, required this.title});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaylistSongsBloc(
        playlistRepo: context.read<PlayListRepository>(),
        songRepo: context.read<SongRepository>(),
      )..add(LoadPlaySongslist(playlistId)),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<PlaylistSongsBloc, PlaylistSongsState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.error != null) {
                return Center(child: Text('Lỗi: ${state.error}'));
              }
              return SearchableSongList(
                songs: state.songs,
                title: state.playlistName ?? title,
                // onSongTap: (song) {
                //   // Xử lý phát nhạc
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