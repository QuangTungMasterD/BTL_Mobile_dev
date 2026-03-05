
import 'package:btl_music_app/core/providers/player_provider.dart';
import 'package:btl_music_app/core/providers/song_provider.dart';
import 'package:btl_music_app/core/widgets/song_options_button.dart';
import 'package:btl_music_app/features/playing/presentation/playing_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SongItem extends StatelessWidget {
  final String title;
  final String artist;
  final String image;
  final String songId;
  final VoidCallback? onTap;

  const SongItem({
    super.key,
    required this.title,
    required this.artist,
    required this.image,
    required this.songId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {
        final player = context.read<PlayerProvider>();
        // Tạo đối tượng SongModel tạm thời để play (cần lấy từ cache hoặc provider)
        // Tốt nhất nên có một phương thức để lấy SongModel từ id.
        // Ở đây giả sử có SongProvider để lấy chi tiết bài hát.
        final songProvider = context.read<SongProvider>();
        songProvider.getSongById(songId).then((song) {
          if (song != null) {
            player.playSong(song);
            // Điều hướng thông minh
            bool found = false;
            Navigator.popUntil(context, (route) {
              if (route.settings.name == '/playing') found = true;
              return true;
            });
            if (!found) {
              Navigator.pushNamed(context, '/playing');
            }
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 55,
                  height: 55,
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.music_note, size: 30),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              height: 55,
              alignment: Alignment.center,
              child: SongOptionsButton(
                songId: songId,
                title: title,
                artist: artist,
                image: image,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
