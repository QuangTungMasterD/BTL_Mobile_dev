import 'package:flutter/material.dart';
import 'package:btl_music_app/features/playing/presentation/playing_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: () {
          // 👉 Chỉ tap ngoài icon mới vào PlayingScreen
          Navigator.pushNamed(context, '/playing');
        },
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [

              /// 🎵 Ảnh hoặc icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.music_note),
              ),

              const SizedBox(width: 12),

              /// 🎼 Title
              const Expanded(
                child: Text(
                  "Tình Ca Tình Ta - Kis",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),

              /// ❤️ Like
              IconButton(
                onPressed: () {
                  // 👉 Không mở screen
                },
                icon: const Icon(Icons.favorite_border),
              ),
              IconButton(
                onPressed: () {
                  // 👉 Play / Pause
                },
                icon: const Icon(Icons.play_arrow),
              ),
              /// ⏭ Next
              IconButton(
                onPressed: () {
                  // 👉 Qua bài
                },
                icon: const Icon(Icons.skip_next),
              ),

              /// ▶ Play / Pause
              
            ],
          ),
        ),
      ),
    );
  }
}