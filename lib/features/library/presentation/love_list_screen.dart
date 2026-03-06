import 'package:btl_music_app/core/providers/love_list_provider.dart';
import 'package:btl_music_app/features/library/presentation/widgets/seach_playlist_layout.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:btl_music_app/core/providers/song_provider.dart';

class LoveListScreen extends StatefulWidget {
  const LoveListScreen({super.key});

  @override
  State<LoveListScreen> createState() => _LoveListScreenState();
}

class _LoveListScreenState extends State<LoveListScreen> {
  List<SongModel> _songs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final loveProvider = context.read<LoveListProvider>();
    final songProvider = context.read<SongProvider>();
    final songIds = loveProvider.songIds;

    // Load song song tất cả bài hát
    final futures = songIds.map((id) => songProvider.getSongById(id));
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
                title: "Yêu thích",
                onSongTap: (song) {
                  // Xử lý phát nhạc
                },
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // Có thể thêm menu tùy chọn ở đây
                  },
                ),
              ),
      ),
    );
  }
}