import 'package:flutter/material.dart';
import 'package:mahanaim_gallery/src/features/shops/models/shop.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RentPaymentsDetailsView extends StatelessWidget {
  final Shop shop;

  const RentPaymentsDetailsView({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.rentPaymentsDetailsTitle),
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
                    Text('${localizations.tenantId}: ${shop.tenant?.id ?? ''}'),
                    Text('${localizations.rentAmount}: \$${shop.rentAmount.toStringAsFixed(2)}'),
                    Text('${localizations.totalRentPaid}: \$${shop.getTotalRentPaid().toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(localizations.rentPayments, style: Theme.of(context).textTheme.headlineSmall),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shop.rentPayments.length,
              itemBuilder: (context, index) {
                final payment = shop.rentPayments[index];
                return ListTile(
                  title: Text('${payment.paymentType.name.toUpperCase()} - \$${payment.amount.toStringAsFixed(2)}'),
                  subtitle: Text('${payment.date.toString()} - Month: ${payment.month}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}