import 'package:mahanaim_gallery/src/features/shops/models/shop.dart';
import 'package:mahanaim_gallery/src/features/shops/models/payment.dart';
import 'package:mahanaim_gallery/src/features/shops/repositories/shop_repository.dart';

class ShopService {
  final ShopRepository _shopRepository = ShopRepository();

  Future<List<Shop>> fetchShops() async {
    return await _shopRepository.fetchShops();
  }

  Future<void> addShop(Shop shop) async {
    await _shopRepository.addShop(shop);
  }

  Future<void> updateShop(Shop shop) async {
    await _shopRepository.updateShop(shop);
  }

  Future<void> deleteShop(String shopId) async {
    await _shopRepository.deleteShop(shopId);
  }

  Future<List<Shop>> searchShops(String query) async {
    return await _shopRepository.searchShops(query);
  }

  Future<Shop?> fetchShopById(String shopId) async {
    return await _shopRepository.fetchShopById(shopId);
  }

  Future<void> addRentPayment(Payment payment) async {
    await _shopRepository.addRentPayment(payment);
  }
}
