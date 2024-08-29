import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shop.dart';
import '../providers/shop_provider.dart';
import '../providers/tenant_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShopDetailsView extends StatelessWidget {
  final Shop shop;

  const ShopDetailsView({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final tenantProvider = Provider.of<TenantProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.shopDetailsTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(shop.name, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(shop.description),
                    const SizedBox(height: 16),
                    Text('${localizations.rentAmount}: \$${shop.rentAmount}'),
                    Text('${localizations.isAvailable}: ${shop.isAvailable ? localizations.yes : localizations.no}'),
                    if (!shop.isAvailable && shop.nextAvailableDate != null)
                      Text('${localizations.nextAvailableDate}: ${shop.nextAvailableDate.toString()}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(localizations.tenants, style: Theme.of(context).textTheme.headlineMedium),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shop.tenantIds.length,
              itemBuilder: (context, index) {
                final tenant = tenantProvider.tenants.firstWhere((t) => t.id == shop.tenantIds[index]);
                return ListTile(
                  title: Text(tenant.name),
                  subtitle: Text(tenant.email),
                );
              },
            ),
            const SizedBox(height: 16),
          ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, '/add_tenant_to_shop', arguments: shop);
  },
  child: Text(localizations.addTenant),
),

          ],
        ),
      ),
    );
  }
}
