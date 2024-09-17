import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/app.dart';
import 'src/features/auth/auth_provider.dart';
import 'src/features/notifications/notification_provider.dart';
import 'src/features/shops/providers/shop_provider.dart';
import 'src/features/shops/providers/tenant_provider.dart';
import 'src/features/shops/providers/payment_provider.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final notificationProvider = NotificationProvider();
  await notificationProvider.initialize();

  final authProvider = AuthProvider();
  final shopProvider = ShopProvider();
  final tenantProvider = TenantProvider();
  final paymentProvider = PaymentProvider();

  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => notificationProvider),
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => shopProvider),
        ChangeNotifierProvider(create: (_) => tenantProvider),
        ChangeNotifierProvider(create: (_) => paymentProvider),
        ChangeNotifierProvider.value(value: settingsController),
      ],
      child: MyApp(
        settingsController: settingsController,
      ),
    ),
  );
}
