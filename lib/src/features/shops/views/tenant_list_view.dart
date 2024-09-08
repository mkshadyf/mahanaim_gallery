import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';
import '../providers/tenant_provider.dart';
import '../models/tenant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';

class TenantListView extends StatefulWidget {
  const TenantListView({super.key});

  @override
  _TenantListViewState createState() => _TenantListViewState();
}

class _TenantListViewState extends State<TenantListView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Logger _logger = Logger('TenantListView');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TenantProvider>(context, listen: false).loadTenants();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tenantProvider = Provider.of<TenantProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    final shopProvider = Provider.of<ShopProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.tenantsTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: localizations.searchTenants,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => tenantProvider.loadTenants(),
              child: tenantProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : tenantProvider.error != null
                      ? Center(child: Text(tenantProvider.error!))
                      : tenantProvider.tenants.isEmpty
                          ? Center(child: Text(localizations.noTenantsFound))
                          : ListView.builder(
                              itemCount: tenantProvider.tenants.length,
                              itemBuilder: (context, index) {
                                Tenant tenant = tenantProvider.tenants[index];
                                _logger.info('Building list item for tenant: ${tenant.id}');
                                _logger.info('Tenant data: ${tenant.toString()}');

                                if (_searchQuery.isNotEmpty &&
                                    !tenant.name
                                        .toLowerCase()
                                        .contains(_searchQuery) &&
                                    !tenant.email
                                        .toLowerCase()
                                        .contains(_searchQuery)) {
                                  return const SizedBox.shrink();
                                }

                                String paymentStatus = '';
                                try {
                                  paymentStatus = shopProvider.getPaymentStatusForTenant(tenant.id);
                                  _logger.info('Payment status for tenant ${tenant.id}: $paymentStatus');
                                } catch (e) {
                                  _logger.severe('Error getting payment status for tenant ${tenant.id}: $e');
                                }

                                return ListTile(
                                  title: Text(tenant.name),
                                  subtitle: Text(tenant.email),
                                  trailing: Text(paymentStatus),
                                  onTap: () {
                                    _logger.info('Tapped on tenant: ${tenant.id}');
                                    Navigator.pushNamed(
                                      context,
                                      '/tenant_details',
                                      arguments: tenant,
                                    );
                                  },
                                );
                              },
                            ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _logger.info('Add tenant button pressed');
          Navigator.pushNamed(context, '/add_tenant');
        },
        tooltip: localizations.addTenantTooltip,
        child: const Icon(Icons.add),
      ),
    );
  }
}
