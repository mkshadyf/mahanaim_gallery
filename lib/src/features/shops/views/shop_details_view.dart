import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shop.dart';
import '../models/tenant.dart';
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

    Tenant? tenant = shop.tenant;

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
                    Text(shop.name,
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(shop.description),
                    const SizedBox(height: 16),
                    Text(localizations.contractInfo,
                        style: Theme.of(context).textTheme.headlineSmall),
                    Text(
                        '${localizations.dateCreated}: ${shop.dateCreated.toString()}'),
                    Text(
                        '${localizations.rentAmount}: ${shop.rentAmount.toString()}'),
                    Text(
                        '${localizations.leaseAmount}: ${shop.leaseAmount.toString()}'),
                    const SizedBox(height: 16),
                    Text(localizations.tenantDetailsTitle,
                        style: Theme.of(context).textTheme.headlineSmall),
                    tenant != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${localizations.tenantName}: ${tenant.name}'),
                              Text(
                                  '${localizations.tenantEmailLabel}: ${tenant.email}'),
                              Text(
                                  '${localizations.tenantPhoneLabel}: ${tenant.phoneNumber}'),
                              Text(
                                  '${localizations.contractLength}: ${tenant.contractLength} months'),
                              Text(
                                  '${localizations.paymentStrikes}: ${tenant.paymentStrikes}'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/add_rent_payment',
                                      arguments: shop);
                                },
                                child: Text(localizations.addRentPayment),
                              ),
                            ],
                          )
                        : Text(localizations.noTenantAssigned),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(localizations.paymentsTitle,
                        style: Theme.of(context).textTheme.headlineSmall),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: shop.rentPayments.length,
                      itemBuilder: (context, index) {
                        final payment = shop.rentPayments[index];
                        return ListTile(
                          title: Text(
                              '${localizations.amount}: ${payment.amount}'),
                          subtitle: Text(
                              '${localizations.date}: ${payment.date.toString()}'),
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
    );
  }
}
