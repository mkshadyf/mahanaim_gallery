import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shop.dart';
import '../models/tenant.dart';
import '../providers/shop_provider.dart';
import '../providers/tenant_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddRentPaymentView extends StatefulWidget {
  final Shop? shop;
  final Tenant? tenant;

  const AddRentPaymentView({super.key, this.shop, this.tenant});

  @override
  _AddRentPaymentViewState createState() => _AddRentPaymentViewState();
}

class _AddRentPaymentViewState extends State<AddRentPaymentView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  Shop? _selectedShop;
  Tenant? _selectedTenant;

  @override
  void initState() {
    super.initState();
    _selectedShop = widget.shop;
    _selectedTenant = widget.tenant;
  }

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final tenantProvider = Provider.of<TenantProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.addRentPayment),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            if (_selectedShop == null)
              DropdownButtonFormField<Shop>(
                decoration: InputDecoration(labelText: localizations.selectShop),
                items: shopProvider.shops.map((Shop shop) {
                  return DropdownMenuItem<Shop>(
                    value: shop,
                    child: Text(shop.name),
                  );
                }).toList(),
                onChanged: (Shop? newValue) {
                  setState(() {
                    _selectedShop = newValue;
                  });
                },
                validator: (value) => value == null ? localizations.selectShopValidation : null,
              ),
            if (_selectedTenant == null)
              DropdownButtonFormField<Tenant>(
                decoration: InputDecoration(labelText: localizations.selectTenant),
                items: tenantProvider.tenants.map((Tenant tenant) {
                  return DropdownMenuItem<Tenant>(
                    value: tenant,
                    child: Text(tenant.name),
                  );
                }).toList(),
                onChanged: (Tenant? newValue) {
                  setState(() {
                    _selectedTenant = newValue;
                  });
                },
                validator: (value) => value == null ? localizations.selectTenantValidation : null,
              ),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: localizations.amount,
                suffixText: 'USD',
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? localizations.amountValidation : null,
            ),
            ListTile(
              title: Text(localizations.date),
              subtitle: Text(_selectedDate.toLocal().toString()),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _selectedDate) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newPayment = RentPayment(
                    tenantId: _selectedTenant!.id,
                    date: _selectedDate,
                    amount: double.parse(_amountController.text),
                  );

                  shopProvider.addRentPayment(_selectedShop!.id, newPayment);
                  Navigator.pop(context);
                }
              },
              child: Text(localizations.addRentPayment),
            ),
          ],
        ),
      ),
    );
  }
}