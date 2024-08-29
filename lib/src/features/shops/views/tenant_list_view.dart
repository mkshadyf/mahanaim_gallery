import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tenant_provider.dart';
import 'tenant_details_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TenantListView extends StatelessWidget {
  const TenantListView({super.key});

  @override
  Widget build(BuildContext context) {
    final tenantProvider = Provider.of<TenantProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.tenantListTitle),
      ),
      body: tenantProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tenantProvider.tenants.length,
              itemBuilder: (context, index) {
                final tenant = tenantProvider.tenants[index];
                return Card(
                  child: ListTile(
                    title: Text(tenant.name),
                    subtitle: Text(tenant.email),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TenantDetailsView(tenant: tenant),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_tenant');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
