import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tenant_provider.dart';
import '../models/tenant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTenantView extends StatefulWidget {
  const AddTenantView({super.key});

  @override
  _AddTenantViewState createState() => _AddTenantViewState();
}

class _AddTenantViewState extends State<AddTenantView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime _contractStartDate = DateTime.now();
  DateTime _contractEndDate = DateTime.now().add(const Duration(days: 365));
  final _contractLengthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tenantProvider = Provider.of<TenantProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.addTenantTitle),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration:
                  InputDecoration(labelText: localizations.tenantNameLabel),
              validator: (value) => value!.isEmpty
                  ? localizations.tenantNameValidationError
                  : null,
            ),
            TextFormField(
              controller: _emailController,
              decoration:
                  InputDecoration(labelText: localizations.tenantEmailLabel),
              validator: (value) => value!.isEmpty
                  ? localizations.tenantEmailValidationError
                  : null,
            ),
            TextFormField(
              controller: _phoneController,
              decoration:
                  InputDecoration(labelText: localizations.tenantPhoneLabel),
              validator: (value) => value!.isEmpty
                  ? localizations.tenantPhoneValidationError
                  : null,
            ),
            TextFormField(
              controller: _contractLengthController,
              decoration:
                  InputDecoration(labelText: localizations.contractLengthLabel),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty
                  ? localizations.contractLengthValidationError
                  : null,
            ),
            ListTile(
              title: Text(localizations.contractStartDateLabel),
              subtitle: Text(_contractStartDate.toString()),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _contractStartDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _contractStartDate = picked);
              },
            ),
            ListTile(
              title: Text(localizations.contractEndDateLabel),
              subtitle: Text(_contractEndDate.toString()),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _contractEndDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => _contractEndDate = picked);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newTenant = Tenant(
                    id: DateTime.now().toString(),
                    name: _nameController.text,
                    email: _emailController.text,
                    phoneNumber: _phoneController.text,
                    moveInDate: _contractStartDate,
                    contractLength: int.parse(_contractLengthController.text),
                  );
                  tenantProvider.addTenant(newTenant);
                  Navigator.pop(context);
                }
              },
              child: Text(localizations.addTenantButton),
            ),
          ],
        ),
      ),
    );
  }
}
