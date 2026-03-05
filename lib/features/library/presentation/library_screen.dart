import 'package:btl_music_app/core/providers/play_list_provider.dart';
import 'package:btl_music_app/core/widgets/bottom.dart';
import 'package:btl_music_app/core/widgets/header.dart';
import 'package:btl_music_app/core/widgets/mini_player.dart';
import 'package:btl_music_app/features/library/presentation/download_list_screen.dart';
import 'package:btl_music_app/features/library/presentation/love_list_screen.dart';
import 'package:btl_music_app/features/library/presentation/song_list_screen.dart';
import 'package:btl_music_app/features/library/presentation/widgets/library_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playlistProvider = context.watch<PlayListProvider>();
    final playlists = playlistProvider.playlists;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(title: 'Thư viện'),

              /// ===== GẦN ĐÂY =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    Icon(Icons.swap_vert),
                    SizedBox(width: 8),
                    Text(
                      "Gần đây",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.grid_view),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ===== DANH SÁCH PLAYLIST =====
              Expanded(
                child: playlistProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : playlistProvider.error != null
                        ? Center(child: Text('Lỗi: ${playlistProvider.error}'))
                        : ListView(
                            children: [
                              // Mục "Bài hát đã thích" (có thể thay bằng dữ liệu thật sau)
                              LibraryItem(
                                title: "Bài hát đã thích",
                                // subtitle: "Danh sách phát • 2 bài hát",
                                showOptions: false,
                                isLiked: true,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoveListScreen(
                                      ),
                                    ),
                                  );
                                },
                              ),
                              LibraryItem(
                                title: "Bài hát đã tải",
                                // subtitle: "Danh sách phát • 2 bài hát",
                                isDownload: true,
                                showOptions: false,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const DownloadedSongsScreen(
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // Các playlist do người dùng tạo
                              ...playlists.map((playlist) {
                                return LibraryItem(
                                  title: playlist.name,
                                  subtitle:
                                      "Danh sách phát • ${playlist.songIds.length} bài hát",
                                  isLiked: false,
                                  coverUrl: playlist.coverUrl,
                                  onDelete: () => playlistProvider.deletePlaylist(playlist.id),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => SongListScreen(
                                          title: playlist.name,
                                          playlistId: playlist.id,
                                          // Có thể truyền thêm playlist.id nếu màn hình chi tiết cần
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                              // Nút thêm playlist mới
                              LibraryItem(
                                title: "Thêm danh sách phát",
                                showOptions: false,
                                onTap: () =>
                                    _showCreatePlaylistDialog(context, playlistProvider),
                              ),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [MiniPlayer(), AppBottomNav(currentIndex: 0)],
      ),
    );
  }

  /// Hiển thị hộp thoại tạo playlist mới
  void _showCreatePlaylistDialog(
      BuildContext context, PlayListProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tạo playlist mới'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nhập tên playlist'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                provider.createPlaylist(controller.text.trim(), null);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }
}