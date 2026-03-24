import 'package:btl_music_app/core/providers/player_provider.dart';
import 'package:btl_music_app/features/top/presentation/widgets/top_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/features/music/data/repo/song_repo.dart';
import 'package:btl_music_app/features/top/bloc/top_bloc.dart';
import 'package:btl_music_app/features/top/bloc/top_event.dart';
import 'package:btl_music_app/features/top/bloc/top_state.dart';
import 'package:btl_music_app/features/top/presentation/widgets/top_item.dart';
import '../../../core/widgets/mini_player.dart';
import '../../../core/widgets/bottom.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TopBloc(repository: context.read<SongRepository>())
            ..add(LoadTopSongs()),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3E1F5F), Color(0xFF1B0F2E)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        "#Top 99",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/search'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocListener<TopBloc, TopState>(
                    listener: (context, state) {
                      // Khi tải xong và có dữ liệu, set playlist
                      if (!state.isLoading && state.topSongs.isNotEmpty) {
                        final player = context.read<PlayerProvider>();
                        player.setPlaylist(state.topSongs, startIndex: 0);
                      }
                    },
                    child: BlocBuilder<TopBloc, TopState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state.error != null) {
                          return Center(
                            child: Text(
                              'Lỗi: ${state.error}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }
                        if (state.topSongs.isEmpty) {
                          return const Center(
                            child: Text(
                              'Không có dữ liệu',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }
                        return ListView(
                          children: [
                            if (state.topSongs.isNotEmpty)
                              TopChartIndicator(
                                topSongs: state.topSongs.take(10).toList(),
                              ),
                            const SizedBox(height: 16),
                            ...state.topSongs.map((song) {
                              final index = state.topSongs.indexOf(song);
                              return ChartItem(
                                song: song,
                                rank: index + 1,
                                songId: song.id,
                              );
                            }).toList(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [MiniPlayer(), AppBottomNav(currentIndex: 2)],
        ),
      ),
    );
  }
}
