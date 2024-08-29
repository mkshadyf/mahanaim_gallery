import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/shop_provider.dart';
import '../providers/tenant_provider.dart';
import '../models/shop.dart';
import '../models/tenant.dart';

class AddShopView extends StatefulWidget {
  const AddShopView({super.key});

  @override
  State<AddShopView> createState() => _AddShopViewState();
}

class _AddShopViewState extends State<AddShopView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rentAmountController = TextEditingController();
  final _contractLengthController = TextEditingController();
  DateTime _dateCreated = DateTime.now();
  List<Tenant> _selectedTenants = [];

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final tenantProvider = Provider.of<TenantProvider>(context);
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
              decoration: InputDecoration(labelText: localizations.shopNameLabel),
              validator: (value) => value!.isEmpty ? localizations.shopNameValidationError : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: localizations.shopDescriptionLabel),
              validator: (value) => value!.isEmpty ? localizations.shopDescriptionValidationError : null,
            ),
            MultiSelectChip(
              tenantProvider.tenants,
              onSelectionChanged: (selectedList) {
                setState(() {
                  _selectedTenants = selectedList;
                });
              },
            ),
            TextFormField(
              controller: _rentAmountController,
              decoration: InputDecoration(labelText: localizations.rentAmountLabel),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? localizations.rentAmountValidationError : null,
            ),
            TextFormField(
              controller: _contractLengthController,
              decoration: InputDecoration(labelText: localizations.contractLengthLabel),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? localizations.contractLengthValidationError : null,
            ),
            ListTile(
              title: Text(localizations.dateCreatedLabel),
              subtitle: Text(_dateCreated.toString()),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _dateCreated,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025),
                );
                if (picked != null && picked != _dateCreated) {
                  setState(() {
                    _dateCreated = picked;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
  onPressed: () {
    if (_formKey.currentState!.validate()) {
      shopProvider.addShop(Shop(
        id: DateTime.now().toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        tenantIds: _selectedTenants.map((t) => t.id).toList(),
        dateCreated: _dateCreated,
        rentAmount: double.parse(_rentAmountController.text),
        isAvailable: true,
      ));
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

class MultiSelectChip extends StatefulWidget {
  final List<Tenant> tenantList;
  final Function(List<Tenant>) onSelectionChanged;

  const MultiSelectChip(this.tenantList, {super.key, required this.onSelectionChanged});

  @override
  State<MultiSelectChip> createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<Tenant> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];

    for (var item in widget.tenantList) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item.name),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    }

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
