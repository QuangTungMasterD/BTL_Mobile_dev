import 'package:flutter/material.dart';
import 'package:btl_music_app/features/library/data/models/play_list_model.dart';
import 'package:btl_music_app/features/library/presentation/widgets/library_item.dart';
import 'package:btl_music_app/features/library/presentation/love_list_screen.dart';
import 'package:btl_music_app/features/library/presentation/download_list_screen.dart';
import 'package:btl_music_app/features/library/presentation/song_list_screen.dart';
import 'package:btl_music_app/core/providers/play_list_provider.dart';

class PlaylistGridView extends StatelessWidget {
  final List<PlayListModel> playlists;
  final PlayListProvider provider;
  final VoidCallback onCreatePlaylist;

  const PlaylistGridView({
    super.key,
    required this.playlists,
    required this.provider,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              final playlist = playlists[index];
              return LibraryItem(
                title: playlist.name,
                subtitle: "${playlist.songIds.length} bài hát",
                coverUrl: playlist.coverUrl,
                onDelete: () => provider.deletePlaylist(playlist.id),
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
                isGrid: true,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        LibraryItem(
          title: "Thêm danh sách phát",
          showOptions: false,
          onTap: onCreatePlaylist,
        ),
      ],
    );
  }
}
