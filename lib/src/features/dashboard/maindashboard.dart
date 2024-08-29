import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../notifications/notification_provider.dart';
  import '../analytics/analytics_widget.dart';
import '../notifications/views/notification_list_view.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
     final notificationProvider = Provider.of<NotificationProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.dashboardTitle),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationListView()),
                  );
                },
              ),
              if (notificationProvider.unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '${notificationProvider.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'login':
                  Navigator.pushNamed(context, '/login');
                  break;
                case 'register':
                  Navigator.pushNamed(context, '/register');
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'login',
                child: Text(localizations.loginTitle),
              ),
              PopupMenuItem<String>(
                value: 'register',
                child: Text(localizations.registerTitle),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AnalyticsWidget(),
              const SizedBox(height: 24),
              Text(
                localizations.recentNotificationsTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: notificationProvider.recentNotifications.length,
                itemBuilder: (context, index) {
                  final notification = notificationProvider.recentNotifications[index];
                  return ListTile(
                    title: Text(notification.title),
                    subtitle: Text(notification.body),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Handle notification tap
                    },
                  );
                },
              ),
              if (notificationProvider.recentNotifications.length >= 5)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationListView()),
                    );
                  },
                  child: Text(localizations.viewAllNotificationsButton),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_shop');
        },
        tooltip: localizations.addShopTooltip,
        child: const Icon(Icons.add),
      ),
    );
  }
}
