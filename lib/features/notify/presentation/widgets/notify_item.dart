import 'package:btl_music_app/features/notify/data/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotifyItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;  // Để mark read hoặc mở chi tiết

  const NotifyItem({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                notification.imageUrl ?? '',
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 72,
                  height: 72,
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.music_note, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${notification.body} • ${_formatTime(notification.createdAt)}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Chấm đỏ nếu chưa đọc (thêm nhỏ, không ảnh hưởng thiết kế)
            if (!notification.isRead)
              const Padding(
                padding: EdgeInsets.only(left: 8, top: 4),
                child: Icon(Icons.fiber_new, color: Colors.red, size: 20),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inDays > 0) return "${diff.inDays} ngày";
    if (diff.inHours > 0) return "${diff.inHours} giờ";
    if (diff.inMinutes > 0) return "${diff.inMinutes} phút";
    return "Vừa xong";
  }
}