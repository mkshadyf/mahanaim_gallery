               import 'package:flutter/material.dart';
 import '../models/tenant.dart';
 import 'package:flutter_gen/gen_l10n/app_localizations.dart';





class TenantDetailsView extends StatelessWidget {
  final Tenant tenant;

  const TenantDetailsView({super.key, required this.tenant});

  @override
  Widget build(BuildContext context) {
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
            Text(tenant.name, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('${localizations.emailLabel}: ${tenant.email}'),
            Text('${localizations.contactInfo}: ${tenant.phoneNumber}'),
            const SizedBox(height: 16),
            Text(localizations.contractDetails, style: Theme.of(context).textTheme.headlineSmall),
            Text('${localizations.startDate}: ${tenant.contractStartDate.toString()}'),
            Text('${localizations.endDate}: ${tenant.contractEndDate.toString()}'),
            Text('${localizations.monthlyRent}: \$${tenant.monthlyRent}'),
            Text('${localizations.leaseFee}: \$${tenant.leaseFee}'),
            const SizedBox(height: 16),
            Text(localizations.paymentHistory, style: Theme.of(context).textTheme.headlineSmall),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tenant.payments.length,
              itemBuilder: (context, index) {
                final payment = tenant.payments[index];
                return ListTile(
                  title: Text('${payment.date.toString()} - \$${payment.amount}'),
                  subtitle: Text('${localizations.amountDue}: \$${payment.amountDue}'),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showNotificationSettingsDialog(context),
              child: Text(localizations.notificationSettings),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.notificationSettings),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.smsNotifications),
                value: tenant.notificationSettings.sms,
                onChanged: (bool value) {
                  // Update tenant's notification settings
                },
              ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!.emailNotifications),
                value: tenant.notificationSettings.email,
                onChanged: (bool value) {
                  // Update tenant's notification settings
                },
              ),
              TextFormField(
                initialValue: tenant.notificationSettings.phoneNumber,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.contactInfo),
                onChanged: (String value) {
                  // Update tenant's phone number
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.save),
              onPressed: () {
                // Save updated notification settings
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
