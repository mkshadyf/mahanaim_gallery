import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shop.dart';

class ShopRepository {
  final CollectionReference _shopsCollection =
      FirebaseFirestore.instance.collection('shops');

  Future<List<Shop>> fetchShops({int limit = 20, String? lastShopId}) async {
    Query query = _shopsCollection.orderBy('name').limit(limit);

    if (lastShopId != null) {
      DocumentSnapshot lastDoc = await _shopsCollection.doc(lastShopId).get();
      query = query.startAfterDocument(lastDoc);
    }

    QuerySnapshot querySnapshot = await query.get();
    return querySnapshot.docs
        .map((doc) => Shop.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Shop>> searchShops(String query) async {
    QuerySnapshot querySnapshot = await _shopsCollection
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: '${query}z')
        .get();

    return querySnapshot.docs
        .map((doc) => Shop.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<Shop?> fetchShopById(String shopId) async {
    DocumentSnapshot doc = await _shopsCollection.doc(shopId).get();
    if (doc.exists) {
      return Shop.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
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

  Future<void> addRentPayment(String shopId, RentPayment payment) async {
    await _shopsCollection.doc(shopId).update({
      'rentPayments': FieldValue.arrayUnion([payment.toMap()])
    });
  }
}
