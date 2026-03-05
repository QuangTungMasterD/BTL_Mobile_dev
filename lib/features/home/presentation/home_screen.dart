import 'package:btl_music_app/core/providers/song_provider.dart';
import 'package:btl_music_app/core/widgets/bottom.dart';
import 'package:btl_music_app/core/widgets/header.dart';
import 'package:btl_music_app/core/widgets/mini_player.dart';
import 'package:btl_music_app/core/widgets/song_item.dart';
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
    // Ví dụ lấy đề xuất theo thể loại mặc định 'Pop'
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

                      /// ===== DANH SÁCH BÀI HÁT ĐỀ XUẤT =====
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
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// ===== FOR YOU MIX =====
                      const Text(
                        "Dành riêng cho bạn",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        height: 160,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _mixCard("SOOBIN Mix", Colors.pink),
                            _mixCard("Bui Truong Linh Mix", Colors.blue),
                            _mixCard("Quang Hung Mix", Colors.green),
                          ],
                        ),
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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          MiniPlayer(),
          AppBottomNav(currentIndex: 1),
        ],
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
          style: TextStyle(color: selected ? Colors.white : Theme.of(context).colorScheme.onSurface),
        ),
      ),
    );
  }

  static Widget _mixCard(String title, Color color) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}