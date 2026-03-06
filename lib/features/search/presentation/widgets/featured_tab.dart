// features/search/presentation/widgets/featured_tab.dart
import 'package:btl_music_app/features/search/bloc/search_result/search_bloc.dart';
import 'package:btl_music_app/features/search/bloc/search_result/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/core/widgets/song_item.dart';

class FeaturedTab extends StatelessWidget {
  const FeaturedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SearchError) {
          return Center(child: Text('Lỗi: ${state.message}'));
        }
        if (state is SearchLoaded) {
          final results = state.songs;
          if (results.isEmpty) {
            return const Center(child: Text("Không tìm thấy kết quả nổi bật"));
          }
          // Sắp xếp theo playCount giảm dần
          final featured = List.of(results)
            ..sort((a, b) => b.playCount.compareTo(a.playCount));
          final topFeatured = featured.take(10).toList();

          return ListView.builder(
            itemCount: topFeatured.length,
            itemBuilder: (context, index) {
              final song = topFeatured[index];
              return SongItem(
                songId: song.id,
                title: song.title,
                artist: song.artist,
                image: song.thumbnail,
              );
            },
          );
        }
        // SearchInitial
        return const SizedBox.shrink();
      },
    );
  }
}