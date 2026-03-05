import 'package:btl_music_app/core/providers/artist_provider.dart';
import 'package:btl_music_app/core/providers/song_provider.dart';
import 'package:btl_music_app/core/widgets/song_item.dart';
import 'package:btl_music_app/features/music/data/models/artist_model.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtistSongsScreen extends StatefulWidget {
  final String artistId;
  final String artistName;

  const ArtistSongsScreen({
    super.key,
    required this.artistId,
    required this.artistName,
  });

  @override
  State<ArtistSongsScreen> createState() => _ArtistSongsScreenState();
}

class _ArtistSongsScreenState extends State<ArtistSongsScreen> {
  ArtistModel? _artist;
  List<SongModel> _songs = [];
  bool _isLoadingArtist = true;
  bool _isLoadingSongs = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final artistProvider = context.read<ArtistProvider>();
      final artist = artistProvider.allArtists.firstWhere(
        (a) => a.id == widget.artistId,
        orElse: () => throw Exception('Không tìm thấy nghệ sĩ'),
      );
      setState(() {
        _artist = artist;
        _isLoadingArtist = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoadingArtist = false;
      });
    }

    try {
      final songProvider = context.read<SongProvider>();
      final songs = await songProvider.getSongsByArtistId(widget.artistId);
      setState(() {
        _songs = songs;
        _isLoadingSongs = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoadingSongs = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingArtist || _isLoadingSongs) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _artist == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(_error ?? 'Không tìm thấy nghệ sĩ')),
      );
    }

    final artist = _artist!;
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
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Text(
                    artist.name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                    'Nghệ sĩ • ${_songs.length} bài hát',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  ),
                  const SizedBox(height: 20),
                  ..._songs.asMap().entries.map((entry) {
                    final song = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: 
                          Expanded(
                            child: SongItem(
                              songId: song.id,
                              title: song.title,
                              artist: song.artist,
                              image: song.thumbnail,
                            ),
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
}