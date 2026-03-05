import 'package:btl_music_app/core/providers/song_provider.dart';
import 'package:btl_music_app/core/widgets/song_item.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SongsTab extends StatelessWidget {
  final String query;
  const SongsTab({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SongModel>>(
      future: context.read<SongProvider>().searchSongs(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        }
        final results = snapshot.data ?? [];
        if (results.isEmpty) {
          return const Center(child: Text("Không tìm thấy bài hát nào"));
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final song = results[index];
            return SongItem(
              songId: song.id,
              title: song.title,
              artist: song.artist,
              image: song.thumbnail,
              onTap: () {
                // xử lý khi bấm vào bài hát
              },
            );
          },
        );
      },
    );
  }
}