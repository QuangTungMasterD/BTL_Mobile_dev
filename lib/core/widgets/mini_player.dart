import 'package:btl_music_app/core/providers/player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, player, child) {
        final song = player.currentSong;
        if (song == null) return const SizedBox.shrink();

        return Material(
          child: InkWell(
            onTap: () {
              // Kiểm tra xem route '/playing' đã tồn tại trong stack chưa
              bool found = false;
              Navigator.popUntil(context, (route) {
                if (route.settings.name == '/playing') {
                  found = true;
                }
                return true; // chỉ duyệt, không pop
              });

              if (found) {
                // Đã có route '/playing' -> pop về nó
                Navigator.popUntil(context, ModalRoute.withName('/playing'));
              } else {
                // Chưa có -> push route mới
                Navigator.pushNamed(context, '/playing');
              }
            },
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      song.thumbnail,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey,
                        child: const Icon(Icons.music_note),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          song.title,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          song.artist,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      player.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    onPressed: player.isPlaying ? player.pause : player.resume,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}