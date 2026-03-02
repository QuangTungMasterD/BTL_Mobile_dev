import 'package:btl_music_app/core/widgets/bottom.dart';
import 'package:btl_music_app/features/search/presentation/search_result_screen.dart';
import 'package:flutter/material.dart';

class SearchLandingScreen extends StatefulWidget {
  const SearchLandingScreen({super.key});

  @override
  State<SearchLandingScreen> createState() => _SearchLandingScreenState();
}

class _SearchLandingScreenState extends State<SearchLandingScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<String> historySearch = [
    "thiệp hồng sai tên",
    "vạn sự như ý",
    "50 năm về sau",
    "#zingchart",
    "workout",
    "thư giãn"
  ];

  void _goToResult(String query) {
    if (query.trim().isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultScreen(query: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TextField(
          controller: _controller,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: "Tìm kiếm bài hát, nghệ sĩ...",
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            _goToResult(value);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tìm kiếm gần đây",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: historySearch.map((e) {
                return GestureDetector(
                  onTap: () {
                    _goToResult(e);
                  },
                  child: Chip(label: Text(e)),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
      ),
    );
  }
}