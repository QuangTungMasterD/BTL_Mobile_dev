import 'package:btl_music_app/features/comment/presentation/comment_screen.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:btl_music_app/core/providers/player_provider.dart';
import 'package:btl_music_app/core/providers/auth_provider.dart';

class PlayerControls extends StatelessWidget {
  final SongModel song;
  final String Function(Duration) formatDuration; // callback để format thời gian

  const PlayerControls({
    super.key,
    required this.song,
    required this.formatDuration,
  });

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            Slider(
              value: player.position.inMilliseconds.toDouble(),
              min: 0,
              max: player.duration.inMilliseconds.toDouble(),
              activeColor: Colors.white,
              inactiveColor: Colors.white30,
              onChanged: (value) {
                player.seek(Duration(milliseconds: value.toInt()));
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDuration(player.position),
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    formatDuration(player.duration),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.shuffle, color: Colors.purple, size: 24),
                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: Colors.white, size: 32),
                      onPressed: () {
                        // TODO: chuyển bài trước
                      },
                    ),
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          player.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.black,
                          size: 38,
                        ),
                        onPressed: () {
                          if (player.isPlaying) {
                            player.pause();
                          } else {
                            player.resume();
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white, size: 32),
                      onPressed: () {
                        // TODO: chuyển bài tiếp theo
                      },
                    ),
                    const Icon(Icons.repeat, color: Colors.white, size: 24),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.comment_outlined, color: Colors.white70),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => CommentSheet(
                              songId: song.id,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}