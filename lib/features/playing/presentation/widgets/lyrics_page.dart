import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:flutter/material.dart';

class LyricsPage extends StatelessWidget {
  final SongModel song;

  const LyricsPage({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  song.thumbnail,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey,
                      child: const Icon(Icons.music_note, color: Colors.white),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      song.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Expanded(
            child: song.lyrics != null && song.lyrics!.isNotEmpty
                ? ListView.builder(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 140,
                    ),
                    itemCount: song.lyrics!.length,
                    itemBuilder: (context, index) {
                      final line = song.lyrics![index];
                      return Lyric(line.text);
                    },
                  )
                : const Center(
                    child: Text(
                      'Chưa có lời bài hát',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class Lyric extends StatelessWidget {
  final String text;
  const Lyric(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          color: Colors.white70,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}