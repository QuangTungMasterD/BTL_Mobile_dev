import 'package:btl_music_app/core/providers/artist_provider.dart';
import 'package:btl_music_app/features/artist/presentation/artist_songs_screen.dart';
import 'package:btl_music_app/features/music/data/models/artist_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtistsTab extends StatelessWidget {
  final String query;
  const ArtistsTab({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Consumer<ArtistProvider>(
      builder: (context, artistProvider, child) {
        // KHÔNG gọi search ở đây → đã gọi từ màn hình chính
        if (artistProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (artistProvider.error != null) {
          return Center(child: Text("Lỗi: ${artistProvider.error}"));
        }

        final results = artistProvider.searchResults;

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
                backgroundImage: NetworkImage(artist.avatarAr),
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
      },
    );
  }
}
