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
                    Text('${localizations.rentAmount}: \$${shop.rentAmount.toStringAsFixed(2)}'),
                    Text('${localizations.leaseAmount}: \$${shop.leaseAmount.toStringAsFixed(2)}'),
                    Text('${localizations.isAvailable}: ${shop.isOccupied ? localizations.no : localizations.yes}'),
                    if (shop.contractEndDate != null)
                      Text('${localizations.endDate}: ${shop.contractEndDate.toString()}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(localizations.tenantName, style: Theme.of(context).textTheme.headlineMedium),
            if (shop.tenant != null)
              ListTile(
                title: Text(shop.tenant!.name),
                subtitle: Text(shop.tenant!.email),
              )
            else
              Center(child: Text(localizations.noTenantAssigned)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add_tenant_to_shop', arguments: shop);
              },
              child: Text(localizations.addTenant),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add_rent_payment', arguments: shop);
              },
              child: Text(localizations.addRentPayment),
            ),
          ],
        ),
      ),
    );
  }
}