import 'package:btl_music_app/core/widgets/bottom.dart';
import 'package:btl_music_app/core/widgets/header.dart';
import 'package:btl_music_app/core/widgets/mini_player.dart';
import 'package:btl_music_app/features/library/presentation/song_list_screen.dart';
import 'package:btl_music_app/features/library/presentation/widgets/library_item.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(title: 'Thư viện'),

              /// ===== GẦN ĐÂY =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    Icon(Icons.swap_vert),
                    SizedBox(width: 8),
                    Text(
                      "Gần đây",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.grid_view),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ===== LIST =====
              Expanded(
                child: ListView(
                  children: [
                    LibraryItem(
                      title: "Bài hát đã thích",
                      subtitle: "Danh sách phát • 2 bài hát",
                      isLiked: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SongListScreen(
                              title: "Đã thích",
                            ),
                          ),
                        );
                      },
                    ),
                    LibraryItem(title: "Thêm nghệ sĩ"),
                    LibraryItem(title: "Thêm podcast"),
                    LibraryItem(title: "Thêm sự kiện và địa điểm"),
                    LibraryItem(title: "Thêm nhạc", isDownload: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [MiniPlayer(), AppBottomNav(currentIndex: 0)],
      ),
    );
  }
}
