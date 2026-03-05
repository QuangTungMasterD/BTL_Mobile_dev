// downloaded_songs_screen.dart
import 'package:flutter/material.dart';
import 'package:btl_music_app/core/database/database_helper.dart';
import 'package:btl_music_app/core/widgets/song_item.dart';

class DownloadedSongsScreen extends StatelessWidget {
  const DownloadedSongsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đã tải về')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper.instance.getDownloadedSongs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final songs = snapshot.data ?? [];
          if (songs.isEmpty) {
            return const Center(child: Text('Chưa có bài hát nào được tải'));
          }
          return ListView.builder(
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              // Dùng SongItem để hiển thị nhất quán
              return SongItem(
                songId: song['songId'],
                title: song['title'],
                artist: song['artist'],
                image: song['thumbnailUrl'] ?? '',
                onTap: () {
                  // Có thể phát nhạc offline? (chưa có file audio, nên chỉ hiển thị thông tin)
                },
              );
            },
          );
        },
      ),
    );
  }
}