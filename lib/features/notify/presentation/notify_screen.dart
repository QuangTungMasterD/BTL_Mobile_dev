import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/core/providers/auth_provider.dart';
import 'package:btl_music_app/features/notify/bloc/notification_bloc.dart';
import 'package:btl_music_app/features/notify/bloc/notification_event.dart';
import 'package:btl_music_app/features/notify/bloc/notification_state.dart';
import 'package:btl_music_app/features/notify/data/repo/notification_repo.dart';
import 'package:btl_music_app/features/notify/presentation/widgets/notify_item.dart';

class NotifyScreen extends StatelessWidget {
  const NotifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthUserProvider>();
    final userId = authProvider.user?.uid ?? '';

    return BlocProvider(
      create: (context) => NotificationBloc(
        repository: context.read<NotificationRepository>(),
      )..add(LoadNotifications(userId)),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Thông báo"),
          actions: [
            TextButton(
              onPressed: () {
                context.read<NotificationBloc>().add(MarkAllAsRead(userId));
              },
              child: const Text("Đánh dấu đã đọc", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return Center(child: Text("Lỗi: ${state.error}"));
            }
            if (state.notifications.isEmpty) {
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
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notif = state.notifications[index];
                return NotifyItem(
                  notification: notif,
                  onTap: () {
                    context.read<NotificationBloc>().add(MarkAsRead(userId, notif.id));
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}