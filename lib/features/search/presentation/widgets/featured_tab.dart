import 'package:btl_music_app/core/providers/song_provider.dart';
import 'package:btl_music_app/core/widgets/song_item.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeaturedTab extends StatelessWidget {
  final String query;
  const FeaturedTab({super.key, required this.query});

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
          return const Center(child: Text("Không tìm thấy kết quả nổi bật"));
        }

        // Sắp xếp theo playCount giảm dần
        final featured = List.of(results)
          ..sort((a, b) => b.playCount.compareTo(a.playCount));
        final topFeatured = featured.take(10).toList();

        return ListView.builder(
          itemCount: topFeatured.length,
          itemBuilder: (context, index) {
            final song = topFeatured[index];
            return SongItem(
              songId: song.id,
              title: song.title,
              artist: song.artist,
              image: song.thumbnail,
            );
          },
        );
      },
    );
  }
}