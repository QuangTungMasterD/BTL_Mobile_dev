import 'package:btl_music_app/core/providers/player_provider.dart';
import 'package:btl_music_app/core/widgets/song_options_button.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:btl_music_app/features/playing/presentation/playing_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChartItem extends StatelessWidget {
  final SongModel song;
  final int rank;
  final String songId; // Thêm songId

  const ChartItem({
    super.key,
    required this.song,
    required this.rank,
    required this.songId, // bắt buộc
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          final player = context.read<PlayerProvider>();
          player.playSong(song); // cập nhật bài hát hiện tại

          // Kiểm tra và điều hướng (tương tự mini player)
          bool found = false;
          Navigator.popUntil(context, (route) {
            if (route.settings.name == '/playing') found = true;
            return true;
          });
          if (!found) {
            Navigator.pushNamed(context, '/playing');
          }
        },
        child: Row(
          children: [
            /// RANK
            SizedBox(
              width: 30,
              child: Text(
                "$rank",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: rank == 1
                      ? Colors.pinkAccent
                      : rank == 2
                      ? Colors.blueAccent
                      : rank == 3
                      ? Colors.greenAccent
                      : Colors.white70,
                ),
              ),
            ),

            const SizedBox(width: 12),

            /// IMAGE
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(song.thumbnail),
                  fit: BoxFit.cover,
                ),
                color: Colors.grey.shade800,
              ),
              child: Icon(Icons.music_note, color: Colors.white70),
            ),

            const SizedBox(width: 12),

            /// TITLE + ARTIST
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artist,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            /// Nút 3 chấm với logic giống SongItem
            Container(
              height: 55,
              alignment: Alignment.center,
              child: SongOptionsButton(
                songId: song.id,
                title: song.title,
                artist: song.artist,
                image: song.thumbnail,
                iconColor: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
