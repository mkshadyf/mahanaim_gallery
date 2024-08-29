import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shop.dart';

class ShopRepository {
  final CollectionReference _shopsCollection =
      FirebaseFirestore.instance.collection('shops');

  Future<List<Shop>> fetchShops() async {
    QuerySnapshot querySnapshot = await _shopsCollection.get();
    return querySnapshot.docs
        .map((doc) => Shop.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addShop(Shop shop) async {
    await _shopsCollection.add(shop.toMap());
  }

  Future<void> updateShop(Shop shop) async {
    await _shopsCollection.doc(shop.id).update(shop.toMap());
  }

  Future<void> deleteShop(String shopId) async {
    await _shopsCollection.doc(shopId).delete();
  }

  Future<void> addTenantToShop(String shopId, String tenantId) async {
    await _shopsCollection.doc(shopId).update({
      'tenantIds': FieldValue.arrayUnion([tenantId])
    });
  }

  Future<void> removeTenantFromShop(String shopId, String tenantId) async {
    await _shopsCollection.doc(shopId).update({
      'tenantIds': FieldValue.arrayRemove([tenantId])
    });
  }
}
