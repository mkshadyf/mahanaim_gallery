import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahanaim_gallery/src/features/shops/models/shop.dart';

class ShopRepository {
  final CollectionReference _shopsCollection =
      FirebaseFirestore.instance.collection('shops');

  Future<List<Shop>> fetchShops() async {
    final querySnapshot = await _shopsCollection.get();
    return querySnapshot.docs.map((doc) {
      return Shop.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
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

  Future<List<Shop>> searchShops(String query) async {
    final querySnapshot = await _shopsCollection
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + 'z')
        .get();
    return querySnapshot.docs.map((doc) {
      return Shop.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<Shop?> fetchShopById(String shopId) async {
    final docSnapshot = await _shopsCollection.doc(shopId).get();
    if (docSnapshot.exists) {
      return Shop.fromMap(docSnapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<void> addRentPayment(String shopId, RentPayment payment) async {
    final shopDoc = _shopsCollection.doc(shopId);
    final shopData = (await shopDoc.get()).data() as Map<String, dynamic>;
    final payments = (shopData['rentPayments'] as List<dynamic>?) ?? [];
    payments.add(payment.toMap());
    await shopDoc.update({'rentPayments': payments});
  }
}