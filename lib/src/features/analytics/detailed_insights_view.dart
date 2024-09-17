import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import '../shops/models/shop.dart';
import '../shops/models/tenant.dart';
import '../shops/providers/shop_provider.dart';
import '../shops/providers/tenant_provider.dart';
import '../shops/providers/payment_provider.dart';
import '../shops/models/payment.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class DetailedInsightsView extends StatefulWidget {
  const DetailedInsightsView({super.key});

  @override
  State<DetailedInsightsView> createState() => _DetailedInsightsViewState();
}

class _DetailedInsightsViewState extends State<DetailedInsightsView> {
  // Filters
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  Shop? _selectedShop;
  Tenant? _selectedTenant;

  // Data for charts and metrics
  List<Payment> filteredPayments = [];
  double totalRevenue = 0;
  double totalRentCollected = 0;
  double totalLeaseCollected = 0;
  int totalShops = 0;
  int occupiedShops = 0;
  int totalTenants = 0;
  int tenantsWithDuePayments = 0;

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final shopProvider = Provider.of<ShopProvider>(context, listen: false);
      final tenantProvider =
          Provider.of<TenantProvider>(context, listen: false);
      final paymentProvider =
          Provider.of<PaymentProvider>(context, listen: false);

      await Future.wait([
        shopProvider.loadShops(),
        tenantProvider.loadTenants(),
        paymentProvider.loadPayments(),
      ]);

      _applyFilters();
    } catch (error) {
      setState(() {
        _errorMessage = 'Error loading data: ${error.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    final tenantProvider = Provider.of<TenantProvider>(context, listen: false);
    final paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);

    setState(() {
      filteredPayments = paymentProvider.payments.where((payment) {
        // Apply date filters
        if (_selectedStartDate != null &&
            payment.date.isBefore(_selectedStartDate!)) {
          return false;
        }
        if (_selectedEndDate != null &&
            payment.date.isAfter(_selectedEndDate!)) {
          return false;
        }

        // Apply shop filter
        if (_selectedShop != null && payment.shopId != _selectedShop!.id) {
          return false;
        }

        // Apply tenant filter
        if (_selectedTenant != null &&
            payment.tenantId != _selectedTenant!.id) {
          return false;
        }

        return true;
      }).toList();

      // Calculate metrics based on filtered data
      totalRevenue = shopProvider.shops
          .map((shop) => shop.getTotalRentPaid())
          .fold(0.0, (a, b) => a + b);
      totalRentCollected = filteredPayments
          .where((payment) => payment.paymentType == PaymentType.rent)
          .map((payment) => payment.amount)
          .fold(0.0, (a, b) => a + b);
      totalLeaseCollected = filteredPayments
          .where((payment) => payment.paymentType == PaymentType.lease)
          .map((payment) => payment.amount)
          .fold(0.0, (a, b) => a + b);
      totalShops = shopProvider.shops.length;
      occupiedShops =
          shopProvider.shops.where((shop) => shop.isOccupied).length;
      totalTenants = tenantProvider.tenants.length;
      tenantsWithDuePayments = tenantProvider.tenants
          .where((tenant) => shopProvider.shops.any((shop) =>
              shop.tenant?.id == tenant.id && shop.isPaymentOverdue()))
          .length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.detailedInsightsTitle),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filters Section
                        _buildFilterSection(context),
                        const SizedBox(height: 24),

                        // Key Metrics Section
                        Text(
                          localizations.keyMetrics,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        _buildKeyMetricsGrid(context),
                        const SizedBox(height: 24),

                        // Charts Section
                        Text(
                          localizations.revenueBreakdown,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        _buildRevenueChart(),
                        const SizedBox(height: 24),
                        Text(
                          localizations.occupancyRateOverTime,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        _buildOccupancyRateChart(context),
                        const SizedBox(height: 24),
                        // Add more charts for other insights (e.g., occupancy rate over time, payment trends)

                        // Data Table Section
                        Text(
                          localizations.paymentHistory,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        _buildPaymentDataTable(context),
                        const SizedBox(height: 24),
                        // Export Data Section
                        ElevatedButton(
                          onPressed: _exportDataToCSV,
                          child: const Text('Export Data (CSV)'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
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
              localizations.filters,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedStartDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _selectedStartDate) {
                        setState(() {
                          _selectedStartDate = picked;
                        });
                      }
                    },
                    child: Text(
                      _selectedStartDate != null
                          ? _selectedStartDate.toString()
                          : localizations.startDate,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedEndDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _selectedEndDate) {
                        setState(() {
                          _selectedEndDate = picked;
                        });
                      }
                    },
                    child: Text(
                      _selectedEndDate != null
                          ? _selectedEndDate.toString()
                          : localizations.endDate,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Shop>(
              value: _selectedShop,
              decoration: InputDecoration(labelText: localizations.selectShop),
              items: shopProvider.shops.map((shop) {
                return DropdownMenuItem(
                  value: shop,
                  child: Text(shop.name),
                );
              }).toList(),
              onChanged: (shop) {
                setState(() {
                  _selectedShop = shop;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Tenant>(
              value: _selectedTenant,
              decoration:
                  InputDecoration(labelText: localizations.selectTenant),
              items: tenantProvider.tenants.map((tenant) {
                return DropdownMenuItem(
                  value: tenant,
                  child: Text(tenant.name),
                );
              }).toList(),
              onChanged: (tenant) {
                setState(() {
                  _selectedTenant = tenant;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _applyFilters,
              child: Text(localizations.applyFilters),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyMetricsGrid(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildMetricCard(context, localizations.totalRevenue,
            totalRevenue.toStringAsFixed(2)),
        _buildMetricCard(context, localizations.totalRentCollected,
            totalRentCollected.toStringAsFixed(2)),
        _buildMetricCard(context, localizations.totalLeaseCollected,
            totalLeaseCollected.toStringAsFixed(2)),
        _buildMetricCard(
            context, localizations.totalShops, totalShops.toString()),
        _buildMetricCard(
            context, localizations.occupiedShops, occupiedShops.toString()),
        _buildMetricCard(
            context, localizations.totalTenants, totalTenants.toString()),
        _buildMetricCard(context, localizations.tenantsWithDuePayments,
            tenantsWithDuePayments.toString()),
      ],
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(), // Use CategoryAxis for months
      series: <CartesianSeries>[
        ColumnSeries<Payment, String>(
          dataSource: filteredPayments,
          xValueMapper: (Payment payment, _) => payment.month.toString(),
          yValueMapper: (Payment payment, _) => payment.amount,
        ),
      ],
    );
  }

  Widget _buildOccupancyRateChart(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final occupiedShopsData = <DateTime, int>{};

    // Group shops by month and year
    for (final shop in shopProvider.shops) {
      final monthYear = DateTime(shop.dateCreated.year, shop.dateCreated.month);
      occupiedShopsData[monthYear] =
          (occupiedShopsData[monthYear] ?? 0) + (shop.isOccupied ? 1 : 0);
    }

    return SfCartesianChart(
      primaryXAxis: const DateTimeAxis(), // Use DateTimeAxis for time series
      series: <CartesianSeries<MapEntry<DateTime, int>, DateTime>>[
        // Assuming you want a line chart for occupancy rate
        LineSeries<MapEntry<DateTime, int>, DateTime>(
          dataSource: occupiedShopsData.entries.toList(),
          xValueMapper: (entry, _) => entry.key,
          yValueMapper: (entry, _) => entry.value,
        ),
      ],
    );
  }

  Widget _buildPaymentDataTable(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 600,
        columns: [
          DataColumn2(
            label: Text(localizations.shopId),
            size: ColumnSize.S,
          ),
          DataColumn2(
            label: Text(localizations.tenantId),
            size: ColumnSize.S,
          ),
          DataColumn(
            label: Text(localizations.date),
          ),
          DataColumn(
            label: Text(localizations.amount),
            numeric: true,
          ),
          DataColumn(
            label: Text(localizations.paymentType),
          ),
        ],
        rows: filteredPayments
            .map((payment) => DataRow(cells: [
                  DataCell(Text(payment.shopId)),
                  DataCell(Text(payment.tenantId)),
                  DataCell(Text(payment.date.toString())),
                  DataCell(Text(payment.amount.toString())),
                  DataCell(Text(payment.paymentType.name)),
                ]))
            .toList());
  }

  Future<void> _exportDataToCSV() async {
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    final tenantProvider = Provider.of<TenantProvider>(context, listen: false);

    // Create a list of data rows for the CSV file
    List<List<dynamic>> rows = [];

    // Add a header row
    rows.add(
        ['Shop', 'Locataire', 'Date Payment', 'Montant', 'Type de Payment']);

    // Add data rows for each payment
    for (final payment in filteredPayments) {
      final shop = shopProvider.shops.firstWhere((s) => s.id == payment.shopId,
          orElse: () => Shop(
              id: '',
              name: '',
              description: '',
              dateCreated: DateTime.now(),
              rentAmount: 0.0,
              leaseAmount: 0.0,
              isOccupied: false));
      final tenant = tenantProvider.tenants.firstWhere(
          (t) => t.id == payment.tenantId,
          orElse: () => Tenant(
              id: '', name: '', email: '', phoneNumber: '', contractLength: 0));

      rows.add([
        shop.name,
        tenant.name,
        payment.date.toString(),
        payment.amount,
        payment.paymentType.name,
      ]);
    }

    // Convert the data to CSV format
    String csvData = const ListToCsvConverter().convert(rows);

    // Get the application's documents directory
    Directory? directory = await getExternalStorageDirectory();
    final String path = '${directory!.path}/payment_data.csv';
    final File file = File(path);
    await file.writeAsString(csvData);

    // Share the file
    await Share.shareXFiles([XFile(path)], text: 'Payment Data');
  }
}
