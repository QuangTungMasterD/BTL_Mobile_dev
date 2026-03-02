import 'package:btl_music_app/core/widgets/bottom.dart';
import 'package:flutter/material.dart';

class SearchResultScreen extends StatelessWidget {
  final String query;
  const SearchResultScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: TextEditingController(text: query),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Tìm kiếm...",
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Nổi bật"),
              Tab(text: "Bài hát"),
              Tab(text: "Playlist"),
              Tab(text: "Nghệ sĩ"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ResultList(),
            _ResultList(),
            _ResultPlaylist(),
            _ResultArtist(),
          ],
        ),
        bottomNavigationBar: AppBottomNav(currentIndex: 0),
      ),
    );
  }
}

class _ResultPlaylist extends StatelessWidget {
  const _ResultPlaylist();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (_, index) {
        return ListTile(
          leading: Container(
            width: 55,
            height: 55,
          ),
          title: const Text(
            "Thiệp Hồng Sai Tên (Single)",
          ),
          subtitle: const Text(
            "DIMZ",
          ),
          trailing: const Icon(Icons.chevron_right),
        );
      },
    );
  }
}

class _ResultArtist extends StatelessWidget {
  const _ResultArtist();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (_, index) {
        return ListTile(
          leading: const CircleAvatar(
            radius: 25,
          ),
          title: const Text(
            "Nguyễn Thành Đạt",
          ),
          subtitle: const Text(
            "Nghệ sĩ • 3,8K quan tâm",
          ),
          trailing: const Icon(Icons.chevron_right),
        );
      },
    );
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (_, index) {
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.music_note)),
          title: Text("Thiên Lý Ơi $index"),
          subtitle: const Text("Jack - J97"),
          trailing: const Icon(Icons.more_vert),
        );
      },
    );
  }
}