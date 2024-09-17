import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahanaim_gallery/src/features/shops/models/tenant.dart';

class TenantRepository {
  final CollectionReference _tenantsCollection =
      FirebaseFirestore.instance.collection('tenants');

  Future<List<Tenant>> fetchTenants() async {
    final querySnapshot = await _tenantsCollection.get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Tenant.fromMap(data);
    }).toList();
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
}
