import 'package:btl_music_app/core/providers/play_list_provider.dart';
import 'package:btl_music_app/core/widgets/bottom.dart';
import 'package:btl_music_app/core/widgets/header.dart';
import 'package:btl_music_app/core/widgets/mini_player.dart';
import 'package:btl_music_app/features/library/data/models/play_list_model.dart';
import 'package:btl_music_app/features/library/presentation/download_list_screen.dart';
import 'package:btl_music_app/features/library/presentation/love_list_screen.dart';
import 'package:btl_music_app/features/library/presentation/song_list_screen.dart';
import 'package:btl_music_app/features/library/presentation/widgets/library_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum SortOrder { newest, oldest, defaultOrder }

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  SortOrder _sortOrder = SortOrder.defaultOrder;

  void _toggleSortOrder() {
    setState(() {
      if (_sortOrder == SortOrder.defaultOrder) {
        _sortOrder = SortOrder.newest;
      } else if (_sortOrder == SortOrder.newest) {
        _sortOrder = SortOrder.oldest;
      } else {
        _sortOrder = SortOrder.defaultOrder;
      }
    });
  }

  Object _getSortIcon() {
    switch (_sortOrder) {
      case SortOrder.newest:
        return Icons.arrow_downward; // hoặc icon mũi tên xuống (mới nhất)
      case SortOrder.oldest:
        return Icons.arrow_upward; // mũi tên lên (cũ nhất)
      default:
        return Icons.swap_vert; // mặc định
    }
  }

  List<PlayListModel> _sortPlaylists(List<PlayListModel> playlists) {
    switch (_sortOrder) {
      case SortOrder.newest:
        return List.from(playlists)..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case SortOrder.oldest:
        return List.from(playlists)..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      default:
        return playlists; // giữ nguyên thứ tự từ provider
    }
  }

  @override
  Widget build(BuildContext context) {
    final playlistProvider = context.watch<PlayListProvider>();
    final playlists = _sortPlaylists(playlistProvider.playlists);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(title: 'Thư viện'),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        _getSortIcon() as IconData?,
                      ),
                      onPressed: _toggleSortOrder,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Gần đây",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.grid_view),
                      onPressed: () {
                        
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: playlistProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : playlistProvider.error != null
                        ? Center(child: Text('Lỗi: ${playlistProvider.error}'))
                        : ListView(
                            children: [
                              LibraryItem(
                                title: "Bài hát đã thích",
                                showOptions: false,
                                isLiked: true,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const LoveListScreen(),
                                    ),
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
                                    MaterialPageRoute(
                                      builder: (_) => const DownloadedSongsScreen(),
                                    ),
                                  );
                                },
                              ),
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
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
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

  void _showCreatePlaylistDialog(BuildContext context, PlayListProvider provider) {
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