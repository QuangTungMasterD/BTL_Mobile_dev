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
  bool _isGridView = false;

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

  void _toggleViewMode() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  IconData _getSortIcon() {
    switch (_sortOrder) {
      case SortOrder.newest:
        return Icons.arrow_downward;
      case SortOrder.oldest:
        return Icons.arrow_upward;
      default:
        return Icons.swap_vert;
    }
  }

  List<PlayListModel> _sortPlaylists(List<PlayListModel> playlists) {
    switch (_sortOrder) {
      case SortOrder.newest:
        return List.from(playlists)..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case SortOrder.oldest:
        return List.from(playlists)..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      default:
        return playlists;
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
                      icon: Icon(_getSortIcon()),
                      onPressed: _toggleSortOrder,
                      tooltip: 'Sắp xếp theo thời gian',
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
                      icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
                      onPressed: _toggleViewMode,
                      tooltip: _isGridView ? 'Chế độ danh sách' : 'Chế độ lưới',
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
                        : _isGridView
                            ? _buildGridView(playlists, playlistProvider)
                            : _buildListView(playlists, playlistProvider),
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

  Widget _buildListView(List<PlayListModel> playlists, PlayListProvider provider) {
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
          );
        }).toList(),
        LibraryItem(
          title: "Thêm danh sách phát",
          showOptions: false,
          onTap: () => _showCreatePlaylistDialog(context, provider),
        ),
      ],
    );
  }

  Widget _buildGridView(List<PlayListModel> playlists, PlayListProvider provider) {
    return ListView(
      children: [
        // Các item tĩnh vẫn giữ dạng list (hoặc có thể tùy chỉnh)
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
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
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
        const SizedBox(height: 16),
        LibraryItem(
          title: "Thêm danh sách phát",
          showOptions: false,
          onTap: () => _showCreatePlaylistDialog(context, provider),
        ),
      ],
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