import 'package:flutter/foundation.dart';
import '../models/shop.dart';
import '../services/shop_service.dart';

class ShopProvider extends ChangeNotifier {
  final ShopService _shopService = ShopService();
  List<Shop> _shops = [];
  bool _isLoading = false;
  String? _error;

  List<Shop> get shops => _shops;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadShops() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _shops = await _shopService.fetchShops();
    } catch (e) {
      _error = 'Failed to load shops: $e';
    }

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

  Future<void> searchShops(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _shops = await _shopService.searchShops(query);
    } catch (e) {
      _error = 'Failed to search shops: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addRentPayment(String shopId, RentPayment payment) async {
    await _shopService.addRentPayment(shopId, payment);
    await loadShops();
  }

  double get totalRevenue {
    return _shops.fold(0, (sum, shop) => sum + shop.rentAmount);
  }

  double get occupancyRate {
    if (_shops.isEmpty) return 0;
    int occupiedShops = _shops.where((shop) => !shop.isAvailable).length;
    return occupiedShops / _shops.length;
  }

  int get overduePayments {
    return _shops.fold(0, (sum, shop) => sum + (shop.isPaymentOverdue() ? 1 : 0));
  }
}