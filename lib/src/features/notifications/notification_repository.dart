import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahanaim_gallery/src/features/notifications/models/notification.dart';
 
class NotificationRepository {
  final CollectionReference _notificationsCollection =
      FirebaseFirestore.instance.collection('notifications');

  Future<List<Notification>> getNotifications() async {
    QuerySnapshot querySnapshot = await _notificationsCollection.orderBy('timestamp', descending: true).get();
    return querySnapshot.docs
        .map((doc) => Notification.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addNotification(Notification notification) async {
    await _notificationsCollection.doc(notification.id).set(notification.toMap());
  }

  Future<void> updateNotification(Notification notification) async {
    await _notificationsCollection.doc(notification.id).update(notification.toMap());
  }

  Future<void> deleteNotification(String notificationId) async {
    await _notificationsCollection.doc(notificationId).delete();
  }
}
