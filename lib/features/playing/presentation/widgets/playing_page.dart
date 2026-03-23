import 'package:btl_music_app/core/providers/love_list_provider.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayingPage extends StatelessWidget {
  final SongModel song;

  const PlayingPage({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),

        /// ALBUM
        Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(song.thumbnail),
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(height: 40),

        Text(
          song.title,
          style: const TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          song.artist,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),

        const SizedBox(height: 16),

        /// Nút thích (lấy từ LoveListProvider)
        Consumer<LoveListProvider>(
          builder: (context, loveProvider, child) {
            final isLoved = loveProvider.isLoved(song.id);
            return IconButton(
              icon: Icon(
                isLoved ? Icons.favorite : Icons.favorite_border,
                color: isLoved ? Colors.purple : Colors.white70,
                size: 30,
              ),
              onPressed: () {
                // Gọi toggle yêu thích
                loveProvider.toggleLoveSong(song.id);
              },
            );
          },
        ),

        const Spacer(),
      ],
    );
  }
}