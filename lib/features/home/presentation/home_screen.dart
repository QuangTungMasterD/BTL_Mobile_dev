import 'package:btl_music_app/core/providers/artist_provider.dart';
import 'package:btl_music_app/core/providers/player_provider.dart';
import 'package:btl_music_app/core/providers/song_provider.dart';
import 'package:btl_music_app/core/providers/user_provider.dart';
import 'package:btl_music_app/core/widgets/bottom.dart';
import 'package:btl_music_app/core/widgets/header.dart';
import 'package:btl_music_app/core/widgets/mini_player.dart';
import 'package:btl_music_app/core/widgets/song_item.dart';
import 'package:btl_music_app/features/artist/presentation/artist_songs_screen.dart';
import 'package:btl_music_app/features/home/presentation/widgets/artist_card..dart';
import 'package:btl_music_app/features/home/presentation/widgets/category_chip.dart';
import 'package:btl_music_app/features/home/presentation/widgets/promo_banner.dart';
import 'package:btl_music_app/features/music/data/models/artist_model.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SongModel> _recommendations = [];
  bool _isLoadingRecs = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecommendations();
    });
  }

  Future<void> _loadRecommendations() async {
    setState(() => _isLoadingRecs = true);
    final provider = context.read<SongProvider>();
    final playerProvider = context.read<PlayerProvider>();
    
    final songs = await provider.getRecommendationsByGenre(limit: 6);
    playerProvider.setPlaylist(songs, startIndex: 0);


    if (mounted) {
      setState(() {
        _recommendations = songs;
        _isLoadingRecs = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileHeader(title: 'Trang chủ'),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      /// ===== TOP CATEGORY CHIPS =====
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            CategoryChip(text: "Cho bạn", selected: true),
                            CategoryChip(text: "Thư giãn", selected: false),
                            CategoryChip(text: "Tập trung", selected: false),
                            CategoryChip(text: "Workout", selected: false),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// ===== ĐỀ XUẤT =====
                      if (_isLoadingRecs)
                        const Center(child: CircularProgressIndicator())
                      else if (_recommendations.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text("Chưa có bài hát nào"),
                          ),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Đề xuất cho bạn",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ..._recommendations.map(
                              (song) => SongItem(
                                songId: song.id,
                                title: song.title,
                                artist: song.artist,
                                image: song.thumbnail,
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),

                      /// ===== PROMO BANNER =====
                      PromoBanner(),

                      const SizedBox(height: 30),

                      /// ===== NGHỆ SĨ =====
                      const Text(
                        "Nghệ sĩ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// Lấy 3 nghệ sĩ từ ArtistProvider
                      Consumer<ArtistProvider>(
                        builder: (context, artistProvider, child) {
                          final artists = artistProvider.allArtists;
                          if (artistProvider.isLoading || artists.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          // Lấy 3 nghệ sĩ đầu tiên (hoặc random)
                          final displayedArtists = artists.take(3).toList();
                          return SizedBox(
                            height: 160,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: displayedArtists.length,
                              itemBuilder: (context, index) {
                                final artist = displayedArtists[index];
                                return ArtistCard(
                                  artist: artist,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ArtistSongsScreen(
                                          artistId: artist.id,
                                          artistName: artist.name,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [MiniPlayer(), AppBottomNav(currentIndex: 1)],
      ),
    );
  }
}
