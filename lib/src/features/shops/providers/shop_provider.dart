import 'package:flutter/foundation.dart';
import '../models/shop.dart';
import '../repositories/shop_repository.dart';

class ShopProvider extends ChangeNotifier {
  final ShopRepository _shopRepository = ShopRepository();
  List<Shop> _shops = [];
  List<Shop> _searchResults = [];
  bool _isLoading = false;

  List<Shop> get shops => _searchResults.isEmpty ? _shops : _searchResults;
  bool get isLoading => _isLoading;

  Future<void> loadShops() async {
    _isLoading = true;
    notifyListeners();
    try {
      _shops = await _shopRepository.fetchShops();
    } catch (e) {
      print('Error loading shops: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addShop(Shop shop) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _shopRepository.addShop(shop);
      await loadShops();
    } catch (e) {
      print('Error adding shop: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateShop(Shop shop) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _shopRepository.updateShop(shop);
      await loadShops();
    } catch (e) {
      print('Error updating shop: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  double get totalRevenue {
    double total = 0;
    for (var shop in _shops) {
      total += shop.rentAmount;
      total += shop.leaseAmount;
      for (var payment in shop.rentPayments) {
        total += payment.amount;
      }
    }
    return total;
  }

  Future<void> deleteShop(String shopId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _shopRepository.deleteShop(shopId);
      await loadShops();
    } catch (e) {
      print('Error deleting shop: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  String getPaymentStatusForTenant(String tenantId) {
    // Find the shop where the tenant is currently residing
    final shop = _shops.firstWhere(
      (shop) => shop.tenant != null && shop.tenant!.id == tenantId,
      orElse: () => Shop(
          id: "",
          name: "",
          description: "",
          rentAmount: 0,
          leaseAmount: 0,
          dateCreated: DateTime.now(),
          contractLength: 0,
          isOccupied: false), // Return an empty shop if not found
    );

    // Determine payment status based on shop's logic
    if (shop.name.isNotEmpty) {
      // Check if a shop was found
      if (shop.isPaymentOverdue()) {
        return 'Overdue';
      } else {
        return 'Paid';
      }
    } else {
      return 'N/A'; // Or any other appropriate status
    }
  }

  Future<void> addRentPayment(String shopId, RentPayment payment) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _shopRepository.addRentPayment(shopId, payment);
      // After adding the payment, you might want to update the shop data
      await loadShops(); // Or fetch the updated shop data specifically
    } catch (e) {
      print('Error adding rent payment: $e');
      // Handle error, maybe show an error message
    }
    _isLoading = false;
    notifyListeners();
  }

  void searchShops(String query) {
    if (query.isEmpty) {
      _searchResults = [];
    } else {
      _searchResults = _shops
          .where((shop) =>
              shop.name.toLowerCase().contains(query.toLowerCase()) ||
              (shop.tenant != null &&
                  shop.tenant!.name
                      .toLowerCase()
                      .contains(query.toLowerCase())))
          .toList();
    }
    notifyListeners();
  }
}
