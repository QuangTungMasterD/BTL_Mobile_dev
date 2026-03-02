import 'package:btl_music_app/core/models/song.dart';
import 'package:flutter/material.dart';

class ChartItem extends StatelessWidget {
  final Song song;
  final int rank;

  const ChartItem({
    super.key,
    required this.song,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
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
                    : Colors.white,
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
              image: song.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(song.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
              color: Colors.grey.shade800,
            ),
            child: song.imageUrl == null
                ? const Icon(Icons.music_note,
                    color: Colors.white70)
                : null,
          ),

          const SizedBox(width: 12),

          /// TITLE + ARTIST
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  song.artist,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13),
                ),
              ],
            ),
          ),

          const Icon(Icons.more_vert,
              color: Colors.white70),
        ],
      ),
    );
  }
}