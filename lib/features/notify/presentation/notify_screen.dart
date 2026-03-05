import 'package:btl_music_app/core/providers/notification_provider.dart';
import 'package:btl_music_app/features/notify/presentation/widgets/notify_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotifyScreen extends StatelessWidget {
  const NotifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Thông báo"),
        actions: [
          TextButton(
            onPressed: () {
              context.read<NotificationProvider>().markAllAsRead();
            },
            child: const Text("Đánh dấu đã đọc", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text("Lỗi: ${provider.error}"));
          }

          if (provider.notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("Không có thông báo nào", style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.notifications.length,
            itemBuilder: (context, index) {
              final notif = provider.notifications[index];
              return NotifyItem(
                notification: notif,
                onTap: () {
                  // Đánh dấu đã đọc khi bấm
                  provider.markAsRead(notif.id);
                  
                  // Sau này có thể mở chi tiết (bài hát, profile...)
                  // Ví dụ: nếu là like bài hát → mở bài hát đó
                },
              );
            },
          );
        },
      ),
    );
  }
}