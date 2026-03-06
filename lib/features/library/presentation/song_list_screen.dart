import 'package:btl_music_app/core/providers/play_list_provider.dart';
import 'package:btl_music_app/core/providers/song_provider.dart';
import 'package:btl_music_app/core/widgets/bottom.dart';
import 'package:btl_music_app/core/widgets/mini_player.dart';
import 'package:btl_music_app/features/library/presentation/widgets/seach_playlist_layout.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SongListScreen extends StatefulWidget {
  final String playlistId;
  final String title;

  const SongListScreen({super.key, required this.playlistId, required this.title});

  @override
  State<SongListScreen> createState() => _SongListScreenState();
}

class _SongListScreenState extends State<SongListScreen> {
  List<SongModel> _songs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final playlistProvider = context.read<PlayListProvider>();
    final songProvider = context.read<SongProvider>();
    final playlist = playlistProvider.playlists.firstWhere((p) => p.id == widget.playlistId);
    final futures = playlist.songIds.map((id) => songProvider.getSongById(id));
    final songs = await Future.wait(futures);
    if (mounted) {
      setState(() {
        _songs = songs.whereType<SongModel>().toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SearchableSongList(
                songs: _songs,
                title: widget.title,
                onSongTap: (song) {
                  // Xử lý phát nhạc
                },
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [MiniPlayer(), AppBottomNav(currentIndex: 0)],
      ),
    );
  }
}