
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:btl_music_app/core/providers/song_provider.dart';
import 'package:btl_music_app/features/top/presentation/widgets/top_item.dart';
import '../../../core/widgets/mini_player.dart';
import '../../../core/widgets/bottom.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SongProvider>().loadTopSongs(limit: 99);
    });
  }

  @override
  Widget build(BuildContext context) {
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
              /// HEADER (giữ nguyên)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text(
                      "#Top 99",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    Spacer(),
                    SizedBox(width: 12),
                    IconButton(
                      icon: Icon(Icons.search),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pushNamed(context, '/search');
                      },
                    ),
                  ],
                ),
              ),

              /// LIST
              Expanded(
                child: Consumer<SongProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoadingTop) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final topSongs = provider.topSongs;
                    if (topSongs.isEmpty) {
                      return const Center(
                        child: Text(
                          'Không có dữ liệu',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: topSongs.length,
                      itemBuilder: (context, index) {
                        final songModel = topSongs[index];
                        return ChartItem(
                          song: songModel,
                          rank: index + 1,
                          songId: songModel.id,
                        );
                      },
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