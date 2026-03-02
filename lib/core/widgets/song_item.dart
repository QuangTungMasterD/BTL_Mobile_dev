import 'package:flutter/material.dart';
import '../models/song.dart';

class SongItem extends StatelessWidget {
  final Song song;
  final VoidCallback? onTap;

  const SongItem({
    super.key,
    required this.song,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Row(
          children: [

            /// ===== IMAGE =====
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade800,
                image: song.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(song.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: song.imageUrl == null
                  ? const Icon(Icons.music_note, color: Colors.white70)
                  : null,
            ),

            const SizedBox(width: 12),

            /// ===== TITLE + ARTIST =====
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (song.isHQ)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white38),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "HQ",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          song.artist,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// ===== RIGHT SIDE ICONS =====
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (song.isDownloaded)
                  const Icon(Icons.download_done,
                      color: Colors.purple, size: 20),

                if (song.isLiked)
                  const Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Icon(Icons.favorite,
                        color: Colors.red, size: 18),
                  ),

                const SizedBox(width: 8),

                const Icon(Icons.more_vert,
                    color: Colors.white70, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}