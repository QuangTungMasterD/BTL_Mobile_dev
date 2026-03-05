import 'dart:ui';
import 'package:btl_music_app/core/providers/auth_provider.dart';
import 'package:btl_music_app/core/providers/player_provider.dart';
import 'package:btl_music_app/core/widgets/song_options_button.dart';
import 'package:btl_music_app/features/comment/presentation/comment_screen.dart';
import 'package:btl_music_app/features/playing/presentation/widgets/lyrics_page.dart';
import 'package:btl_music_app/features/playing/presentation/widgets/playing_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayingScreen extends StatefulWidget {
  const PlayingScreen({super.key});

  @override
  State<PlayingScreen> createState() => _PlayingScreenState();
}

class _PlayingScreenState extends State<PlayingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, player, child) {
        final song = player.currentSong;
        if (song == null) {
          return const Scaffold(body: Center(child: Text('Không có bài hát')));
        }

        final imageUrl = song.thumbnail;

        return Scaffold(
          body: Stack(
            children: [
              /// Background
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: Colors.black),
                ),
              ),

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
                    PlayingPage(song: song),
                    LyricsPage(song: song),
                  ],
                ),
              ),

              /// HEADER
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      /// LEFT
                      SizedBox(
                        width: 40,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),

                      /// CENTER TITLE
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6),
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
                      ),

                      /// RIGHT - nút 3 chấm
                      SizedBox(
                        width: 40,
                        child: SongOptionsButton(
                          songId: song.id,
                          title: song.title,
                          artist: song.artist,
                          image: song.thumbnail,
                          iconColor: Colors.white,
                        ),
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

              /// BOTTOM CONTROLS
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      Slider(
                        value: player.position.inMilliseconds.toDouble(),
                        min: 0,
                        max: player.duration.inMilliseconds.toDouble(),
                        activeColor: Colors.white,
                        inactiveColor: Colors.white30,
                        onChanged: (value) {
                          player.seek(Duration(milliseconds: value.toInt()));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(player.position),
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              _formatDuration(player.duration),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(
                                Icons.shuffle,
                                color: Colors.purple,
                                size: 24,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.skip_previous,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                onPressed: () {
                                  // TODO: chuyển bài trước
                                },
                              ),
                              CircleAvatar(
                                radius: 32,
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: Icon(
                                    player.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.black,
                                    size: 38,
                                  ),
                                  onPressed: () {
                                    if (player.isPlaying) {
                                      player.pause();
                                    } else {
                                      player.resume();
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.skip_next,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                onPressed: () {
                                  // TODO: chuyển bài tiếp theo
                                },
                              ),
                              const Icon(
                                Icons.repeat,
                                color: Colors.white,
                                size: 24,
                              ),
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
                                      builder: (_) => CommentSheet(
                                        songId: song.id,
                                        currentUserId: context
                                            .read<AuthUserProvider>()
                                            .user
                                            ?.uid,
                                      ),
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
      },
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
