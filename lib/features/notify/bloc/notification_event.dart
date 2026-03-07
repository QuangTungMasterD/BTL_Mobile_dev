import 'package:btl_music_app/features/notify/data/models/notification_model.dart';

abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {
  final String userId;
  LoadNotifications(this.userId);
}

class NotificationsUpdated extends NotificationEvent {
  final List<NotificationModel> notifications;
  final int unreadCount;
  NotificationsUpdated(this.notifications, this.unreadCount);
}

class MarkAsRead extends NotificationEvent {
  final String userId;
  final String notificationId;
  MarkAsRead(this.userId, this.notificationId);
}

class MarkAllAsRead extends NotificationEvent {
  final String userId;
  MarkAllAsRead(this.userId);
}
