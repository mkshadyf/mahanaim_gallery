import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mahanaim_gallery/src/features/navigation/main_navigation.dart';
import 'features/shops/models/shop.dart';
import 'features/shops/models/tenant.dart';
import 'features/shops/views/add_rent_payment_view.dart';
import 'features/shops/views/add_tenant_view.dart';
import 'features/shops/views/shop_list_view.dart';
import 'features/shops/views/shop_details_view.dart';
import 'features/shops/views/add_shop_view.dart';
import 'features/shops/views/tenant_details_view.dart';
import 'features/shops/views/tenant_list_view.dart';
import 'features/shops/views/rent_payments_list_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'splash_screen.dart';

class MyApp extends StatelessWidget {
  final SettingsController settingsController;

  const MyApp({super.key, required this.settingsController});

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
          locale: settingsController.locale, // Apply the current locale

          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          initialRoute: '/splash',
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case '/splash':
                    return const SplashScreen();
                  case '/':
                    return MainNavigation(
                        settingsController: settingsController);

                  case '/shop_details':
                    return ShopDetailsView(
                        shop: routeSettings.arguments as Shop);
                  case '/add_shop':
                    return const AddShopView();
                  case '/tenant_list':
                    return const TenantListView();
                  case '/tenant_details':
                    return TenantDetailsView(
                        tenant: routeSettings.arguments as Tenant);
                  case '/add_tenant':
                    return const AddTenantView();
                  case '/add_rent_payment':
                    return const AddRentPaymentView();
                  case '/rent_payments_list':
                    return const RentPaymentsView();
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  default:
                    return const ShopListView();
                }
              },
            );
          },
        );
      },
    );
  }
}
