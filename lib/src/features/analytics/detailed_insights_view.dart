import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shops/providers/shop_provider.dart';
import '../shops/providers/tenant_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailedInsightsView extends StatelessWidget {
  const DetailedInsightsView({super.key});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final tenantProvider = Provider.of<TenantProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.detailedInsightsTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInsightCard(
                context,
                localizations.revenueBreakdown,
                '\$${shopProvider.totalRevenue.toStringAsFixed(2)}',
                onTap: () => Navigator.pushNamed(context, '/revenue_breakdown'),
              ),
              _buildInsightCard(
                context,
                localizations.occupancyRate,
                '${(shopProvider.occupancyRate * 100).toStringAsFixed(1)}%',
                onTap: () => Navigator.pushNamed(context, '/shop_list'),
              ),
              _buildInsightCard(
                context,
                localizations.upcomingLeaseExpirations,
                tenantProvider.upcomingLeaseExpirations.toString(),
                onTap: () => Navigator.pushNamed(context, '/tenant_list'),
              ),
              _buildInsightCard(
                context,
                localizations.overduePayments,
                shopProvider.overduePayments.toString(),
                onTap: () => Navigator.pushNamed(context, '/overdue_payments'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsightCard(BuildContext context, String title, String value, {VoidCallback? onTap}) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ),
      ),
    );
  }
}
