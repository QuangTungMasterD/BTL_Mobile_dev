import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:btl_music_app/features/notify/data/models/notification_model.dart';

class NotificationService {
  Future<void> sendNotification(String userId, NotificationModel notification) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .add(notification.toJson());
  }

  Stream<List<NotificationModel>> getUserNotifications(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => NotificationModel.fromJson(doc.data(), doc.id)).toList());
  }

  Future<void> markAsRead(String userId, String notifId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notifId)
        .update({'isRead': true});
  }

  Future<void> deleteNotification(String userId, String notifId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notifId)
        .delete();
  }

  Future<void> markAllAsRead(String userId) async {
    final batch = FirebaseFirestore.instance.batch();
    final notifications = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in notifications.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }
}