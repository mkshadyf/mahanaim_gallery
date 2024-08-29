import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';

import '../shops/providers/shop_provider.dart';
import '../shops/providers/tenant_provider.dart';

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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations.revenueBreakdown, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            _buildRevenueChart(shopProvider),
            const SizedBox(height: 16),
            _buildOccupancyRate(shopProvider, localizations),
            const SizedBox(height: 16),
            _buildTenantTurnoverRate(tenantProvider, localizations),
            const SizedBox(height: 16),
            _buildPaymentPerformance(tenantProvider, localizations),
            const SizedBox(height: 16),
            _buildLeaseExpirations(tenantProvider, localizations),
            const SizedBox(height: 16),
            _buildTopPerformers(shopProvider, tenantProvider, localizations),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart(ShopProvider shopProvider) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX: 11,
          minY: 0,
          maxY: shopProvider.totalRevenue,
          lineBarsData: [
            LineChartBarData(
              spots: shopProvider.shops.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value.rentAmount);
              }).toList(),
              isCurved: true,
              color: Colors.blue,
               dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color  :Colors.blue.withOpacity(0.3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOccupancyRate(ShopProvider shopProvider, AppLocalizations localizations) {
    final occupancyRate = shopProvider.shops.where((shop) => !shop.isAvailable).length / shopProvider.shops.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${localizations.occupancyRate}: ${(occupancyRate * 100).toStringAsFixed(2)}%'),
        LinearProgressIndicator(value: occupancyRate),
      ],
    );
  }

  Widget _buildTenantTurnoverRate(TenantProvider tenantProvider, AppLocalizations localizations) {
    // This is a placeholder calculation. You'll need to implement actual turnover rate logic.
    const turnoverRate = 0.1;
    return Text('${localizations.tenantTurnoverRate}: ${(turnoverRate * 100).toStringAsFixed(2)}%');
  }

  Widget _buildPaymentPerformance(TenantProvider tenantProvider, AppLocalizations localizations) {
    // These are placeholder calculations. You'll need to implement actual payment performance logic.
    const onTimeRate = 0.9;
    const lateRate = 0.1;
    const outstandingBalance = 5000.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.paymentPerformance),
        Text('${localizations.onTimePaymentRate}: ${(onTimeRate * 100).toStringAsFixed(2)}%'),
        Text('${localizations.latePaymentRate}: ${(lateRate * 100).toStringAsFixed(2)}%'),
        Text('${localizations.outstandingBalance}: \$${outstandingBalance.toStringAsFixed(2)}'),
      ],
    );
  }

  Widget _buildLeaseExpirations(TenantProvider tenantProvider, AppLocalizations localizations) {
    final upcomingExpirations = tenantProvider.tenants.where((tenant) => tenant.contractEndDate.isBefore(DateTime.now().add(const Duration(days: 90)))).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.upcomingLeaseExpirations),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: upcomingExpirations.length,
          itemBuilder: (context, index) {
            final tenant = upcomingExpirations[index];
            return ListTile(
              title: Text(tenant.name),
              subtitle: Text('${localizations.expiresOn}: ${tenant.contractEndDate.toString()}'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTopPerformers(ShopProvider shopProvider, TenantProvider tenantProvider, AppLocalizations localizations) {
    final topShops = shopProvider.shops.take(5).toList();
    final topTenants = tenantProvider.tenants.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.topPerformingShops),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: topShops.length,
          itemBuilder: (context, index) {
            final shop = topShops[index];
            return ListTile(
              title: Text(shop.name),
              subtitle: Text('${localizations.revenue}: \$${shop.rentAmount.toStringAsFixed(2)}'),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(localizations.topPerformingTenants),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: topTenants.length,
          itemBuilder: (context, index) {
            final tenant = topTenants[index];
            return ListTile(
              title: Text(tenant.name),
              subtitle: Text('${localizations.monthlyRent}: \$${tenant.monthlyRent.toStringAsFixed(2)}'),
            );
          },
        ),
      ],
    );
  }
}
