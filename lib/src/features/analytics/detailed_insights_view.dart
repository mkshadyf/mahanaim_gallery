import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../features/shops/providers/shop_provider.dart';
import '../../features/shops/providers/tenant_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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

  Future<void> _exportToPDF(BuildContext context) async {
    final pdf = pw.Document();
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    final tenantProvider = Provider.of<TenantProvider>(context, listen: false);

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('Detailed Insights Report')),
          pw.Header(level: 1, child: pw.Text('Occupancy Rate')),
          pw.Paragraph(
              text:
                  'Occupied: ${shopProvider.shops.where((shop) => shop.isOccupied).length}'),
          pw.Paragraph(
              text:
                  'Vacant: ${shopProvider.shops.where((shop) => !shop.isOccupied).length}'),
          pw.Header(level: 1, child: pw.Text('Revenue Breakdown')),
          pw.Paragraph(
              text:
                  'Total Rent Revenue: ${shopProvider.shops.fold(0.0, (sum, shop) => sum + shop.rentAmount)}'),
          pw.Paragraph(
              text:
                  'Total Lease Revenue: ${shopProvider.shops.fold(0.0, (sum, shop) => sum + shop.leaseAmount)}'),
          pw.Header(level: 1, child: pw.Text('Upcoming Lease Expirations')),
          ...shopProvider.shops
              .where((shop) =>
                  shop.contractEndDate != null &&
                  shop.contractEndDate!.isAfter(DateTime.now()))
              .map((shop) =>
                  pw.Paragraph(text: '${shop.name}: ${shop.contractEndDate}')),
          pw.Header(level: 1, child: pw.Text('Overdue Payments')),
          ...shopProvider.shops.where((shop) => shop.isPaymentOverdue()).map(
              (shop) =>
                  pw.Paragraph(text: '${shop.name}: ${shop.contractEndDate}')),
          pw.Header(level: 1, child: pw.Text('Tenant Payment History')),
          ...tenantProvider.tenants.map((tenant) => pw.Paragraph(
              text:
                  '${tenant.name}: ${shopProvider.getPaymentStatusForTenant(tenant.id)}')),
        ],
      ),
    );

    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'detailed_insights.pdf');
  }

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final tenantProvider = Provider.of<TenantProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.detailedInsightsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () => _exportToPDF(context),
            tooltip: 'Export to PDF',
          ),
        ],
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
                                  ChartData(
                                      localizations.occupied,
                                      shopProvider.shops
                                          .where((shop) => shop.isOccupied)
                                          .length
                                          .toDouble()),
                                  ChartData(
                                      localizations.vacant,
                                      shopProvider.shops
                                          .where((shop) => !shop.isOccupied)
                                          .length
                                          .toDouble()),
                                ],
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                dataLabelSettings:
                                    const DataLabelSettings(isVisible: true),
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
                            series: <CartesianSeries>[
                              ColumnSeries<ChartData, String>(
                                dataSource: [
                                  ChartData(
                                      'Rent',
                                      shopProvider.shops.fold(
                                          0.0,
                                          (sum, shop) =>
                                              sum + shop.rentAmount)),
                                  ChartData(
                                      'Lease',
                                      shopProvider.shops.fold(
                                          0.0,
                                          (sum, shop) =>
                                              sum + shop.leaseAmount)),
                                ],
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                dataLabelSettings:
                                    const DataLabelSettings(isVisible: true),
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
                      if (shopProvider.shops
                          .where((shop) =>
                              shop.contractEndDate != null &&
                              shop.contractEndDate!.isAfter(DateTime.now()))
                          .isEmpty)
                        Center(
                          child: Text(localizations.noUpcomingLeaseExpirations),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: shopProvider.shops
                              .where((shop) =>
                                  shop.contractEndDate != null &&
                                  shop.contractEndDate!.isAfter(DateTime.now()))
                              .length,
                          itemBuilder: (context, index) {
                            final shop = shopProvider.shops
                                .where((shop) =>
                                    shop.contractEndDate != null &&
                                    shop.contractEndDate!
                                        .isAfter(DateTime.now()))
                                .toList()[index];
                            return ListTile(
                              title: Text(shop.name),
                              subtitle: Text(
                                  '${localizations.endDate}: ${shop.contractEndDate}'),
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
                      if (shopProvider.shops
                          .where((shop) => shop.isPaymentOverdue())
                          .isEmpty)
                        Center(
                          child: Text(localizations.noOverduePayments),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: shopProvider.shops
                              .where((shop) => shop.isPaymentOverdue())
                              .length,
                          itemBuilder: (context, index) {
                            final shop = shopProvider.shops
                                .where((shop) => shop.isPaymentOverdue())
                                .toList()[index];
                            return ListTile(
                              title: Text(shop.name),
                              subtitle: Text(
                                  '${localizations.endDate}: ${shop.contractEndDate}'),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Tenant Payment History
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tenant Payment History',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tenantProvider.tenants.length,
                        itemBuilder: (context, index) {
                          final tenant = tenantProvider.tenants[index];
                          return ListTile(
                            title: Text(tenant.name),
                            subtitle: Text(
                                'Payment Status: ${shopProvider.getPaymentStatusForTenant(tenant.id)}'),
                            trailing: Text('Strikes: ${tenant.paymentStrikes}'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Inventory Summary
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Inventory Summary',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Text('Total Shops: ${shopProvider.shops.length}'),
                      Text(
                          'Occupied Shops: ${shopProvider.shops.where((shop) => shop.isOccupied).length}'),
                      Text(
                          'Vacant Shops: ${shopProvider.shops.where((shop) => !shop.isOccupied).length}'),
                      Text('Total Tenants: ${tenantProvider.tenants.length}'),
                      Text('Total Revenue: ${shopProvider.totalRevenue}'),
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
