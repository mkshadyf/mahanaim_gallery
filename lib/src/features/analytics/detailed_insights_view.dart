import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../features/shops/providers/shop_provider.dart';
import '../../features/shops/providers/tenant_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailedInsightsView extends StatefulWidget {
  const DetailedInsightsView({super.key});

  @override
  State<DetailedInsightsView> createState() => _DetailedInsightsViewState();
}

class _DetailedInsightsViewState extends State<DetailedInsightsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShopProvider>(context, listen: false).loadShops();
      Provider.of<TenantProvider>(context, listen: false).loadTenants();
    });
  }

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
              // Occupancy Rate
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.occupancyRate,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: SizedBox(
                          height: 200,
                          child: SfCircularChart(
                            series: <CircularSeries>[
                              DoughnutSeries<ChartData, String>(
                                dataSource: [
                                  ChartData(localizations.occupied, shopProvider.shops.where((shop) => shop.isOccupied).length.toDouble()),
                                  ChartData(localizations.vacant, shopProvider.shops.where((shop) => !shop.isOccupied).length.toDouble()),
                                ],
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                dataLabelSettings: const DataLabelSettings(isVisible: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Revenue Breakdown
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.revenueBreakdown,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: SizedBox(
                          height: 200,
                          child: SfCartesianChart(
                            primaryXAxis: const CategoryAxis(),
                            series: <ChartSeries>[
                              ColumnSeries<ChartData, String>(
                                dataSource: [
                                  ChartData(localizations.rent, shopProvider.shops.fold(0.0, (sum, shop) => sum + shop.rentAmount)),
                                  ChartData(localizations.lease, shopProvider.shops.fold(0.0, (sum, shop) => sum + shop.leaseAmount)),
                                ],
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                dataLabelSettings: const DataLabelSettings(isVisible: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Upcoming Lease Expirations
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.upcomingLeaseExpirations,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      if (shopProvider.shops.where((shop) => shop.contractEndDate != null && shop.contractEndDate!.isAfter(DateTime.now())).isEmpty)
                        Center(
                          child: Text(localizations.noUpcomingLeaseExpirations),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: shopProvider.shops.where((shop) => shop.contractEndDate != null && shop.contractEndDate!.isAfter(DateTime.now())).length,
                          itemBuilder: (context, index) {
                            final shop = shopProvider.shops.where((shop) => shop.contractEndDate != null && shop.contractEndDate!.isAfter(DateTime.now())).toList()[index];
                            return ListTile(
                              title: Text(shop.name),
                              subtitle: Text('${localizations.endDate}: ${shop.contractEndDate}'),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Overdue Payments
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.overduePayments,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      if (shopProvider.shops.where((shop) => shop.isPaymentOverdue()).isEmpty)
                        Center(
                          child: Text(localizations.noOverduePayments),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: shopProvider.shops.where((shop) => shop.isPaymentOverdue()).length,
                          itemBuilder: (context, index) {
                            final shop = shopProvider.shops.where((shop) => shop.isPaymentOverdue()).toList()[index];
                            return ListTile(
                              title: Text(shop.name),
                              subtitle: Text('${localizations.endDate}: ${shop.contractEndDate}'),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}