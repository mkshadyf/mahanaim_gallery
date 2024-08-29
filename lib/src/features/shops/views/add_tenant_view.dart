import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/tenant_provider.dart';
import '../models/tenant.dart';

class AddTenantView extends StatefulWidget {
  const AddTenantView({super.key});

  @override
  State<AddTenantView> createState() => _AddTenantViewState();
}


class _AddTenantViewState extends State<AddTenantView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _monthlyRentController = TextEditingController();
  final _leaseFeeController = TextEditingController();
  DateTime _contractStartDate = DateTime.now();
  DateTime _contractEndDate = DateTime.now().add(const Duration(days: 365));

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
              decoration: InputDecoration(labelText: localizations.tenantNameLabel),
              validator: (value) => value!.isEmpty ? localizations.tenantNameValidationError : null,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: localizations.tenantEmailLabel),
              validator: (value) => value!.isEmpty ? localizations.tenantEmailValidationError : null,
            ),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: localizations.tenantPhoneLabel),
              validator: (value) => value!.isEmpty ? localizations.tenantPhoneValidationError : null,
            ),
            TextFormField(
              controller: _monthlyRentController,
              decoration: InputDecoration(labelText: localizations.monthlyRentLabel),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? localizations.monthlyRentValidationError : null,
            ),
            TextFormField(
              controller: _leaseFeeController,
              decoration: InputDecoration(labelText: localizations.leaseFeeLabel),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? localizations.leaseFeeValidationError : null,
            ),
            ListTile(
              title: Text(localizations.contractStartDateLabel),
              subtitle: Text(_contractStartDate.toString()),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _contractStartDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025),
                );
                if (picked != null && picked != _contractStartDate) {
                  setState(() {
                    _contractStartDate = picked;
                  });
                }
              },
            ),
            ListTile(
              title: Text(localizations.contractEndDateLabel),
              subtitle: Text(_contractEndDate.toString()),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _contractEndDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025),
                );
                if (picked != null && picked != _contractEndDate) {
                  setState(() {
                    _contractEndDate = picked;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  tenantProvider.addTenant(Tenant(
                    id: DateTime.now().toString(),
                    name: _nameController.text,
                    email: _emailController.text,
                    phoneNumber: _phoneController.text,
                    payments: [],
                    contractStartDate: _contractStartDate,
                    contractEndDate: _contractEndDate,
                    monthlyRent: double.parse(_monthlyRentController.text),
                    leaseFee: double.parse(_leaseFeeController.text),
                  ));
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

