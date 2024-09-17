import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mahanaim_gallery/src/features/shops/providers/shop_provider.dart';
import 'package:mahanaim_gallery/src/features/shops/models/shop.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShopListView extends StatefulWidget {
  const ShopListView({super.key});

  @override
  State<ShopListView> createState() => _ShopListViewState();
}

class _ShopListViewState extends State<ShopListView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShopProvider>(context, listen: false).loadShops();
    });
  }

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.shopsTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: localizations.searchShopsHint,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (query) {
                shopProvider.searchShops(query);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: shopProvider.shops.length,
              itemBuilder: (context, index) {
                Shop shop = shopProvider.shops[index];
                return ListTile(
                  title: Text(shop.name),
                  subtitle: Text(shop.tenant != null
                      ? shop.tenant!.name
                      : localizations.noTenantAssigned),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/shop_details',
                      arguments: shop,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_shop');
        },
        tooltip: localizations.addShopTooltip,
        child: const Icon(Icons.add),
      ),
    );
  }
}
