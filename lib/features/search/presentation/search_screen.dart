// features/search/presentation/search_landing_screen.dart
import 'package:btl_music_app/features/search/bloc/search/search_landing_bloc.dart';
import 'package:btl_music_app/features/search/bloc/search/search_landing_event.dart';
import 'package:btl_music_app/features/search/bloc/search/search_landing_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/core/widgets/bottom.dart';
import 'package:btl_music_app/core/widgets/mini_player.dart';
import 'package:btl_music_app/features/search/presentation/search_result_screen.dart';

class SearchLandingScreen extends StatefulWidget {
  const SearchLandingScreen({super.key});

  @override
  State<SearchLandingScreen> createState() => _SearchLandingScreenState();
}

class _SearchLandingScreenState extends State<SearchLandingScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Gửi event LoadHistory khi vào màn hình (bloc đã được cung cấp từ ancestors)
    context.read<SearchLandingBloc>().add(LoadHistory());
  }

  Future<void> _goToResult(String query) async {
    if (query.trim().isEmpty) return;

    // Gửi event AddSearchQuery để lưu và cập nhật lịch sử
    context.read<SearchLandingBloc>().add(AddSearchQuery(query.trim()));

    // Điều hướng sang màn hình kết quả
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SearchResultScreen(query: query)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: TextField(
          controller: _controller,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
          enableSuggestions: true,
          autocorrect: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: "Tìm kiếm bài hát, nghệ sĩ...",
            contentPadding: const EdgeInsets.only(top: 12),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () => _goToResult(_controller.text),
            ),
          ),
          onSubmitted: _goToResult,
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
            BlocBuilder<SearchLandingBloc, SearchLandingState>(
              builder: (context, state) {
                if (state.isLoading && state.history.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.error != null) {
                  return Center(child: Text('Lỗi: ${state.error}'));
                }
                final history = state.history;
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: history.map((e) {
                    return GestureDetector(
                      onTap: () => _goToResult(e),
                      child: Chip(label: Text(e)),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [MiniPlayer(), AppBottomNav(currentIndex: 1)],
      ),
    );
  }
}