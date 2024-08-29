import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shop_provider.dart';
import 'shop_details_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShopListView extends StatelessWidget {
  const ShopListView({super.key});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.shopListTitle),
      ),
      body: shopProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: shopProvider.shops.length,
              itemBuilder: (context, index) {
                final shop = shopProvider.shops[index];
                return Card(
                  child: ListTile(
                    title: Text(shop.name),
                    subtitle: Text(shop.description),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShopDetailsView(shop: shop),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.pushNamed(context, '/add_shop');
  },
  child: const Icon(Icons.add),
),
    );
  }
}
