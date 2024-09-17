import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';
import '../providers/tenant_provider.dart';
import '../providers/payment_provider.dart';
import '../models/shop.dart';
import '../models/tenant.dart';
import '../models/payment.dart';
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
  Shop? _selectedShop;
  Tenant? _selectedTenant;
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  PaymentType _selectedPaymentType = PaymentType.rent;
  int _selectedMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    _selectedShop = widget.shop;
    _selectedTenant = widget.tenant;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShopProvider>(context, listen: false).loadShops();
      Provider.of<TenantProvider>(context, listen: false).loadTenants();
    });
  }

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final tenantProvider = Provider.of<TenantProvider>(context);
    final paymentProvider = Provider.of<PaymentProvider>(context);
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
            DropdownButtonFormField<Shop>(
              value: _selectedShop,
              decoration: InputDecoration(labelText: localizations.selectShop),
              items: shopProvider.shops.map((shop) {
                return DropdownMenuItem(
                  value: shop,
                  child: Text(shop.name),
                );
              }).toList(),
              onChanged: (shop) {
                setState(() {
                  _selectedShop = shop;
                  // Reset selected tenant when shop changes
                  _selectedTenant = null;
                });
              },
              validator: (value) =>
                  value == null ? localizations.selectShopValidation : null,
            ),
            DropdownButtonFormField<Tenant>(
              value: _selectedTenant,
              decoration:
                  InputDecoration(labelText: localizations.selectTenant),
              items: _selectedShop != null
                  ? tenantProvider.tenants
                      .where((tenant) => _selectedShop!.tenant?.id == tenant.id)
                      .map((tenant) {
                      return DropdownMenuItem(
                        value: tenant,
                        child: Text(tenant.name),
                      );
                    }).toList()
                  : [],
              onChanged: (tenant) {
                setState(() {
                  _selectedTenant = tenant;
                });
              },
              validator: (value) =>
                  value == null ? localizations.selectTenantValidation : null,
            ),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(labelText: localizations.amount),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value!.isEmpty ? localizations.amountValidation : null,
            ),
            ListTile(
              title: Text(localizations.date),
              subtitle: Text(_selectedDate.toString()),
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
            DropdownButtonFormField<PaymentType>(
              value: _selectedPaymentType,
              decoration: const InputDecoration(labelText: 'Payment Type'),
              items: PaymentType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (type) {
                setState(() {
                  _selectedPaymentType = type!;
                });
              },
            ),
            DropdownButtonFormField<int>(
              value: _selectedMonth,
              decoration: const InputDecoration(labelText: 'Month'),
              items: List.generate(12, (index) {
                return DropdownMenuItem(
                  value: index + 1,
                  child: Text((index + 1).toString()),
                );
              }),
              onChanged: (month) {
                setState(() {
                  _selectedMonth = month!;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newPayment = Payment(
                    id: DateTime.now().toString(),
                    shopId: _selectedShop!.id,
                    tenantId: _selectedTenant!.id,
                    date: _selectedDate,
                    amount: double.parse(_amountController.text),
                    paymentType: _selectedPaymentType,
                    month: _selectedMonth,
                  );
                  paymentProvider.addPayment(newPayment);
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
