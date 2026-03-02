import 'package:btl_music_app/features/comment/presentation/widgets/comment_input.dart';
import 'package:btl_music_app/features/comment/presentation/widgets/comment_list.dart';
import 'package:flutter/material.dart';

class CommentSheet extends StatelessWidget {
  const CommentSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [

          /// ===== DRAG HANDLE =====
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          /// ===== HEADER =====
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "Bình luận",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const Divider(color: Colors.white12),

          /// ===== LIST COMMENT =====
          const Expanded(
            child: CommentList(),
          ),

          /// ===== INPUT =====
          const CommentInput(),
        ],
      ),
    );
  }
}