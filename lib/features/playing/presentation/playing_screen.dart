import 'dart:ui';
import 'package:btl_music_app/features/comment/presentation/comment_screen.dart';
import 'package:btl_music_app/features/playing/presentation/widgets/lyrics_page.dart';
import 'package:btl_music_app/features/playing/presentation/widgets/playing_page.dart';
import 'package:flutter/material.dart';

class PlayingScreen extends StatefulWidget {
  const PlayingScreen({super.key});

  @override
  State<PlayingScreen> createState() => _PlayingScreenState();
}

class _PlayingScreenState extends State<PlayingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final String imageUrl =
      "https://i.scdn.co/image/ab67616d0000b273c3f8d8d8bdb3b0e4c4b6f8b2";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background
          Positioned.fill(child: Image.network(imageUrl, fit: BoxFit.cover)),

          /// Blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
          ),

          /// PAGE VIEW
          Padding(
            padding: const EdgeInsets.only(top: 120, bottom: 220),
            child: PageView(
              controller: _controller,
              onPageChanged: (i) {
                setState(() {
                  currentPage = i;
                });
              },
              children: [
                PlayingPage(imageUrl: imageUrl),
                LyricsPage(imageUrl: imageUrl),
              ],
            ),
          ),

          /// HEADER
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  /// LEFT
                  SizedBox(
                    width: 40,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),

                  /// CENTER TITLE (true center)
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentPage == 0 ? "Bài hát" : "Lời bài hát",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// RIGHT (fixed width để cân)
                  const SizedBox(
                    width: 40,
                    child: Icon(Icons.more_vert, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          /// DOT INDICATOR
          Positioned(
            top: 95,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [dot(0), dot(1)],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  Slider(
                    value: 0.3,
                    activeColor: Colors.white,
                    inactiveColor: Colors.white30,
                    onChanged: (v) {},
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("0:08", style: TextStyle(color: Colors.white)),
                      Text("3:51", style: TextStyle(color: Colors.white)),
                    ],
                  ),

                  const SizedBox(height: 15),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(Icons.shuffle, color: Colors.purple, size: 24),
                          Icon(
                            Icons.skip_previous,
                            color: Colors.white,
                            size: 32,
                          ),
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.pause,
                              color: Colors.black,
                              size: 38,
                            ),
                          ),
                          Icon(Icons.skip_next, color: Colors.white, size: 32),
                          Icon(Icons.repeat, color: Colors.white, size: 24),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.comment_outlined),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => const CommentSheet(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: currentPage == index ? 14 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.white : Colors.white30,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
