import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shops/providers/shop_provider.dart';
import '../shops/providers/tenant_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AnalyticsWidget extends StatelessWidget {
  const AnalyticsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final tenantProvider = Provider.of<TenantProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.analyticsTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAnalyticItem(
                  context,
                  localizations.totalShops,
                  shopProvider.shops.length.toString(),
                  onTap: () => Navigator.pushNamed(context, '/shop_list'),
                ),
                _buildAnalyticItem(
                  context,
                  localizations.totalTenants,
                  tenantProvider.tenants.length.toString(),
                  onTap: () => Navigator.pushNamed(context, '/tenant_list'),
                ),
                _buildAnalyticItem(
                  context,
                  localizations.totalRevenue,
                  '\$${shopProvider.totalRevenue.toStringAsFixed(2)}',
                  onTap: () => Navigator.pushNamed(context, '/detailed_insights'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticItem(BuildContext context, String label, String value, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }
}
