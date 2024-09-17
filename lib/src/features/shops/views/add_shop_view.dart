import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';
import '../models/shop.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddShopView extends StatefulWidget {
  const AddShopView({super.key});

  @override
  _AddShopViewState createState() => _AddShopViewState();
}

class _AddShopViewState extends State<AddShopView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rentAmountController = TextEditingController();
  final _leaseAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.addShopTitle),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration:
                  InputDecoration(labelText: localizations.shopNameLabel),
              validator: (value) =>
                  value!.isEmpty ? localizations.shopNameValidationError : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                  labelText: localizations.shopDescriptionLabel),
            ),
            TextFormField(
              controller: _rentAmountController,
              decoration:
                  InputDecoration(labelText: localizations.rentAmountLabel),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty
                  ? localizations.rentAmountValidationError
                  : null,
            ),
            TextFormField(
              controller: _leaseAmountController,
              decoration:
                  InputDecoration(labelText: localizations.leaseAmountLabel),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty
                  ? localizations.leaseAmountValidationError
                  : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newShop = Shop(
                    id: DateTime.now().toString(),
                    name: _nameController.text,
                    description: _descriptionController.text,
                    rentAmount: double.parse(_rentAmountController.text),
                    leaseAmount: double.parse(_leaseAmountController.text),
                    dateCreated: DateTime.now(),
                    isOccupied: false,
                  );
                  shopProvider.addShop(newShop);
                  Navigator.pop(context);
                }
              },
              child: Text(localizations.addShopButton),
            ),
          ],
        ),
      ),
    );
  }
}
