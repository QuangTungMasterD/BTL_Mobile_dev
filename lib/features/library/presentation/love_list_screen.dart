import 'package:btl_music_app/core/providers/love_list_provider.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:btl_music_app/core/providers/song_provider.dart';
import 'package:btl_music_app/core/widgets/song_item.dart';

class LoveListScreen extends StatelessWidget {
  const LoveListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Expanded(
                    child: Text(
                      "Yêu thích",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
            ),

            /// LIST
            Expanded(
              child: Consumer2<LoveListProvider, SongProvider>(
                builder: (context, loveListProvider, songProvider, child) {
                  final songIds = loveListProvider.songIds;

                  if (songIds.isEmpty) {
                    return const Center(
                      child: Text("Chưa có bài hát yêu thích nào"),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    itemCount: songIds.length,
                    itemBuilder: (context, index) {
                      final songId = songIds[index];
                      return FutureBuilder<SongModel?>(
                        future: songProvider.getSongById(songId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const ListTile(title: Text("Đang tải..."));
                          }
                          if (!snapshot.hasData) {
                            return const ListTile(
                              title: Text("Không tìm thấy bài hát"),
                            );
                          }
                          final song = snapshot.data!;
                          return SongItem(
                            title: song.title,
                            artist: song.artist,
                            image: song.thumbnail,
                            songId: song.id,
                            onTap: () {
                              // Xử lý phát nhạc
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}