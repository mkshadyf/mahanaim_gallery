import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahanaim_gallery/src/features/shops/models/shop.dart';
import 'package:mahanaim_gallery/src/features/shops/models/payment.dart';

class ShopRepository {
  final CollectionReference _shopsCollection =
      FirebaseFirestore.instance.collection('shops');
  final CollectionReference _paymentsCollection =
      FirebaseFirestore.instance.collection('payments');

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

  Future<void> addRentPayment(Payment payment) async {
    await _paymentsCollection.add(payment.toMap());
  }
}
