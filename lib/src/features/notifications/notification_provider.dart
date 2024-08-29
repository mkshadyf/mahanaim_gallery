import 'package:flutter/material.dart';
import 'package:mahanaim_gallery/src/features/notifications/notification_service.dart';
import 'package:mahanaim_gallery/src/features/notifications/notification_repository.dart';
import 'package:mahanaim_gallery/src/features/notifications/models/notification.dart' as app_notification;
 
class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  final NotificationRepository _notificationRepository = NotificationRepository();
  List<app_notification.Notification> _notifications = [];
  int _unreadCount = 0;

  List<app_notification.Notification> get notifications => _notifications;
  List<app_notification.Notification> get recentNotifications => _notifications.take(5).toList();
  int get unreadCount => _unreadCount;

  Future<void> initialize() async {
    await _notificationService.initialize();
    await _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    _notifications = await _notificationRepository.getNotifications();
    _unreadCount = _notifications.where((n) => !n.isRead).length;
    notifyListeners();
  }

  Future<void> showNotification(String title, String body) async {
    await _notificationService.showNotification(title, body);
    await _addNotification(title, body);
  }

  Future<void> scheduleNotification(String title, String body, DateTime scheduledDate) async {
    await _notificationService.scheduleNotification(title, body, scheduledDate);
    await _addNotification(title, body, scheduledDate: scheduledDate);
  }

  Future<void> _addNotification(String title, String body, {DateTime? scheduledDate}) async {
    final notification = app_notification.Notification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      timestamp: scheduledDate ?? DateTime.now(),
      isRead: false,
    );
    await _notificationRepository.addNotification(notification);
    _notifications.insert(0, notification);
    _unreadCount++;
    notifyListeners();
  }

  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      await _notificationRepository.updateNotification(_notifications[index]);
      _unreadCount = _unreadCount > 0 ? _unreadCount - 1 : 0;
      notifyListeners();
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    await _notificationRepository.deleteNotification(notificationId);
    _notifications.removeWhere((n) => n.id == notificationId);
    _unreadCount = _notifications.where((n) => !n.isRead).length;
    notifyListeners();
  }

  Future<void> sendSMS(String message, String phoneNumber) async {
    // Implement SMS sending logic here
    // You can use a package like flutter_sms or twilio for this
    print('Sending SMS to $phoneNumber: $message');
  }

  Future<void> sendEmail(String subject, String body, String email) async {
    // Implement email sending logic here
    // You can use a package like mailer for this
    print('Sending email to $email: $subject - $body');
  }
}
