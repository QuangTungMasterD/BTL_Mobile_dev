import 'package:flutter/material.dart';
import '../../../core/models/song.dart';
import '../../../core/widgets/song_item.dart';

class SongListScreen extends StatelessWidget {
  final String title;
  // final List<Song> songs;

  const SongListScreen({
    super.key,
    required this.title,
    // required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                  ),
                ],
              ),
            ),

            /// LIST
            // Expanded(
            //   child: ListView.builder(
            //     padding: const EdgeInsets.symmetric(horizontal: 16),
            //     itemCount: songs.length,
            //     itemBuilder: (context, index) {
            //       return SongItem(song: songs[index]);
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}