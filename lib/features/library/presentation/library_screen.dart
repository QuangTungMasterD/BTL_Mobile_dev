import 'package:btl_music_app/features/library/bloc/playlist/playlist_bloc.dart';
import 'package:btl_music_app/features/library/bloc/playlist/playlist_event.dart';
import 'package:btl_music_app/features/library/bloc/playlist/playlist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/core/providers/auth_provider.dart';
import 'package:btl_music_app/core/widgets/bottom.dart';
import 'package:btl_music_app/core/widgets/header.dart';
import 'package:btl_music_app/core/widgets/mini_player.dart';
import 'package:btl_music_app/features/library/data/models/play_list_model.dart';
import 'package:btl_music_app/features/library/data/repo/play_list_repo.dart';
import 'package:btl_music_app/features/library/presentation/widgets/playlist_grid_view.dart';
import 'package:btl_music_app/features/library/presentation/widgets/playlist_list_view.dart';

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
    final authProvider = context.watch<AuthUserProvider>();
    final userId = authProvider.user?.uid ?? '';

    return BlocProvider(
      create: (context) => PlaylistBloc(
        repository: context.read<PlayListRepository>(),
      )..add(LoadPlaylists(userId)),
      child: Scaffold(
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
                  child: BlocBuilder<PlaylistBloc, PlaylistState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state.error != null) {
                        return Center(child: Text('Lỗi: ${state.error}'));
                      }
                      final playlists = _sortPlaylists(state.playlists);
                      if (_isGridView) {
                        return PlaylistGridView(
                          playlists: playlists,
                          bloc: context.read<PlaylistBloc>(),
                          userId: userId,
                          onCreatePlaylist: () => _showCreatePlaylistDialog(context),
                        );
                      } else {
                        return PlaylistListView(
                          playlists: playlists,
                          bloc: context.read<PlaylistBloc>(),
                          userId: userId,
                          onCreatePlaylist: () => _showCreatePlaylistDialog(context),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [MiniPlayer(), AppBottomNav(currentIndex: 0)],
        ),
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final controller = TextEditingController();
    final bloc = context.read<PlaylistBloc>();
    final userId = context.read<AuthUserProvider>().user?.uid ?? '';

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
                bloc.add(CreatePlaylist(userId, controller.text.trim(), null));
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