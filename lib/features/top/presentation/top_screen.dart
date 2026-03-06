import 'package:btl_music_app/features/music/data/repo/song_repo.dart';
import 'package:btl_music_app/features/top/bloc/top_bloc.dart';
import 'package:btl_music_app/features/top/bloc/top_event.dart';
import 'package:btl_music_app/features/top/bloc/top_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/features/top/presentation/widgets/top_item.dart';
import '../../../core/widgets/mini_player.dart';
import '../../../core/widgets/bottom.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TopBloc(repository: context.read<SongRepository>())..add(LoadTopSongs()),
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
                /// HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        "#Top 99",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.pinkAccent,
                        ),
                      ),
                      Spacer(),
                      SizedBox(width: 12),
                      IconButton(
                        icon: Icon(Icons.search),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pushNamed(context, '/search');
                        },
                      ),
                    ],
                  ),
                ),

                /// LIST
                Expanded(
                  child: BlocBuilder<TopBloc, TopState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
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
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.topSongs.length,
                        itemBuilder: (context, index) {
                          final songModel = state.topSongs[index];
                          return ChartItem(
                            song: songModel,
                            rank: index + 1,
                            songId: songModel.id,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            MiniPlayer(),
            AppBottomNav(currentIndex: 2),
          ],
        ),
      ),
    );
  }
}