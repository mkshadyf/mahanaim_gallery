import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notification_provider.dart';

class NotificationListView extends StatelessWidget {
  const NotificationListView({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.builder(
        itemCount: notificationProvider.notifications.length,
        itemBuilder: (context, index) {
          final notification = notificationProvider.notifications[index];
          return ListTile(
            title: Text(notification.title),
            subtitle: Text(notification.body),
            trailing: Text(notification.timestamp.toString()),
          );
        },
      ),
    );
  }
}
