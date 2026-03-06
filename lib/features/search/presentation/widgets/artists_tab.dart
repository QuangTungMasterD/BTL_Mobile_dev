// features/search/presentation/widgets/artists_tab.dart
import 'package:btl_music_app/features/search/bloc/search_result/search_bloc.dart';
import 'package:btl_music_app/features/search/bloc/search_result/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/features/artist/presentation/artist_songs_screen.dart';

class ArtistsTab extends StatelessWidget {
  const ArtistsTab({super.key});

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
          final results = state.artists;
          if (results.isEmpty) {
            return const Center(child: Text("Không tìm thấy nghệ sĩ nào"));
          }
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final artist = results[index];
              return ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: artist.avatarAr.isNotEmpty
                      ? NetworkImage(artist.avatarAr)
                      : null,
                  child: artist.avatarAr.isEmpty
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                title: Text(artist.name),
                subtitle: Text("Nghệ sĩ • ${artist.followerCount} quan tâm"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArtistSongsScreen(
                        artistId: artist.id,
                        artistName: artist.name,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}