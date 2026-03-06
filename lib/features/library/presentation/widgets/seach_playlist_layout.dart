import 'package:btl_music_app/core/widgets/song_item.dart';
import 'package:btl_music_app/features/music/data/models/song_model.dart';
import 'package:flutter/material.dart';

class SearchableSongList extends StatefulWidget {
  final List<SongModel> songs;
  final String title;
  final VoidCallback? onBackPressed;
  final Function(SongModel)? onSongTap;
  final Widget? trailing;

  const SearchableSongList({
    super.key,
    required this.songs,
    required this.title,
    this.onBackPressed,
    this.onSongTap,
    this.trailing,
  });

  @override
  State<SearchableSongList> createState() => _SearchableSongListState();
}

class _SearchableSongListState extends State<SearchableSongList> {
  late List<SongModel> _filteredSongs;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredSongs = widget.songs;
  }

  @override
  void didUpdateWidget(covariant SearchableSongList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.songs != oldWidget.songs) {
      _filteredSongs = widget.songs;
      _filterSearch();
    }
  }

  void _filterSearch() {
    final query = _searchQuery;
    if (query.isEmpty) {
      _filteredSongs = widget.songs;
    } else {
      _filteredSongs = widget.songs.where((song) {
        return song.title.toLowerCase().contains(query.toLowerCase()) ||
            song.artist.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    if (mounted) setState(() {});
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _filterSearch();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _onSearchChanged('');
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: _isSearching
              ? _buildSearchBar()
              : Row(
                  children: [
                    IconButton(
                      onPressed: widget.onBackPressed ?? () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleSearch,
                      icon: const Icon(Icons.search),
                    ),
                    if (widget.trailing != null) widget.trailing!,
                  ],
                ),
        ),

        // Danh sách bài hát
        Expanded(
          child: _filteredSongs.isEmpty
              ? Center(
                  child: Text(
                    _searchQuery.isEmpty
                        ? "Không có bài hát nào"
                        : "Không tìm thấy bài hát nào",
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  itemCount: _filteredSongs.length,
                  itemBuilder: (context, index) {
                    final song = _filteredSongs[index];
                    return SongItem(
                      title: song.title,
                      artist: song.artist,
                      image: song.thumbnail,
                      songId: song.id,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _toggleSearch,
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Tìm bài hát...',
                border: InputBorder.none,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            ),
        ],
      ),
    );
  }
}