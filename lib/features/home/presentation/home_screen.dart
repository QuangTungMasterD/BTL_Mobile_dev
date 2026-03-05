import 'package:btl_music_app/core/providers/artist_provider.dart';
import 'package:btl_music_app/core/providers/song_provider.dart';
import 'package:btl_music_app/core/widgets/bottom.dart';
import 'package:btl_music_app/core/widgets/header.dart';
import 'package:btl_music_app/core/widgets/mini_player.dart';
import 'package:btl_music_app/core/widgets/song_item.dart';
import 'package:btl_music_app/features/artist/presentation/artist_songs_screen.dart';
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
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    setState(() => _isLoadingRecs = true);
    final provider = context.read<SongProvider>();
    final songs = await provider.getRecommendationsByGenre(limit: 6);
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
                            _chip("Cho bạn", true, context),
                            _chip("Thư giãn", false, context),
                            _chip("Tập trung", false, context),
                            _chip("Workout", false, context),
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
                            ..._recommendations.map((song) => SongItem(
                                  songId: song.id,
                                  title: song.title,
                                  artist: song.artist,
                                  image: song.thumbnail,
                                )),
                            const SizedBox(height: 30),
                          ],
                        ),

                      /// ===== PROMO BANNER =====
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 139, 92, 225),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.star, color: Colors.white),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Ưu đãi mừng xuân",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Lì xì bạn 7 ngày Plus miễn phí",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),

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
                            return const Center(child: CircularProgressIndicator());
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
                                return _artistCard(
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

  Widget _chip(String text, bool selected, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _artistCard({required ArtistModel artist, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: artist.avatar != null
              ? DecorationImage(
                  image: NetworkImage(artist.avatar!),
                  fit: BoxFit.cover,
                )
              : null,
          color: artist.avatar == null ? Colors.grey.shade800 : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(12),
          child: Text(
            artist.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}