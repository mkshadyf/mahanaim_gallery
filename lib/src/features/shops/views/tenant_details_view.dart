import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import '../models/tenant.dart';
//import '../providers/tenant_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TenantDetailsView extends StatelessWidget {
  final Tenant tenant;

  const TenantDetailsView({super.key, required this.tenant});

  @override
  Widget build(BuildContext context) {
  //  final tenantProvider = Provider.of<TenantProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.tenantDetailsTitle),
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
                    Text(tenant.name, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(tenant.email),
                    Text(tenant.phoneNumber),
                    const SizedBox(height: 16),
                    Text(localizations.contractDetails, style: Theme.of(context).textTheme.headlineSmall),
                    Text('${localizations.startDate}: ${tenant.moveInDate?.toString() ?? ''}'),
                    Text('${localizations.paymentStrikes}: ${tenant.paymentStrikes}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add_rent_payment', arguments: tenant);
              },
              child: Text(localizations.addRentPayment),
            ),
          ],
        ),
      ),
    );
  }
}