import 'dart:async';

import 'package:btl_music_app/features/notify/data/repo/notification_repo.dart';
import 'package:flutter/material.dart';
import 'package:btl_music_app/features/notify/data/models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _repo;
  final String userId;
  StreamSubscription? _subscription;

  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _error;

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  NotificationProvider(this._repo, this.userId) {
    if (userId.isNotEmpty) {
      loadNotifications();
    } else {
      _error = "Vui lòng đăng nhập để xem thông báo";
      notifyListeners();
    }
  }

  void loadNotifications() {
    _subscription?.cancel();
    _isLoading = true;
    notifyListeners();

    _subscription = _repo
        .getUserNotifications(userId)
        .listen(
          (notifications) {
            _notifications = notifications;
            _unreadCount = notifications.where((notif) => !notif.isRead).length;
            _isLoading = false;
            notifyListeners();
          },
          onError: (e) {
            _error = e.toString();
            _isLoading = false;
            notifyListeners();
          },
        );
  }

  Future<void> markAsRead(String notifId) async {
    await _repo.markAsRead(userId, notifId);
  }

  Future<void> markAllAsRead() async {
    await _repo.markAllAsRead(userId);
  }

  Future<void> deleteNotification(String notifId) async {
    await _repo.deleteNotification(userId, notifId);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
