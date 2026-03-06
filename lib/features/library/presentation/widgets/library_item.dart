import 'package:flutter/material.dart';

class LibraryItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isLiked;
  final bool isDownload;
  final String? coverUrl;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool showOptions;
  final bool isGrid; // true nếu hiển thị dạng lưới

  const LibraryItem({
    super.key,
    required this.title,
    this.subtitle,
    this.isLiked = false,
    this.isDownload = false,
    this.coverUrl,
    this.onTap,
    this.onDelete,
    this.showOptions = true,
    this.isGrid = false,
  });

  // Widget hiển thị ảnh (chung cho cả hai chế độ)
  Widget _buildImage({double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: (isLiked || isDownload) && coverUrl == null
            ? const LinearGradient(
                colors: [Colors.purple, Colors.blue],
              )
            : null,
        color: coverUrl == null && !isLiked && !isDownload
            ? Colors.grey.shade900
            : null,
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
              color: (isLiked || isDownload) ? Colors.white : Colors.white70,
            ),
    );
  }

  // Hiển thị menu xóa (PopupMenuButton)
  Widget _buildOptionsMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 20),
      onSelected: (value) {
        if (value == 'delete' && onDelete != null) {
          // Hiển thị dialog xác nhận
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Xóa playlist'),
              content: Text('Bạn có chắc muốn xóa "$title"?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    onDelete!();
                  },
                  child: const Text('Xóa'),
                ),
              ],
            ),
          );
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'delete',
          child: Text('Xóa'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isGrid) {
      // Chế độ lưới
      return InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ảnh chiếm phần lớn phía trên
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: _buildImage(width: double.infinity, height: double.infinity),
                ),
              ),
              // Phần dưới: tên playlist, số bài hát và nút 3 chấm
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Dòng tên playlist
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      // Dòng số bài hát và nút 3 chấm
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              subtitle ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).textTheme.bodySmall?.color,
                              ),
                            ),
                          ),
                          if (showOptions && onDelete != null)
                            _buildOptionsMenu(context),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18, left: 16, right: 16),
        child: Row(
          children: [
            _buildImage(width: 60, height: 60),
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
            if (showOptions && onDelete != null) _buildOptionsMenu(context),
          ],
        ),
      ),
    );
  }
}