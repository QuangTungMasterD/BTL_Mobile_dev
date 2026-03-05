import 'package:btl_music_app/core/database/database_helper.dart';
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
  List<String> historySearch = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final recent = await DatabaseHelper.instance.getRecentSearches(limit: 10);
    setState(() {
      historySearch = recent;
    });
  }

  Future<void> _goToResult(String query) async {
    if (query.trim().isEmpty) return;

    // Lưu query vào SQLite
    await DatabaseHelper.instance.addSearchQuery(query.trim());

    // Load lại lịch sử để cập nhật UI
    await _loadHistory();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SearchResultScreen(query: query)),
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
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          enableSuggestions: true,
          autocorrect: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: "Tìm kiếm bài hát, nghệ sĩ...",
            border: InputBorder.none,
            // Thêm icon tìm kiếm ở bên phải
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {
                // Khi bấm icon → gọi tìm kiếm giống như Enter
                _goToResult(_controller.text);
              },
            ),
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
      bottomNavigationBar: AppBottomNav(currentIndex: 0),
    );
  }
}