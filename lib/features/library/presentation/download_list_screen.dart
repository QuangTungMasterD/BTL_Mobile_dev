// downloaded_songs_screen.dart
import 'package:btl_music_app/core/widgets/bottom.dart';
import 'package:btl_music_app/core/widgets/mini_player.dart';
import 'package:btl_music_app/features/library/presentation/widgets/seach_playlist_layout.dart';
import 'package:flutter/material.dart';
import 'package:btl_music_app/core/database/database_helper.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';

class DownloadedSongsScreen extends StatefulWidget {
  const DownloadedSongsScreen({super.key});

  @override
  State<DownloadedSongsScreen> createState() => _DownloadedSongsScreenState();
}

class _DownloadedSongsScreenState extends State<DownloadedSongsScreen> {
  List<SongModel> _songs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    final data = await DatabaseHelper.instance.getDownloadedSongs();
    // Chuyển đổi từ Map sang SongModel
    final songs = data.map((map) {
      return SongModel(
        id: map['songId'] as String,
        title: map['title'] as String,
        artist: map['artist'] as String,
        thumbnailUrl: map['thumbnailUrl'] as String? ?? '',
        artistId: '',
        youtubeId: '',
        duration: 0,
        playCount: 0,
        likeCount: 0,
      );
    }).toList();
    if (mounted) {
      setState(() {
        _songs = songs;
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
                title: "Đã tải về",
                onSongTap: (song) {
                  // Xử lý phát nhạc offline (nếu có)
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