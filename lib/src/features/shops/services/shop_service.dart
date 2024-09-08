import '../models/shop.dart';
import '../repositories/shop_repository.dart';

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

  Future<void> addRentPayment(String shopId, RentPayment payment)