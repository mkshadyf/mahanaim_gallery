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

  Future<void> addTenantToShop(String shopId, String tenantId) async {
    await _shopRepository.addTenantToShop(shopId, tenantId);
  }

  Future<void> removeTenantFromShop(String shopId, String tenantId) async {
    await _shopRepository.removeTenantFromShop(shopId, tenantId);
  }
}
