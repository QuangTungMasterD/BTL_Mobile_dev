import 'package:flutter/material.dart';

class LibraryItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isLiked;
  final bool isDownload;
  final VoidCallback? onTap;   // 👈 thêm cái này

  const LibraryItem({
    super.key,
    required this.title,
    this.subtitle,
    this.isLiked = false,
    this.isDownload = false,
    this.onTap,                // 👈 thêm
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(             // 👈 bọc bằng InkWell
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
            bottom: 18, left: 16, right: 16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: isLiked
                    ? const LinearGradient(
                        colors: [Colors.purple, Colors.blue],
                      )
                    : null,
                color: isLiked ? null : Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isLiked
                    ? Icons.favorite
                    : isDownload
                        ? Icons.download
                        : Icons.add,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ],
            )
          ],
        ),
      ),
    );
  }
}