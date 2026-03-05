import 'package:btl_music_app/core/providers/artist_provider.dart';
import 'package:btl_music_app/core/providers/song_provider.dart';
import 'package:btl_music_app/core/widgets/bottom.dart';
import 'package:btl_music_app/features/search/presentation/widgets/featured_tab.dart';
import 'package:btl_music_app/features/search/presentation/widgets/songs_tab.dart';
import 'package:btl_music_app/features/search/presentation/widgets/artists_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;
  const SearchResultScreen({super.key, required this.query});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _hasSearchedSongs = false;
  bool _hasSearchedArtists = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Tìm kiếm bài hát ngay từ đầu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasSearchedSongs) {
        _hasSearchedSongs = true;
        context.read<SongProvider>().searchSongs(widget.query);
      }
    });
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;

    // Tab Nghệ sĩ (index 2)
    if (_tabController.index == 2) {
      if (!_hasSearchedArtists) {
        _hasSearchedArtists = true;
        context.read<ArtistProvider>().searchArtists(widget.query);
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: TextEditingController(text: widget.query),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Tìm kiếm...",
          ),
          onTap: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Nổi bật"),
            Tab(text: "Bài hát"),
            Tab(text: "Nghệ sĩ"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FeaturedTab(query: widget.query),
          SongsTab(query: widget.query),
          ArtistsTab(query: widget.query),
        ],
      ),
      bottomNavigationBar: AppBottomNav(currentIndex: 0),
    );
  }
}