import 'package:flutter/material.dart';
import '../models/shop.dart';
import 'add_rent_payment_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShopDetailsView extends StatelessWidget {
  final Shop shop;

  const ShopDetailsView({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.shopDetailsTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(shop.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(shop.description),
            const SizedBox(height: 16),
            Text('${localizations.rentAmount}: \${shop.rentAmount.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            Text(localizations.rentPayments, style: Theme.of(context).textTheme.headlineSmall),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shop.rentPayments.length,
              itemBuilder: (context, index) {
                final payment = shop.rentPayments[index];
                return ListTile(
                  title: Text('${localizations.date}: ${payment.date.toLocal()}'),
                  subtitle: Text('${localizations.amount}: \${payment.amount.toStringAsFixed(2)}'),
                  trailing: Text('${localizations.tenantId}: ${payment.tenantId}'),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddRentPaymentView(shop: shop),
                  ),
                );
              },
              child: Text(localizations.addRentPayment),
            ),
          ],
        ),
      ),
    );
  }
}