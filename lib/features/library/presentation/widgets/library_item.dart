import 'package:flutter/material.dart';

class LibraryItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isLiked;
  final bool isDownload;
  final String? coverUrl;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool showOptions; // 👈 thêm cờ

  const LibraryItem({
    super.key,
    required this.title,
    this.subtitle,
    this.isLiked = false,
    this.isDownload = false,
    this.onTap,
    this.coverUrl,
    this.onDelete,
    this.showOptions = true, // mặc định có menu
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18, left: 16, right: 16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: isLiked || isDownload
                    ? const LinearGradient(
                        colors: [Colors.purple, Colors.blue],
                      )
                    : null,
                color: isLiked ? null : Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: coverUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        coverUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      isLiked
                          ? Icons.favorite
                          : isDownload
                              ? Icons.download
                              : Icons.add,
                      color: isLiked || isDownload ? Colors.white : Colors.white70,
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(subtitle!, style: const TextStyle(fontSize: 13)),
                  ],
                ],
              ),
            ),
            if (showOptions) // 👈 chỉ hiện khi true
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'delete' && onDelete != null) {
                    onDelete!();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Xóa'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
