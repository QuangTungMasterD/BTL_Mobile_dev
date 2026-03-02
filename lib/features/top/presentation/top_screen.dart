import 'package:btl_music_app/features/top/presentation/widgets/top_item.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/mini_player.dart';
import '../../../core/widgets/bottom.dart';
import '../../../core/models/song.dart';

List<Song> fakeChartSongs() {
  return List.generate(
    99,
    (index) => Song(
      title: "Bài hát ${index + 1}",
      artist: "Ca sĩ ${index + 1}",
    ),
  );
}

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final songs = fakeChartSongs();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1F5F), Color(0xFF1B0F2E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              /// HEADER
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: const [
                    Text(
                      "#Top 99",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    Spacer(),
                    // Icon(Icons.mic_none, color: Colors.white),
                    SizedBox(width: 12),
                    Icon(Icons.search, color: Colors.white),
                  ],
                ),
              ),

              /// LIST
              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return ChartItem(
                      song: songs[index],
                      rank: index + 1,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          MiniPlayer(),
          AppBottomNav(currentIndex: 2),
        ],
      ),
    );
  }
}