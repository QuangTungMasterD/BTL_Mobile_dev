import 'package:btl_music_app/features/artist/bloc/artist_songs_bloc.dart';
import 'package:btl_music_app/features/artist/bloc/artist_songs_event.dart';
import 'package:btl_music_app/features/artist/bloc/artist_songs_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/features/music/data/repo/artist_repo.dart';
import 'package:btl_music_app/features/music/data/repo/song_repo.dart';
import 'package:btl_music_app/core/widgets/song_item.dart';

class ArtistSongsScreen extends StatelessWidget {
  final String artistId;
  final String artistName;

  const ArtistSongsScreen({
    super.key,
    required this.artistId,
    required this.artistName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ArtistSongsBloc(
        artistRepo: context.read<ArtistRepository>(),
        songRepo: context.read<SongRepository>(),
      )..add(LoadArtistSongs(artistId)),
      child: const ArtistSongsView(),
    );
  }
}

class ArtistSongsView extends StatelessWidget {
  const ArtistSongsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtistSongsBloc, ArtistSongsState>(
      builder: (context, state) {
        if (state is ArtistSongsLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is ArtistSongsError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(state.message)),
          );
        }
        if (state is ArtistSongsLoaded) {
          final artist = state.artist;
          final songs = state.songs;
          final coverUrl = artist.avatar;
          final hasCover = coverUrl != null && coverUrl.isNotEmpty;

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: hasCover
                        ? Image.network(
                            coverUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade900,
                              child: const Icon(Icons.person, size: 80, color: Colors.white54),
                            ),
                          )
                        : Container(
                            color: Colors.grey.shade900,
                            child: const Icon(Icons.person, size: 80, color: Colors.white54),
                          ),
                  ),
                  actions: const [
                    IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: null,
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          artist.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Nghệ sĩ • ${songs.length} bài hát',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: phát ngẫu nhiên
                              },
                              icon: const Icon(Icons.shuffle),
                              label: const Text('Phát ngẫu nhiên'),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: () {
                                // TODO: thích / bỏ thích
                              },
                              icon: const Icon(Icons.favorite_border),
                              label: const Text('Thích'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ...songs.asMap().entries.map((entry) {
                          final index = entry.key + 1;
                          final song = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                  child: Text(
                                    '$index',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  child: SongItem(
                                    songId: song.id,
                                    title: song.title,
                                    artist: song.artist,
                                    image: song.thumbnail,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}