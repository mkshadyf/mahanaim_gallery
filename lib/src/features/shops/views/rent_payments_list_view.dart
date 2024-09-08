import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';
import '../models/shop.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RentPaymentsView extends StatelessWidget {
  const RentPaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.rentPaymentsTitle),
      ),
      body: ListView.builder(
        itemCount: shopProvider.shops.length,
        itemBuilder: (context, index) {
          Shop shop = shopProvider.shops[index];
          return ListTile(
            title: Text(shop.name),
            subtitle: Text('${localizations.totalRentPaid}: \${shop.getTotalRentPaid().toStringAsFixed(2)}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/rent_payments_details',
                arguments: shop,
              );
            },
          );
        },
      ),
    );
  }
}