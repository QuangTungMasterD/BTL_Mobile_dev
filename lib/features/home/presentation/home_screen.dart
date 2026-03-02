import 'package:btl_music_app/core/widgets/bottom.dart';
import 'package:btl_music_app/core/widgets/header.dart';
import 'package:btl_music_app/core/widgets/mini_player.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ProfileHeader(title: 'Trang chủ'),
            Expanded(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    /// MAIN CONTENT
                    Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: SingleChildScrollView(
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

                            /// ===== SONG LIST =====
                            _songItem(
                              "Chạy Về Khóc Với Anh",
                              "ERIK",
                              "https://i.scdn.co/image/ab67616d0000b273e0bcb9e0f0d6e3b6c4a1f0f4",
                            ),
                            _songItem(
                              "Hạ Còn Vương Nắng",
                              "DatKaa, Kido",
                              "https://i.scdn.co/image/ab67616d0000b273f0f1e3d2a5b0e6b9d7c3e1f2",
                            ),
                            _songItem(
                              "Bản Ngôn Tình Thứ Nhất",
                              "Ron",
                              "https://i.scdn.co/image/ab67616d0000b273a1b2c3d4e5f6g7h8i9j0",
                            ),

                            const SizedBox(height: 20),

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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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

                            /// ===== FOR YOU =====
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      /// ===== BOTTOM NAV =====
      // bottomNavigationBar: AppBottomNav(
      //   currentIndex: 0,
      //   onTap: (int index) => {},
      // ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MiniPlayer(),
          AppBottomNav(currentIndex: 1)
        ],
      ),
    );
  }

  /// CHIP
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

  /// SONG ITEM
  static Widget _songItem(String title, String artist, String image) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                const SizedBox(height: 4),
                Text(artist),
              ],
            ),
          ),
          const Icon(Icons.more_vert),
        ],
      ),
    );
  }

  /// MIX CARD
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
          ),
        ),
      ),
    );
  }
}
