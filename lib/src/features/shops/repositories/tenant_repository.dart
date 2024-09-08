import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tenant.dart';

class TenantRepository {
  final CollectionReference _tenantsCollection =
      FirebaseFirestore.instance.collection('tenants');

  Future<List<Tenant>> fetchTenants({int limit = 20, String? lastTenantId}) async {
    Query query = _tenantsCollection.orderBy('name').limit(limit);

    if (lastTenantId != null) {
      DocumentSnapshot lastDoc = await _tenantsCollection.doc(lastTenantId).get();
      query = query.startAfterDocument(lastDoc);
    }

    QuerySnapshot querySnapshot = await query.get();
    return querySnapshot.docs
        .map((doc) => Tenant.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Tenant>> searchTenants(String query) async {
    QuerySnapshot querySnapshot = await _tenantsCollection
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + 'z')
        .get();

    return querySnapshot.docs
        .map((doc) => Tenant.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<Tenant?> fetchTenantById(String tenantId) async {
    DocumentSnapshot doc = await _tenantsCollection.doc(tenantId).get();
    if (doc.exists) {
      return Tenant.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> addTenant(Tenant tenant) async {
    await _tenantsCollection.add(tenant.toMap());
  }

  Future<void> updateTenant(Tenant tenant) async {
    await _tenantsCollection.doc(tenant.id).update(tenant.toMap());
  }

  Future<void> deleteTenant(String tenantId) async {
    await _tenantsCollection.doc(tenantId).delete();
  }

  Future<void> batchUpdateTenants(List<Tenant> tenants) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (var tenant in tenants) {
      DocumentReference docRef = _tenantsCollection.doc(tenant.id);
      batch.update(docRef, tenant.toMap());
    }
    await batch.commit();
  }
}
