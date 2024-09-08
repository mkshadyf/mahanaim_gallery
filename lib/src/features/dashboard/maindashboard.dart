import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shops/providers/shop_provider.dart';
import '../shops/providers/tenant_provider.dart';
import '../analytics/analytics_widget.dart';
import '../notifications/views/notification_list_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final tenantProvider = Provider.of<TenantProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.dashboardTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationListView()),
              );
            },
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
                localizations.recentShops,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              _buildRecentShopsList(context, shopProvider),
              const SizedBox(height: 24),
              Text(
                localizations.recentTenants,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              _buildRecentTenantsList(context, tenantProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentShopsList(BuildContext context, ShopProvider shopProvider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: shopProvider.shops.take(5).length,
      itemBuilder: (context, index) {
        final shop = shopProvider.shops[index];
        return ListTile(
          title: Text(shop.name),
          subtitle: Text(shop.description),
          onTap: () {
            Navigator.pushNamed(context, '/shop_details', arguments: shop);
          },
        );
      },
    );
  }

  Widget _buildRecentTenantsList(BuildContext context, TenantProvider tenantProvider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tenantProvider.tenants.take(5).length,
      itemBuilder: (context, index) {
        final tenant = tenantProvider.tenants[index];
        return ListTile(
          title: Text(tenant.name),
          subtitle: Text(tenant.email),
          onTap: () {
            Navigator.pushNamed(context, '/tenant_details', arguments: tenant);
          },
        );
      },
    );
  }
}
