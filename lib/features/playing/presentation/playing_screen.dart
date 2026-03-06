import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:btl_music_app/core/providers/player_provider.dart';
import 'package:btl_music_app/core/widgets/song_options_button.dart';
import 'package:btl_music_app/features/playing/presentation/widgets/controler_music.dart';
import 'package:btl_music_app/features/playing/presentation/widgets/lyrics_page.dart';
import 'package:btl_music_app/features/playing/presentation/widgets/playing_page.dart';
import 'package:btl_music_app/features/playing/bloc/playing_bloc.dart';
import 'package:btl_music_app/features/playing/bloc/playing_event.dart';
import 'package:btl_music_app/features/playing/bloc/playing_state.dart';

class PlayingScreen extends StatefulWidget {
  const PlayingScreen({super.key});

  @override
  State<PlayingScreen> createState() => _PlayingScreenState();
}

class _PlayingScreenState extends State<PlayingScreen> {
  final PageController _controller = PageController();

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlayingBloc(),
      child: Consumer<PlayerProvider>(
        builder: (context, player, child) {
          final song = player.currentSong;
          if (song == null) {
            return const Scaffold(body: Center(child: Text('Không có bài hát')));
          }

          final imageUrl = song.thumbnail;

          return Scaffold(
            body: Stack(
              children: [
                // Background
                Positioned.fill(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.black),
                  ),
                ),

                // Blur
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                    child: Container(color: Colors.black.withOpacity(0.5)),
                  ),
                ),

                // PAGE VIEW
                Padding(
                  padding: const EdgeInsets.only(top: 120, bottom: 220),
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (i) {
                      context.read<PlayingBloc>().add(ChangePage(i));
                    },
                    children: [
                      PlayingPage(song: song),
                      LyricsPage(song: song),
                    ],
                  ),
                ),

                // HEADER
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                BlocBuilder<PlayingBloc, PlayingState>(
                                  builder: (context, state) {
                                    return Text(
                                      state.currentPage == 0 ? "Bài hát" : "Lời bài hát",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
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

                // DOT INDICATOR
                Positioned(
                  top: 95,
                  left: 0,
                  right: 0,
                  child: BlocBuilder<PlayingBloc, PlayingState>(
                    builder: (context, state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          dot(0, state.currentPage),
                          dot(1, state.currentPage),
                        ],
                      );
                    },
                  ),
                ),

                // BOTTOM CONTROLS
                PlayerControls(song: song, formatDuration: _formatDuration),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget dot(int index, int currentPage) {
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