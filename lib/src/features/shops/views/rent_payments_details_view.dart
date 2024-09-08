
import 'package:flutter/material.dart';
import '../models/shop.dart';
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
      body: ListView.builder(
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
    );
  }
}