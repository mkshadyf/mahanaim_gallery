import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tenant.dart';

class TenantRepository {
  final CollectionReference _tenantsCollection =
      FirebaseFirestore.instance.collection('tenants');

  Future<List<Tenant>> fetchTenants() async {
    QuerySnapshot querySnapshot = await _tenantsCollection.get();
    return querySnapshot.docs
        .map((doc) => Tenant.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
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

  Future<void> addPayment(String tenantId, Payment payment) async {
    await _tenantsCollection.doc(tenantId).update({
      'payments': FieldValue.arrayUnion([payment.toMap()])
    });
  }
}
