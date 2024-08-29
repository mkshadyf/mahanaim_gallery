import 'package:flutter/foundation.dart';
import '../models/shop.dart';
import '../services/shop_service.dart';

class ShopProvider extends ChangeNotifier {
  final ShopService _shopService = ShopService();
  List<Shop> _shops = [];
  bool _isLoading = false;

  List<Shop> get shops => _shops;
  bool get isLoading => _isLoading;

  double get totalRevenue {
    return _shops.fold(0, (sum, shop) => sum + shop.rentAmount);
  }

  Future<void> loadShops() async {
    _isLoading = true;
    notifyListeners();
    _shops = await _shopService.fetchShops();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addShop(Shop shop) async {
    await _shopService.addShop(shop);
    await loadShops();
  }

  Future<void> updateShop(Shop shop) async {
    await _shopService.updateShop(shop);
    await loadShops();
  }

  Future<void> deleteShop(String shopId) async {
    await _shopService.deleteShop(shopId);
    await loadShops();
  }

  Future<void> addTenantToShop(String shopId, String tenantId) async {
    await _shopService.addTenantToShop(shopId, tenantId);
    await loadShops();
  }

  Future<void> removeTenantFromShop(String shopId, String tenantId) async {
    await _shopService.removeTenantFromShop(shopId, tenantId);
    await loadShops();
  }
}
