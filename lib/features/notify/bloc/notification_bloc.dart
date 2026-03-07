import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btl_music_app/features/notify/data/repo/notification_repo.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;
  StreamSubscription? _subscription;
  String? _currentUserId;

  NotificationBloc({required NotificationRepository repository})
      : _repository = repository,
        super(NotificationState()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<NotificationsUpdated>(_onNotificationsUpdated);
    on<MarkAsRead>(_onMarkAsRead);
    on<MarkAllAsRead>(_onMarkAllAsRead);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    _currentUserId = event.userId;
    print(_currentUserId);
    if (_currentUserId == null || _currentUserId!.isEmpty) {
      emit(state.copyWith(notifications: [], isLoading: false, error: null));
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));
    _subscription?.cancel();

    _subscription = _repository.getUserNotifications(_currentUserId!).listen(
      (notifications) {
        final unreadCount = notifications.where((n) => !n.isRead).length;
        add(NotificationsUpdated(notifications, unreadCount));
      },
      onError: (error) {
        add(NotificationsUpdated([], 0));
      },
    );
  }

  void _onNotificationsUpdated(
    NotificationsUpdated event,
    Emitter<NotificationState> emit,
  ) {
    emit(state.copyWith(
      notifications: event.notifications,
      unreadCount: event.unreadCount,
      isLoading: false,
      error: null,
    ));
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    _currentUserId = event.userId;
    if (_currentUserId == null || _currentUserId!.isEmpty) return;
    try {
      await _repository.markAsRead(_currentUserId!, event.notificationId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    _currentUserId = event.userId;
    if (_currentUserId == null || _currentUserId!.isEmpty) return;
    try {
      await _repository.markAllAsRead(_currentUserId!);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}