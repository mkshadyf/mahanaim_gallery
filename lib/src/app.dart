import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/dashboard/maindashboard.dart';
import 'features/shops/models/shop.dart';
import 'features/shops/models/tenant.dart';
import 'features/shops/views/add_shop_view.dart';
import 'features/shops/views/shop_list_view.dart';
import 'features/shops/views/shop_details_view.dart';
import 'features/shops/views/add_tenant_view.dart';
import 'features/shops/views/tenant_list_view.dart';
import 'features/shops/views/tenant_details_view.dart';
import 'features/auth/views/login_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
    required this.home,
  });

  final SettingsController settingsController;
  final Widget home;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('fr', ''),
            Locale('en', ''),            
          ],
          onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            iconTheme: const IconThemeData(color: Colors.blue),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
            ),
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.grey[900],
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
            ),
            iconTheme: IconThemeData(color: Colors.blue[300]),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: Colors.blue[300],
              unselectedItemColor: Colors.grey[400],
            ),
          ),
          themeMode: settingsController.themeMode,
          locale: settingsController.locale,
          home: home,
          routes: {
            '/dashboard': (context) => const MainDashboard(),
            '/add_shop': (context) => const AddShopView(),
            '/shop_list': (context) => const ShopListView(),
            '/add_tenant': (context) => const AddTenantView(),
            '/tenant_list': (context) => const TenantListView(),
            '/login': (context) => const LoginView(),
          },
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case '/shop_details':
                    final shop = routeSettings.arguments as Shop;
                    return ShopDetailsView(shop: shop);
                  case '/tenant_details':
                    final tenant = routeSettings.arguments as Tenant;
                    return TenantDetailsView(tenant: tenant);
                  default:
                    return const MainDashboard();
                }
              },
            );
          },
        );
      },
    );
  }
}
