import 'package:btl_music_app/features/notify/data/models/notification_model.dart';
import 'package:btl_music_app/features/notify/data/services/notification_service.dart';

class NotificationRepository {
  final NotificationService _service;

  NotificationRepository(this._service);

  Stream<List<NotificationModel>> getUserNotifications(String userId) => _service.getUserNotifications(userId);

  Future<void> sendNotification(String userId, NotificationModel notification) => _service.sendNotification(userId, notification);

  Future<void> markAsRead(String userId, String notifId) => _service.markAsRead(userId, notifId);

  Future<void> deleteNotification(String userId, String notifId) => _service.deleteNotification(userId, notifId);

  Future<void> markAllAsRead(String userId) => _service.markAllAsRead(userId);
}