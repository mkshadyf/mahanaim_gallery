import 'package:flutter/material.dart';
import '../models/tenant.dart';
import '../providers/shop_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TenantDetailsView extends StatelessWidget {
  final Tenant tenant;

  const TenantDetailsView({super.key, required this.tenant});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.tenantDetailsTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tenant.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('${localizations.emailLabel}: ${tenant.email}'),
            Text('${localizations.phoneNumber}: ${tenant.phoneNumber}'),
            const SizedBox(height: 16),
            Text('${localizations.contractStartDateLabel}: ${tenant.contractStartDate.toString()}'),
            Text('${localizations.contractEndDateLabel}: ${tenant.contractEndDate.toString()}'),
            const SizedBox(height: 16),
            Text(localizations.assignedShopLabel, style: Theme.of(context).textTheme.headlineSmall),
            tenant.assignedShopId != null
                ? FutureBuilder(
                    future: shopProvider.getShopById(tenant.assignedShopId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('${localizations.errorLoadingShop}: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final shop = snapshot.data;
                        return ListTile(
                          title: Text(shop!.name),
                          subtitle: Text('${localizations.rentAmount}: \$${shop.rentAmount.toStringAsFixed(2)}'),
                        );
                      } else {
                        return Text(localizations.noAssignedShop);
                      }
                    }
                  )
                : Text(localizations.noAssignedShop),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to edit tenant screen
              },
              child: Text(localizations.editTenantButton),
            ),
          ],
        ),
      ),
    );
  }
}
