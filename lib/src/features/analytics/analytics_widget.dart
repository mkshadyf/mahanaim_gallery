import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../shops/providers/shop_provider.dart';
import '../shops/providers/tenant_provider.dart';

class AnalyticsWidget extends StatelessWidget {
  const AnalyticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final tenantProvider = Provider.of<TenantProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations.analytics,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAnalyticItem(context, localizations.totalShops,
                    shopProvider.shops.length.toString()),
                _buildAnalyticItem(context, localizations.totalTenants,
                    tenantProvider.tenants.length.toString()),
                _buildAnalyticItem(context, localizations.totalRevenue,
                    shopProvider.totalRevenue.toString()),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAnalyticItem(context, localizations.occupancyRate,
                    _calculateOccupancyRate(shopProvider)),
                _buildAnalyticItem(context, localizations.onTimePaymentRate,
                    _calculateOnTimePaymentRate(shopProvider)),
                _buildAnalyticItem(context, localizations.latePaymentRate,
                    _calculateLatePaymentRate(shopProvider)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticItem(BuildContext context, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }

  String _calculateOccupancyRate(ShopProvider shopProvider) {
    final totalShops = shopProvider.shops.length;
    final occupiedShops =
        shopProvider.shops.where((shop) => shop.isOccupied).length;
    return ((occupiedShops / totalShops) * 100).toStringAsFixed(2) + '%';
  }

  String _calculateOnTimePaymentRate(ShopProvider shopProvider) {
    // Implement logic to calculate on-time payment rate
    return '90%'; // Placeholder value
  }

  String _calculateLatePaymentRate(ShopProvider shopProvider) {
    // Implement logic to calculate late payment rate
    return '10%'; // Placeholder value
  }
}
