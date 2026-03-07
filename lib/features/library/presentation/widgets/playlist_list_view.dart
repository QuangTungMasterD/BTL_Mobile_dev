import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/features/library/bloc/playlist/playlist_bloc.dart';
import 'package:btl_music_app/features/library/bloc/playlist/playlist_event.dart';
import 'package:btl_music_app/features/library/data/models/play_list_model.dart';
import 'package:btl_music_app/features/library/presentation/widgets/library_item.dart';
import 'package:btl_music_app/features/library/presentation/love_list_screen.dart';
import 'package:btl_music_app/features/library/presentation/download_list_screen.dart';
import 'package:btl_music_app/features/library/presentation/song_list_screen.dart';

class PlaylistListView extends StatelessWidget {
  final List<PlayListModel> playlists;
  final PlaylistBloc bloc;
  final String userId;
  final VoidCallback onCreatePlaylist;

  const PlaylistListView({
    super.key,
    required this.playlists,
    required this.bloc,
    required this.userId,
    required this.onCreatePlaylist,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        LibraryItem(
          title: "Bài hát đã thích",
          showOptions: false,
          isLiked: true,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoveListScreen()),
            );
          },
        ),
        LibraryItem(
          title: "Bài hát đã tải",
          isDownload: true,
          showOptions: false,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DownloadedSongsScreen()),
            );
          },
        ),
        ...playlists.map((playlist) {
          return LibraryItem(
            title: playlist.name,
            subtitle: "Danh sách phát • ${playlist.songIds.length} bài hát",
            coverUrl: playlist.coverUrl,
            onDelete: () {
              bloc.add(DeletePlaylist(userId, playlist.id));
            },
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SongListScreen(
                    title: playlist.name,
                    playlistId: playlist.id,
                  ),
                ),
              );
            },
          );
        }).toList(),
        LibraryItem(
          title: "Thêm danh sách phát",
          showOptions: false,
          onTap: onCreatePlaylist,
        ),
      ],
    );
  }
}