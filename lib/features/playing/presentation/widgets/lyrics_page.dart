import 'package:flutter/material.dart';

class LyricsPage extends StatelessWidget {
  final String imageUrl;

  const LyricsPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey,
                      child: const Icon(Icons.music_note, color: Colors.white),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Anh Thanh Niên",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "HuyR",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 140,
              ),
              children: const [
                Lyric("Anh thanh niên năm nay"),
                Lyric("Đã ngót nghét ba mươi rồi"),
                Lyric("Sáng mua năm nghìn xôi"),
                Lyric("Tối ba nghìn trà đá"),
                Lyric("Anh luôn luôn onl Face"),
                Lyric("Để biết hết chuyện trên đời"),
                Lyric("Đăng cái status bình thường"),
                Lyric("Đăng cái status bình thường"),
                Lyric("Đăng cái status bình thường"),
                Lyric("Đăng cái status bình thường"),
                Lyric("Đăng cái status bình thường"),
                Lyric("Đăng cái status bình thường"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Lyric extends StatelessWidget {
  final String text;
  const Lyric(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          color: Colors.white70,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
